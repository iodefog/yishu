//
//  IServices+Event.m
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "IServices+Event.h"

@implementation IServices (Event)

+ (void)getEventList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSInteger zone = [[param objectForKey:@"zone"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"event/_recent"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@&zone=%@", @(from), @(size), @(zone)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"event/view/%@", [param objectForKey:@"sysid"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getEventByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"event/%@", [param objectForKey:@"eventid"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getRecommendEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"recommend?channel=%@",[param objectForKey:@"channel"]] method:@"GET" params:param success:success failure:failure];
}

@end
