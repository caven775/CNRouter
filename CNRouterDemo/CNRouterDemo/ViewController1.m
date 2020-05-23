//
//  ViewController1.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "ViewController1.h"
#import <CNRouter.h>

@interface ViewController1 () <CNRouterProtocol>

@end

@implementation ViewController1

CNRouterRegister(@"https://github.com/haixi595282775/CNRouter");

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"ViewController1";
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[CNRouter sharedRouter] route:@"/home/detail" params:@[@"数据"]];
}

@end
