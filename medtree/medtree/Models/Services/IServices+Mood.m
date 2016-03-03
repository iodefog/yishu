//
//  IServices+Mood.m
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Mood.h"

@implementation IServices (Mood)

+ (void)getMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"mood"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)postMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"mood" method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"mood/%@",[param objectForKey:@"mood_id"]] method:@"DELETE" params:param success:success failure:failure];
}

+ (void)getMoodStatistics:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];

    NSMutableString *action = [NSMutableString stringWithFormat:@"mood/stats/date"];
    [action appendFormat:@"?date=%@",[param objectForKey:@"date"]];
    [action appendFormat:@"&step=%d&group=%d", [[param objectForKey:@"step"] intValue], [[param objectForKey:@"group"] intValue]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}



@end
