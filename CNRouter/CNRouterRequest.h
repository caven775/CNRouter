//
//  CNRouterRequest.h
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "CNRouterDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface CNRouterRequest : NSObject

/// 动画
@property (nonatomic, assign) BOOL animated;
/// 携带参数
@property (nonatomic, strong, nullable) id params;
/// host
@property (nonatomic, copy, nonnull) NSString *host;
/// path
@property (nonatomic, copy, nonnull) NSString *path;
/// scheme
@property (nonatomic, copy, nonnull) NSString *scheme;
/// route
@property (nonatomic, copy, nonnull) NSString *route;
/// 进场类型
@property (nonatomic, assign) CNRouterAnimationStyle style;
/// query
@property (nonatomic, strong, nullable) NSDictionary *query;
/// 页面回调
@property (nonatomic, copy, nullable) CNRouterRequestCallBack callBack;
/// present类型
@property(nonatomic,assign) UIModalPresentationStyle modalPresentationStyle;
/// storyboard
@property (nonatomic, copy, nullable) NSString *storyboard;
/// storyboard Bundle
@property (nonatomic, strong, nullable) NSBundle *storyboardBundle;
/// storyboard identifier
@property (nonatomic, copy, nullable) NSString *storyboardIdentifier;

@end

NS_ASSUME_NONNULL_END
