//
//  WZMAppDelegate.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAppDelegate.h"
#import <WZMKit/WZMKit.h>
#import "WZMViewController.h"

@implementation WZMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [WZMViewController new];
    
    WZMDispatch_after(2, ^{
        WZMAlertView *alertView = [[WZMAlertView alloc] initWithTitle:@"提示" message:@"恭喜你，集成成功！" OKButtonTitle:@"确定" cancelButtonTitle:@"取消" type:WZMAlertViewTypeNormal];
        [alertView showAnimated:YES];
    });
    
#if DEBUG
    wzm_openLogEnable(YES);
    [WZMLogView startLog];
    [self.window wzm_startObserveFpsAndCpu];
    WZMInstallUncaughtExceptionHandler();
    WZMInstallSignalHandler();
#endif
    
    NSLog(@"哈哈哈哈");
    
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

@end
