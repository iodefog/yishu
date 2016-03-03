//
//  ClickUtil.m
//  zhihuhd
//
//  Created by 无忧 on 13-11-5.
//  Copyright (c) 2013年 mobimac. All rights reserved.
//

#import "ClickUtil.h"
#import "MKNetworkEngine.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "CommonManager.h"

@implementation ClickUtil

+ (void)setLogEnabled:(BOOL)value
{
    [MobClick setLogEnabled:value];
}

+ (void)startWithAppkey:(NSString *)appid reportPolicy:(ReportPolicy)reportPolicy channelId:(NSString *)channelId
{
    [MobClick startWithAppkey:appid reportPolicy:reportPolicy channelId:channelId];
}

+ (void)clickEvent:(NSString *)event
{
    [MobClick event:event];
}

+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [info setObject:@"IOS" forKey:@"client"];
    [info setObject:XcodeAppVersion forKey:@"version"];
    
    if ([AccountHelper getLoginState]) {
        [info setObject:[[AccountHelper getAccount] userID] forKey:@"user_id"];
    }
    if (info.allKeys.count > 0) {
        [MobClick event:eventId attributes:info];
    } else {
        [ClickUtil clickEvent:eventId];
    }
    [ClickUtil sendEvent:eventId attributes:attributes];
}

+ (void)beginEvent:(NSString *)eventId
{
    [MobClick beginEvent:eventId];
}

+ (void)endEvent:(NSString *)eventId
{
    [MobClick endEvent:eventId];
}

+ (void)sendEvent:(NSString *)eventId attributes:(NSDictionary *)attributes
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:eventId forKey:@"app_event_id"];
    [dict setObject:@"IOS" forKey:@"client"];
    [dict setObject:XcodeAppVersion forKey:@"version"];
    if ([AccountHelper getLoginState]) {
        [dict setObject:[[AccountHelper getAccount] userID] forKey:@"user_id"];
    }
    if (attributes) {
        [dict addEntriesFromDictionary:attributes];
    }
        
    [CommonManager appEventCollect:dict success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

@end
