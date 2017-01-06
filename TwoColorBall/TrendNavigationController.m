//
//  TCBNavigationController.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "TrendNavigationController.h"
#import "TrendViewController.h"

@interface TrendNavigationController ()

@end

@implementation TrendNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 屏幕方向
// 是否支持转屏。
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些转屏方向。
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

// 默认的屏幕方向。
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
