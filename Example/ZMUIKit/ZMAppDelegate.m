//
//  ZMAppDelegate.m
//  ZMUIKit
//
//  Created by lazyloading@163.com on 05/23/2020.
//  Copyright (c) 2020 lazyloading@163.com. All rights reserved.
//

#import "ZMAppDelegate.h"
#import <ZMUIKit.h>
#import "ZMViewController.h"

@implementation ZMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [self setupRoot];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark --> 🐷 Private Method 🐷
- (void)setupRoot {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    ZMTabbarController *tabVC = [[ZMTabbarController alloc]init];
    
    ZMViewController *homeVC = [[ZMViewController alloc]init];
    ZMNavigationController *homeNav = [[ZMNavigationController alloc]initWithRootViewController:homeVC];
    homeNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"dykit_home"] selectedImage:[UIImage imageNamed:@"dykit_home"]];
//
//    DYOtherViewController *otherVC = [[DYOtherViewController alloc]init];
//    ZMNavigationController *otherNav = [[ZMNavigationController alloc]initWithRootViewController:otherVC];
//    otherNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"other" image:[UIImage imageNamed:@"dykit_other"] selectedImage:[UIImage imageNamed:@"dykit_other"]];
    
    tabVC.viewControllers = @[homeNav];
    tabVC.tabBar.tintColor = [UIColor colorWithRed:98/256.f green:175/256.f blue:235/256.f alpha:1];
    self.window.rootViewController = tabVC;
    self.window.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.window makeKeyAndVisible];

}
@end
