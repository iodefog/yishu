//
//  IServices+Forum.m
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IServices+Forum.h"
#import "DateUtil.h"

@implementation IServices (Forum)

+ (void)getForumList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/posts"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    if ([param objectForKey:@"source"]) {
        [action appendFormat:@"&source=%@", [param objectForKey:@"source"]];
    }
    if ([param objectForKey:@"zone"]) {
        [action appendFormat:@"&zone=%@", [param objectForKey:@"zone"]];
    }
    if ([param objectForKey:@"category"]) {
        [action appendFormat:@"&category=%@", [[param objectForKey:@"category"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([param objectForKey:@"keyword"]) {
        [action appendFormat:@"&keyword=%@", [[param objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([param objectForKey:@"status"]) {
        [action appendFormat:@"&status=%@", [param objectForKey:@"status"]];
    }
    if ([param objectForKey:@"sort_bonus"]) {
        [action appendFormat:@"&sort_bonus=%@", [param objectForKey:@"sort_bonus"]];
    }
    if ([param objectForKey:@"sort_time"]) {
        [action appendFormat:@"&sort_time=%@", [param objectForKey:@"sort_time"]];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getForumWithPostID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/comments",[param objectForKey:@"post_id"]];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)postForumWithPostID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    //
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/comment",[param objectForKey:@"post_id"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)getForumUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/users",[param objectForKey:@"post_id"]];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)postQuestion:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post"];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)closePost:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/_close",[param objectForKey:@"post_id"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)getForumCategories:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];

    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/categories"];

    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)postInviteUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/_invite",[param objectForKey:@"post_id"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)getUnreadInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
//    NSDate *lastTime = [param objectForKey:@"lastTime"];
//    ?last_time=%l", [DateUtil convertNumberFromTime:lastTime]];
//    NSInteger from = [[param objectForKey:@"from"] integerValue];
//    NSInteger size = [[param objectForKey:@"size"] integerValue];
//    if (from >= 0 && size > 0) {
//        [action appendFormat:@"&from=%d&size=%d", from, size];
//    }
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/_unread"];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getForumWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@",[param objectForKey:@"post_id"]];
    
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)deleteForumComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/comment/%@",[param objectForKey:@"post_id"],[param objectForKey:@"comment_id"]];
    
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)forumShareToFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/_share",[param objectForKey:@"post_id"]];
    
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)forumAddPoint:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/post/%@/point/add",[param objectForKey:@"post_id"]];
    
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)getRecommendForumList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"forum/posts/recommend"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    if ([param objectForKey:@"source"]) {
        [action appendFormat:@"&source=%@", [param objectForKey:@"source"]];
    }
    if ([param objectForKey:@"zone"]) {
        [action appendFormat:@"&zone=%@", [param objectForKey:@"zone"]];
    }
    if ([param objectForKey:@"category"]) {
        [action appendFormat:@"&category=%@", [[param objectForKey:@"category"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([param objectForKey:@"keyword"]) {
        [action appendFormat:@"&keyword=%@", [[param objectForKey:@"keyword"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([param objectForKey:@"status"]) {
        [action appendFormat:@"&status=%@", [param objectForKey:@"status"]];
    }
    if ([param objectForKey:@"sort_bonus"]) {
        [action appendFormat:@"&sort_bonus=%@", [param objectForKey:@"sort_bonus"]];
    }
    if ([param objectForKey:@"sort_time"]) {
        [action appendFormat:@"&sort_time=%@", [param objectForKey:@"sort_time"]];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)likeForumCommont:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"/forum/like/comment/%@",[param objectForKey:@"post_id"]];
    
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)notLikeForumCommont:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"/forum/like/comment/%@",[param objectForKey:@"post_id"]];
    
    [request requestAction:action method:@"DELETE" params:nil success:success failure:failure];
}

@end
