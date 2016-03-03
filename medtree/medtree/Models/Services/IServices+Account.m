//
//  IServices+Account.m
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "IServices+Account.h"

@implementation IServices (Account)

+ (void)login:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/login" method:@"POST" params:param success:success failure:failure];
}

+ (void)logout:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/logout" method:@"POST" params:param success:success failure:failure];
}

+ (void)reg:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register" method:@"POST" params:param success:success failure:failure];
}

+ (void)registerAllInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/all" method:@"POST" params:param success:success failure:failure];
}

@end
