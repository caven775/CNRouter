//
//  CNRouterDefine.h
//  Pods
//
//  Created by Caven on 2020/5/23.
//

#ifndef CNRouterDefine_h
#define CNRouterDefine_h
#import <Foundation/Foundation.h>

typedef void(^CNRouterRequestCallBack)(_Nullable id params);

typedef NS_ENUM(NSInteger, CNRouterAnimationStyle) {
    CNRouterAnimationStylePush,
    CNRouterAnimationStylePresent,
    CNRouterAnimationStyleCustom
};

#endif /* CNRouterDefine_h */
