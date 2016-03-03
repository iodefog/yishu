//
//  IServices+Statistic.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Statistic.h"

@implementation IServices (Statistic)

+ (void)sendStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"diagnose/behavior" method:@"POST" params:param success:success failure:failure];
}

+ (void)sendUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"message/unread" method:@"GET" params:param success:success failure:failure];
}

+ (void)readUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"message/_unread_count" method:@"GET" params:param success:success failure:failure];
}

@end
