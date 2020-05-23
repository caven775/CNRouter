//
//  ViewController.m
//  CNRouterDemo
//
//  Created by Caven on 2020/5/23.
//  Copyright © 2020 Caven. All rights reserved.
//

#import "ViewController.h"
#import <CNRouter.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"ViewController";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[CNRouter sharedRouter] route:@"https://github.com/haixi595282775/CNRouter"];
}


@end
