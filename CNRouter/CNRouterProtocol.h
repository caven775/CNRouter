//
//  CNRouterProtocol.h
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNRouterRequest;

NS_ASSUME_NONNULL_BEGIN

@protocol CNRouterProtocol <NSObject>

@required
+ (NSString *)cn_registerRoute;


@optional
- (void)cn_routeForReuqest:(CNRouterRequest *)request;


@end

NS_ASSUME_NONNULL_END
