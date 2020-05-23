//
//  AppDelegate.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "AppDelegate.h"
#import <CNRouter.h>
#import "ViewController.h"
#import "NavigationViewController.h"

@interface AppDelegate () <CNRouterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    ViewController *vc = [[ViewController alloc] init];
    NavigationViewController *rootVC = [[NavigationViewController alloc] initWithRootViewController:vc];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootVC;
    [self.window makeKeyAndVisible];

    [[CNRouter sharedRouter] startWithHostName:@"https://www.baidu.com" delegate:self];
    return YES;
}

- (UINavigationController *)router:(CNRouter *)router navigationControllerForRoute:(NSString *)route
{
    return (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

- (UIViewController *)router:(CNRouter *)router viewControllerForRoute:(NSString *)route
{
    UINavigationController *nav = [self router:router navigationControllerForRoute:route];
    return nav.visibleViewController;
}

@end
