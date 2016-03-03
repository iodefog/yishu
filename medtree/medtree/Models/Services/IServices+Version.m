//
//  IServices+Version.m
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Version.h"
#import "DateUtil.h"

@implementation IServices (Version)

+ (void)checkVersion:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *url = [NSString stringWithFormat:@"release/update/?os=%@&version=%@&revision=%@&channel=%@&device=%@&package=%@", [param objectForKey:@"os"], [param objectForKey:@"version"], [param objectForKey:@"revision"], [param objectForKey:@"channel"], [param objectForKey:@"device"], [param objectForKey:@"package"]];
    [request requestAction:url method:@"GET" params:param version:0 success:success failure:failure];
}

+ (void)checkConfigUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *url = [NSString stringWithFormat:@"misc/app_config?w=%0.0f&h=%0.0f&tamp=%@",[[UIScreen mainScreen] currentMode].size.width,[[UIScreen mainScreen] currentMode].size.height,[DateUtil convertNumberFromTime1000:[NSDate date]]];
    [request requestAction:url method:@"GET" params:param version:1 success:success failure:failure];
}

+ (void)updateAPNS:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *url = @"message/_update_apns_info";
    [request requestAction:url method:@"POST" params:param version:1 success:success failure:failure];
}

+ (void)getIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *url = @"im/servers";
    [request requestAction:url method:@"GET" params:param version:1 success:success failure:failure];
}

@end
