//
//  AppDelegate.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "AppDelegate.h"
#import "YALaunchViewController.h"
#import "YARootViewController.h"

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 监测网络状态
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    // 导航栏标题字体
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    

    // 导航栏back按钮(edge调整)
    UIImage *backButtonImage = [kGetImage(@"Dark_News_Arrow") resizableImageWithCapInsets:UIEdgeInsetsMake(0, 18, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -backButtonImage.size.height * 2) forBarMetrics:UIBarMetricsDefault];

    // 设置状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    
       
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    self.window.rootViewController = [[YARootViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    //设置背景图
    YALaunchViewController *launchViewController = [[YALaunchViewController alloc] init];

    
    //把背景图放在最上层
     launchViewController.view.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [self.window addSubview:launchViewController.view];
    
    /*
     笔记
     1,设置tableView分割线全屏 可直接在cell 的xib中设置分割线 间距(默认距左边15)
    
     2,在xib中添加ScrollView时,先添加Scrollview再添加内容View
     要设置内容View与ScrollView间距为0,同时根据竖屏滚动或横屏滚动设置Horizontally in container 或 Vertically in container
     设置内容View的高度以改正xib中的报错,在代码中添加高度属性,动态改变

 导航栏框架 : 渐变LTNavigationBar

     */
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
