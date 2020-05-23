//
//  CNRouter.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "CNRouter.h"
#import "CNRouterRequest.h"
#import <objc/runtime.h>

typedef NSString *CNRouterName;
typedef NSString *CNRouterNameClass;

@interface CNRouter ()

@property (nonatomic, assign) BOOL mappedRoute;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, strong) dispatch_queue_t routeQueue;
@property (nonatomic, weak, nullable) id<CNRouterDelegate>delegate;
@property (nonatomic, strong) NSMutableDictionary <CNRouterName, CNRouterNameClass>*routes;

@end

@implementation CNRouter

+ (instancetype)sharedRouter
{
    static CNRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}
- (void)startWithHostName:(NSString *)hostName delegate:(id<CNRouterDelegate>)delegate
{
    _hostName = hostName;
    _delegate = delegate;
    dispatch_async(self.routeQueue, ^{
        [self.routes addEntriesFromDictionary:[self _mapRouters]];
    });
}

- (BOOL)route:(NSString *)route
{
    return [self route:route params:nil animated:YES style:CNRouterAnimationStylePush callBack:nil];
}

- (BOOL)route:(NSString *)route params:(id)params
{
    return [self route:route params:params animated:YES style:CNRouterAnimationStylePush callBack:nil];
}

- (BOOL)route:(NSString *)route params:(id)params animated:(BOOL)animated
{
    return [self route:route params:params animated:animated style:CNRouterAnimationStylePush callBack:nil];
}

- (BOOL)route:(NSString *)route params:(id)params animated:(BOOL)animated style:(CNRouterAnimationStyle)style
{
    return [self route:route params:params animated:animated style:style callBack:nil];
}

- (BOOL)route:(NSString *)route params:(id)params animated:(BOOL)animated style:(CNRouterAnimationStyle)style  callBack:(CNRouterRequestCallBack)callBack
{
    NSAssert(route.length, @"route 不合法");
    CNRouterRequest *request = [self checkRoute:route];
    request.params = params;
    request.callBack = callBack;
    request.style = style;
    request.animated = animated;
    return [self openRouteWithRequest:request];
}

- (BOOL)route:(NSString *)route request:(CNRouterRequest *)request
{
    NSAssert(route.length, @"route 不合法");
    CNRouterRequest *_request = [self checkRoute:request.route];
    _request.params = request.params;
    _request.callBack = request.callBack;
    _request.style = request.style;
    _request.animated = request.animated;
    _request.storyboard = request.storyboard;
    _request.storyboardBundle = request.storyboardBundle;
    _request.storyboardIdentifier = request.storyboardIdentifier;
    _request.modalPresentationStyle = request.modalPresentationStyle;
    return [self openRouteWithRequest:_request];
}


#pragma mark - private

- (CNRouterRequest *)checkRoute:(NSString *)route
{
    NSURL *routeUrl = [NSURL URLWithString:[self wrapRoute:route retainQuery:YES]];
    CNRouterRequest *request = [[CNRouterRequest alloc] init];
    request.host = routeUrl.host;
    request.scheme = routeUrl.scheme;
    request.path = routeUrl.path;
    request.query = [self queryFromURL:routeUrl];
    request.route = routeUrl.absoluteString;
    return request;
}

- (NSDictionary *)queryFromURL:(NSURL *)url
{
    if (!url) { return nil;}
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSURLComponents *compenents = [NSURLComponents componentsWithString:url.absoluteString];
    if (compenents && compenents.queryItems) {
        [compenents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [dictionary setObject:(obj.value ? obj.value : [NSNull null]) forKey:obj.name];
        }];
        return dictionary.copy;
    }
    return nil;
}

- (NSString *)wrapRoute:(NSString *)route retainQuery:(BOOL)retainQuery
{
    NSAssert(route.length, @"route 不存在");
    NSURL *routeUrl = [NSURL URLWithString:route];
    if (!routeUrl.host) {
        NSString *host = _hostName;
        if ([host hasSuffix:@"/"]) {
            host = [_hostName substringToIndex:_hostName.length - 1];
        }
        if ([route hasPrefix:@"/"]) {
            route = [NSString stringWithFormat:@"%@%@", _hostName, route];
        } else {
            route = [NSString stringWithFormat:@"%@/%@", _hostName, route];
        }
        routeUrl = [NSURL URLWithString:route];
    }
    if (retainQuery) {
        return routeUrl.absoluteString;
    }
    return [[[routeUrl.scheme stringByAppendingString:@"://"]
             stringByAppendingString:routeUrl.host]
            stringByAppendingString:routeUrl.path];
}

- (BOOL)openRouteWithRequest:(CNRouterRequest *)request
{
    if (!self.delegate) { return NO;}
    UIViewController *(^getController)(CNRouterRequest *) = ^UIViewController *(CNRouterRequest *q) {
        NSString *key = q.route;
        if (request.query.allKeys) {
            key = [[[q.scheme stringByAppendingString:@"://"]
             stringByAppendingString:q.host]
            stringByAppendingString:q.path];
        }
        if (q.storyboard && q.storyboardIdentifier && q.storyboardBundle) {
            UIViewController *instance = nil;
            @try {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:q.storyboard bundle:q.storyboardBundle];
                instance = [storyboard instantiateViewControllerWithIdentifier:q.storyboardIdentifier];
            } @catch (NSException *exception) {
#if DEBUG
                NSLog(@"CNRouter == %@", exception);
#endif
            } @finally {
                return instance;
            }
        } else {
            NSString *routeClass = self.routes[key];
            if (routeClass) {
                Class cls = NSClassFromString(routeClass);
                if (cls && object_isClass(object_getClass(UIViewController.class))) {
                    UIViewController *instance = [[cls alloc] init];
                    if ([instance conformsToProtocol:@protocol(CNRouterProtocol)] &&
                        [instance respondsToSelector:@selector(cn_routeForRequest:)]) {
                        [(id)instance cn_routeForRequest:q];
                    }
                    return instance;
                }
            }
        }
        return nil;
    };
    
    __block BOOL success = NO;
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            success = [self _openController:getController(request) request:request];
        });
    } else {
        success = [self _openController:getController(request) request:request];
    }
    return success;
}

- (BOOL)_openController:(UIViewController *)controller request:(CNRouterRequest *)request
{
    if (!controller) { return NO;}
    if (request.style == CNRouterAnimationStylePush) {
        BOOL success = [self.delegate respondsToSelector:@selector(router:navigationControllerForRoute:)];
        if (!success) {
            NSAssert(success, @"请实现代理router:navigationControllerForRoute:");
            return success;
        }
        UINavigationController *navigationController = [self.delegate router:self
                                                navigationControllerForRoute:request.route];
        if (!navigationController) { return NO;}
        [navigationController pushViewController:controller animated:request.animated];
        return YES;
    } else if (request.style == CNRouterAnimationStylePresent) {
        BOOL success = [self.delegate respondsToSelector:@selector(router:viewControllerForRoute:)];
        if (!success) {
            NSAssert(success, @"请实现代理router:viewControllerForRoute:");
            return success;
        }
        UIViewController *present = [self.delegate router:self viewControllerForRoute:request.route];
        if (!present) { return NO;}
        if (@available(iOS 13, *)) {
            controller.modalPresentationStyle = request.modalPresentationStyle;
        }
        [present presentViewController:controller animated:request.animated completion:nil];
        return YES;
    }
    return NO;
}

#pragma mark - getter

- (NSMutableDictionary<CNRouterName, CNRouterNameClass> *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _routes;
}

- (dispatch_queue_t)routeQueue
{
    if (!_routeQueue) {
        _routeQueue = dispatch_queue_create("com.cn.route.map.queue", NULL);
    }
    return _routeQueue;
}

- (NSMutableDictionary *)_mapRouters
{
    if (_mappedRoute) { return self.routes;}
    int numClasses;
    Class *classes = NULL;
    numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        NSMutableDictionary *routes = [[NSMutableDictionary alloc] init];
        classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; i++) {
            Class class = classes[i];
            const char *className = class_getName(class);
            NSString *nameString = [[NSString alloc] initWithCString:className encoding:NSUTF8StringEncoding];
            Class cls = NSClassFromString(nameString);
            if (cls != NULL) {
                Class metaCls = object_getClass(class);
                if (class_conformsToProtocol(metaCls, @protocol(CNRouterProtocol)) &&
                    class_respondsToSelector(metaCls, @selector(cn_registerRoute))) {
                    NSString *_route = [self wrapRoute:[cls cn_registerRoute] retainQuery:NO];
                    NSString *assert = [NSString stringWithFormat:@"%@的route不可为空", nameString];
                    NSAssert(_route, assert);
                    [routes setValue:nameString forKey:_route];
                } else {
                    continue;
                }
            } else {
                continue;
            }
        }
        free(classes);
        _mappedRoute = YES;
        return routes;
    }
    _mappedRoute = YES;
    return @{};
}

@end
