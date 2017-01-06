//
//  AppDelegate.m
//  TwoColorBall
//
//  Created by 刘明 on 2016/12/22.
//  Copyright © 2016年 刘明. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 定制导航
// TODO: 好奇怪，在TCBNavigationController里设置无效？为什么？那个是我唯一的导航类啊。
- (void)customNavigation {
    // 全局设置导航条、Item。
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBackground"]
                 forBarMetrics:UIBarMetricsDefault];
//    navBar.translucent = NO;
    
    // 设置标题和按钮文字属性
    NSMutableDictionary *titleAttributes = [NSMutableDictionary dictionary];
    titleAttributes[NSFontAttributeName] = [UIFont systemFontOfSize:16.0f];
    titleAttributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    
    [navBar setTitleTextAttributes:titleAttributes];
    
    
    // 导航条上的Item
    UIImage *backNormalImage = [UIImage imageNamed:@"NavBackNormal"];
    UIImage *resizableBackNormalImage =
    [backNormalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backNormalImage.size.width, 0, 0)];
    [item setBackButtonBackgroundImage:resizableBackNormalImage
                              forState:UIControlStateNormal
                            barMetrics:UIBarMetricsDefault];
    
    // TODO: 不知道为什么高亮无效。出不来效果。
    UIImage *backHighlightedImage = [UIImage imageNamed:@"NavBackHighlighted"];
    UIImage *resizableBackHighlightedImage =
        [backHighlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backHighlightedImage.size.width, 0, 0)];
    [item setBackButtonBackgroundImage:resizableBackHighlightedImage
                              forState:UIControlStateHighlighted
                            barMetrics:UIBarMetricsDefault];
    
    [item setTitleTextAttributes:titleAttributes forState:UIControlStateNormal];
    
    // 消除返回按钮的文字
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                 forBarMetrics:UIBarMetricsDefault];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self customNavigation];
    
//    [NSThread sleepForTimeInterval:10.0]; //设置启动页面时间
    
    // Override point for customization after application launch.
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
