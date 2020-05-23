//
//  ViewController4.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "ViewController4.h"
#import <CNRouter.h>
#import <CNRouterRequest.h>

@interface ViewController4 () <CNRouterProtocol>

@end

@implementation ViewController4

CNRouterRegister(@"login/code")

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController4";
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)cn_routeForRequest:(CNRouterRequest *)reuqest
{
    NSLog(@"route ===== %@, param == %@, query == %@", reuqest.route, reuqest.params, reuqest.query);
}




@end
