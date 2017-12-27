//
//  AppDelegate.m
//  ThirdPartyShareLoginAndPay
//
//  Created by Gauss on 2017/12/27.
//  Copyright © 2017年 Gauss. All rights reserved.
//

#import "AppDelegate.h"
#import "CYMainTabBarViewController.h"
#import "ThirdPartyLoginAndShareManager.h"
#import "AlipayTool.h"
#import "CYLoginViewController.h"
#import "CYBaseNavigationViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //注册微信 QQ 微博
    [[ThirdPartyLoginAndShareManager sharedInstance] thirdPartyApplication:application didFinishLaunchingWithOptions:launchOptions];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[CYBaseNavigationViewController alloc] initWithRootViewController:[CYLoginViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark -------------------- 初始化AppDelegate ------------------------
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
//进入主控制器
-(void)enterMainController{
    [self restoreRootViewController:[CYMainTabBarViewController new]];
}
- (void)restoreRootViewController:(UIViewController *)rootViewController{
    typedef void (^Animation)(void);
    UIWindow* window = self.window;
    Animation animation = ^{
        BOOL oldState = [UIView areAnimationsEnabled];
        [UIView setAnimationsEnabled:NO];
        window.rootViewController = rootViewController;
        [UIView setAnimationsEnabled:oldState];
    };
    [UIView transitionWithView:window
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:animation
                    completion:nil];
}
#pragma mark --------------------三方登录分享相关---------------------------------
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [AlipayTool Alipay_application:application openURL:url sourceApplication:sourceApplication annotation:application];
    return [[ThirdPartyLoginAndShareManager sharedInstance] thirdPartyApplicationOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [AlipayTool Alipay_application:application handleOpenURL:url];
    return [[ThirdPartyLoginAndShareManager sharedInstance] thirdPartyApplicationHandleOpenURL:url];
    
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options{
    return [[ThirdPartyLoginAndShareManager sharedInstance] thirdPartyaApplication:app openURL:url options:options];
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
