//
//  IServices+Topic.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Topic.h"

@implementation IServices (Topic)

+ (void)getTopic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"topic"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getTopicFeeds:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"topic/%@/feeds", [param objectForKey:@"topic"]];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    NSInteger sort = [[param objectForKey:@"sort"] integerValue];
    [action appendFormat:@"&sort=%@", @(sort)];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)searchTopicUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"topic/%@/users", [param objectForKey:@"topic"]];
    NSString *keyword = [param objectForKey:@"keyword"];
    [action appendFormat:@"?keyword=%@", keyword];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)postTopicLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"topic/%@/like", [param objectForKey:@"topic"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteTopicLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"topic/%@/like", [param objectForKey:@"topic"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)getTopicByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"topic/get/%@", [param objectForKey:@"topicid"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

@end
