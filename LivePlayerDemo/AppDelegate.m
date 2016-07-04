//
//  AppDelegate.m
//  LivePlayerDemo
//
//  Created by MingLQ on 2016-07-01.
//  Copyright © 2016年 GSX. All rights reserved.
//

#if DEBUG
#import <BJHL-Foundation-iOS/BJHL-Foundation-iOS.h>
#endif

#import "AppDelegate.h"

#import "BJLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#if DEBUG
    [BJCFLog setLogLevel:BJCF_LOG_FLAG_DEBUG];
#endif
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [BJLoginViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
