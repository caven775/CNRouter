//
//  ViewController2.m
//  
//
//  Created by Caven on 2020/5/23.
//

#import "ViewController2.h"
#import <CNRouter.h>
#import <CNRouterRequest.h>

@interface ViewController2 ()<CNRouterProtocol>

@end

@implementation ViewController2

CNRouterRegister(@"/home/detail");

- (void)cn_routeForRequest:(CNRouterRequest *)reuqest
{
    NSLog(@"route ===== %@, param == %@, query == %@", reuqest.route, reuqest.params, reuqest.query);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController2";
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[CNRouter sharedRouter] route:@"mine/about?id=100&name=2000" params:@{@"test": @"name"} animated:YES style:CNRouterAnimationStylePush callBack:^(id  _Nullable params) {
        NSLog(@"callBack == %@", params);
    }];
}


@end
