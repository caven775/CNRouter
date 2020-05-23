//
//  ViewController3.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "ViewController3.h"
#import <CNRouter.h>
#import <CNRouterRequest.h>

@interface ViewController3 () <CNRouterProtocol>

@property (nonatomic, strong)CNRouterRequest *request;

@end

@implementation ViewController3

CNRouterRegister(@"mine/about")

- (void)cn_routeForRequest:(CNRouterRequest *)reuqest
{
    NSLog(@"route ===== %@, param == %@, query == %@", reuqest.route, reuqest.params, reuqest.query);
    self.request = reuqest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController3";
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.request.callBack) {
        self.request.callBack(@"回调数据");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[CNRouter sharedRouter] route:@"login/code" params:@"婚纱的发挥"];
}

@end
