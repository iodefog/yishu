//
//  IServices+Article.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Article.h"

@implementation IServices (Article)

+ (void)getArticle:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"article"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    NSInteger user_type = [[param objectForKey:@"user_type"] integerValue];
    [action appendFormat:@"&user_type=%@", @(user_type)];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getArticleRecommend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"article_recommend"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getArticleByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"article/%@", [param objectForKey:@"articleid"]];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getCommentByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"article/%@", [param objectForKey:@"articleid"]];
    [action appendString:@"/comments"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    
    [request requestAction:action method:@"GET" params:param success:success failure:failure];

}

+ (void)sendComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"article/%@/comment", [param objectForKey:@"articleid"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)sendLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"article/%@/like", [param objectForKey:@"articleid"]];
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)sendUnLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"article/%@/like", [param objectForKey:@"articleid"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)deleteComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"article/%@/comment/%@", [param objectForKey:@"articleid"], [param objectForKey:@"comment_id"]];
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/report" method:@"POST" params:param success:success failure:failure];
}


@end
