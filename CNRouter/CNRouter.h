//
//  CNRouter.h
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CNRouterProtocol.h"
#import "CNRouterDefine.h"

@protocol CNRouterDelegate;

#define CNRouterRegister(route) + (NSString *)cn_registerRoute \
{ \
    return route; \
} \



NS_ASSUME_NONNULL_BEGIN

@interface CNRouter : NSObject

+ (instancetype)sharedRouter;

/// 启动路由
/// @param hostName hostName
/// 如：https://www.baidu.com
/// 当页面返回的路由没有host时，会拼接该host
/// 当页面返回的路由有host时，以页面的为准
/// @param delegate 代理
- (void)startWithHostName:(NSString *)hostName
                 delegate:(nullable id<CNRouterDelegate>)delegate;

/// 进场
/// 默认push 带动画
/// @param route 路由
- (BOOL)route:(NSString *)route;

/// 进场
/// 默认push 带动画
/// @param route 路由
/// @param params 携带参数
- (BOOL)route:(NSString *)route
       params:(nullable id)params;

/// 进场
/// 默认push
/// @param route 路由
/// @param params 携带参数
/// @param animated 是否有进场动画
- (BOOL)route:(NSString *)route
       params:(nullable id)params
     animated:(BOOL)animated;

/// 进场
/// @param route  路由
/// @param params 携带参数
/// @param animated 是否有进场动画
/// @param style 进场风格
- (BOOL)route:(NSString *)route
       params:(nullable id)params
     animated:(BOOL)animated
        style:(CNRouterAnimationStyle)style;

/// 进场
/// @param route 路由
/// @param params 携带参数
/// @param animated 是否有进场动画
/// @param style 进场风格
/// @param callBack 回调
- (BOOL)route:(NSString *)route
       params:(nullable id)params
     animated:(BOOL)animated
        style:(CNRouterAnimationStyle)style
     callBack:(nullable CNRouterRequestCallBack)callBack;

/// 进场
/// @param route 路由
/// @param request request
- (BOOL)route:(NSString *)route
      request:(CNRouterRequest *)request;

@end

@protocol CNRouterDelegate <NSObject>

@optional
- (UIViewController *)router:(CNRouter *)router viewControllerForRoute:(NSString *)route;
- (UINavigationController *)router:(CNRouter *)router navigationControllerForRoute:(NSString *)route;

@end

NS_ASSUME_NONNULL_END
