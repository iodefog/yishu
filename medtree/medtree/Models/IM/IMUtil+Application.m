//
//  IMUtil+Application.m
//  medtree
//
//  Created by sam on 9/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "IMUtil+Application.h"
#import "StatisticHelper.h"
#import "JSONKit.h"
#import "AccountHelper.h"

@implementation IMUtil (Application)


#pragma mark RemoteNotification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
    if (token.length > 2) {
        token = [token substringWithRange:NSMakeRange(1, token.length-2)];
        //
        NSString *oldToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
        if ([token isEqualToString:oldToken] == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *payload = [[userInfo objectForKey:@"payload"] objectFromJSONString];
    [root didReceivedAPNS:payload];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [StatisticHelper addAction:StatisticAction_MT_APP_INACTIVE attr:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (ppTimer.isValid) {
        [ppTimer invalidate];
        ppTimer = nil;
    }
    [client disconnect];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    if ([AccountHelper getLoginState]) {
        [self startIM];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [StatisticHelper addAction:StatisticAction_MT_APP_ACTIVE attr:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [StatisticHelper addAction:StatisticAction_MT_APP_EXIT attr:nil];
}

@end
