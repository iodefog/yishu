//
//  IServices+Feed.m
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "IServices+Feed.h"
#import "DateUtil.h"

@implementation IServices (Feed)

+ (void)getFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"feed/list"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/view/%@", [param objectForKey:@"feed_id"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)sendFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"feed" method:@"POST" params:param success:success failure:failure];
}

+ (void)sendFeedLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/%@/like", [param objectForKey:@"feed_id"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)getNewFeedLikeList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSDate *lastTime = [param objectForKey:@"lastTime"];
    NSMutableString *action = [NSMutableString stringWithFormat:@"feed/likes/_new?last_time=%@", [DateUtil convertNumberFromTime:lastTime]];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)sendFeedUnlike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/%@/like", [param objectForKey:@"feed_id"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)deleteFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/%@", [param objectForKey:@"feed_id"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)getFeedWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/%@", [param objectForKey:@"feed_id"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *feed_id = [param objectForKey:@"feed_id"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"feed/comment/list"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?feed_id=%@&from=%@&size=%@", feed_id, @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getNewFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSDate *lastTime = [param objectForKey:@"lastTime"];
    NSMutableString *action = [NSMutableString stringWithFormat:@"feed/comments/_new?last_time=%@", [DateUtil convertNumberFromTime:lastTime]];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)sendFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"feed/comment" method:@"POST" params:param success:success failure:failure];
}

+ (void)sendFeedCommentLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"feed/comment/up" method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"feed/comment/%@", [param objectForKey:@"comment_id"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)getEventFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *eventid = [param objectForKey:@"eventid"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSInteger sort = [[param objectForKey:@"sort"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"event/%@/feeds", eventid];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [action appendFormat:@"&sort=%@", @(sort)];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getEventOfficialFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *title = [param objectForKey:@"title"];
    NSString *userID = [param objectForKey:@"userID"];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"topic/%@/feeds?user_id=%@", title,userID];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)searchEventFeedForPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *title = [[param objectForKey:@"title"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *keyword = [[param objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *action = [NSMutableString stringWithFormat:@"topic/%@/feeds?keyword=%@", title,keyword]; //      feed/topic/%@/users?keyword=%@
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getFeedSuggestList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSString *topic = [param objectForKey:@"topic"];
    NSMutableString *action = [NSMutableString stringWithString:@"feed/topic/_suggest"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?topic=%@&from=%@&size=%@", topic, @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

//+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
//{
//    Request *request = [[Request alloc] init];
//    [request requestAction:@"/report" method:@"POST" params:param success:success failure:failure];
//}

+ (void)getPersonFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [[NSMutableString alloc] init];
    if (param[@"userId"]) {
        [action appendFormat:@"/user/%@/feeds", param[@"userId"]];
    } else {
        [action appendFormat:@"/user/feeds"];
    }
    
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    NSLog(@"param : %@", param);
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

@end
