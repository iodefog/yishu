//
//  AppDelegate.m
//  yishu
//
//  Created by sam on 8/7/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "NavigationController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "IMUtil.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "ShareHelper.h"
#import "AccountHelper.h"
#import "StatisticHelper.h"
//#import "UMSAgent.h"
#import "ClickUtil.h"
#import "RootViewController.h"
//#import <Fabric/Fabric.h>
//#import <Crashlytics/Crashlytics.h>
//#import "UncaughtExceptionHelper.h"
//#import "iConsole.h"

#import "WechatProxy.h"
#import "QQProxy.h"

@interface AppDelegate () <BMKGeneralDelegate, WXApiDelegate>

@end

@implementation AppDelegate 

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //百度地图
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    if (![mapManager start:@"HyBF6hTLpxeuZwXwTU4NKsWZ" generalDelegate:self]) {
        NSLog(@"BMKMap failed");
    }
    
    //微信
    [ShareHelper registerApps];
    
    
    //友盟统计
    [ClickUtil setLogEnabled:YES];
    [MobClick setAppVersion:XcodeAppVersion];
    [ClickUtil startWithAppkey:@"5640775367e58e7c720003c6" reportPolicy:REALTIME channelId:nil];
    
    [FontUtil setBarFontColor:[ColorUtil getColor:@"049597" alpha:1]];

    //分享
    [[Diplomat sharedInstance] registerWithConfigurations:@{ kDiplomatTypeWechat : @{ kDiplomatAppIdKey : @"wx0dfb8040a35093ee" },
                                                             kDiplomatTypeQQ : @{ kDiplomatAppIdKey: @"1103990638" } }];
    
    
#if !TARGET_IPHONE_SIMULATOR
    
#ifdef __IPHONE_8_0
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }  else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
#else
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
#endif
    
#endif

    // iConsole
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window = [[iConsoleWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [iConsole sharedConsole].simulatorTouchesToShow = YES;
//    [iConsole sharedConsole].deviceTouchesToShow = YES;
//    [iConsole sharedConsole].deviceShakeToShow = YES;
//    [Fabric with:@[CrashlyticsKit]];
    
    
    self.window.rootViewController = ({
        RootViewController *rootViewCOntroller = [RootViewController shareRootViewController];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:rootViewCOntroller];
        navigationController.navigationBarHidden = YES;
        navigationController;
    });
    
    [self.window makeKeyAndVisible];
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        [[IMUtil sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    }
    
    return YES;
}

#pragma mark -
#pragma mark - BMKGeneralDelegate -

- (void)onGetNetworkState:(int)iError
{
    NSLog(@"onGetNetworkState--%@", @(iError));
}

- (void)onGetPermissionState:(int)iError
{
    NSLog(@"onGetPermissionState--%@", @(iError));
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[IMUtil sharedInstance] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[IMUtil sharedInstance] applicationDidEnterBackground:application];
    [StatisticHelper closeTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[StatisticHelper shareInstance] checkUnRead];
    [StatisticHelper startTimer];
    [AccountHelper registerDevice];
    
    // Socket会断超时
    [[IMUtil sharedInstance] applicationWillEnterForeground:application];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[IMUtil sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[IMUtil sharedInstance] applicationWillTerminate:application];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[Diplomat sharedInstance] handleOpenURL:url];

   // return [ShareHelper openURL:url sourceApplication:sourceApplication source:self];
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[IMUtil sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[IMUtil sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[IMUtil sharedInstance] application:application didReceiveRemoteNotification:userInfo];
}

@end
