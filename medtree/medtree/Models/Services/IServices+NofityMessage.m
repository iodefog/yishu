//
//  IServices+NofityMessage.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IServices+NofityMessage.h"

@implementation IServices (NofityMessage)

+ (void)getLastestNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/message/notify/new" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getHistoryNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"/message/notify/history"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getPushJobList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"/message/job/assistant"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/im/refuse/config" method:@"GET" params:nil success:success failure:failure];
}

+ (void)putRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/im/refuse/config" method:@"PUT" params:nil success:success failure:failure];
}

//获得消息免打扰状态
+ (void)getDisturbState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/push/disturb/config" method:@"GET" params:nil success:success failure:failure];
}

//设置免打扰状态
+ (void)setDisturb:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/push/disturb/config" method:@"PUT" params:param success:success failure:failure];
}

@end
