//
//  IServices+Channel.m
//  medtree
//
//  Created by tangshimi on 9/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "IServices+Channel.h"

@implementation IServices (Channel)

+ (void)getChannelHomePageParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/home_page"];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelRecommendParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/recommend?channel_id=%@",[dict objectForKey:@"channel_id"]];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%zi&size=%zi", from, size];
    }

    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelRecommendTagsParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSString *action = [NSString stringWithFormat:@"channel/tags?channel_id=%@", dict[@"channel_id"]];
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelRecommendPostTagsParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"channel/tags/interest" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getChannelSquareParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/contents?channel_id=%@",[dict objectForKey:@"channel_id"]];
    
    if ([dict objectForKey:@"tag"]) {
        [action appendFormat:@"&tag=%@", [dict objectForKey:@"tag"]];
    }
    
    if ([dict objectForKey:@"key_word"]) {
        [action appendFormat:@"&key_word=%@", [[dict objectForKey:@"key_word"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%zi&size=%zi", from, size];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelPublishDiscussionParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"channel/discuss/publish" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getChannelFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/like/%@", [dict objectForKey:@"id"]];
    
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getChannelUnFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/unlike/%@", [dict objectForKey:@"id"]];
    
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getChannelInvitePeopleListParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/invitee?channel_id=%@", [dict objectForKey:@"channel_id"]];
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelInvitePeopleParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    [request requestAction:@"channel/invite" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getChannelDetailCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    [request requestAction:@"channel/feed/publish" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getChannelCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/feed/%@",[dict objectForKey:@"id"]];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelCommentByIDParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"channel/content/%@", dict[@"id"]];
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"channel/comment/publish" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getChannelDeleteCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *feedIDOrCommentID = nil;
    
    if (dict[@"feed_id"]) {
        feedIDOrCommentID = dict[@"feed_id"];
    } else if (dict[@"comment_id"]) {
        feedIDOrCommentID = dict[@"comment_id"];
    }
    
    NSString *action = [NSString stringWithFormat:@"channel/comment/delete/%@", feedIDOrCommentID];
    
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getChannelDailyAdvertisementSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"advertisement/first_login" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelHomepageAdvertisementSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"advertisement/home_page" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getChannelDeleteDiscussionParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"channel/discuss/delete/%@", dict[@"content_id"]];
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getChannelMoreParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"channel/list?"];
    
    if (dict[@"channel_type"]) {
        [action appendFormat:@"channel_type=%@&", dict[@"channel_type"]];
    }
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"from=%zi&size=%zi", from, size];
    }

    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelHomePageParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"recruit/home_page"];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelPostInterestParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    [request requestAction:@"recruit/filters/set" method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getJobChannelGetInterestSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    [request requestAction:@"recruit/filters/user" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelEnterpriseParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"recruit/enterprises"];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    if (dict[@"keyWord"]) {
        [action appendFormat:@"&key_word=%@", [dict[@"keyWord"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"province"]) {
        [action appendFormat:@"&province=%@", [dict[@"province"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"enterprise_type"]) {
        [action appendFormat:@"&enterprise_type=%@", dict[@"enterprise_type"]];
    }
    
    if (dict[@"enterprise_scale"]) {
        [action appendFormat:@"&enterprise_scale=%@", dict[@"enterprise_scale"]];
    }
    
    if (dict[@"enterprise_level"]) {
        [action appendFormat:@"&enterprise_level=%@", dict[@"enterprise_level"]];
    }

    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelEmploymentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"recruit/jobs"];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    if (dict[@"keyWord"]) {
        [action appendFormat:@"&key_word=%@", [dict[@"keyWord"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"province"]) {
        [action appendFormat:@"&province=%@", [dict[@"province"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"job_property_lev1"]) {
        [action appendFormat:@"&job_property_lev1=%@", [dict[@"job_property_lev1"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"job_property_lev2" ]) {
        [action appendFormat:@"&job_property_lev2=%@", [dict[@"job_property_lev2"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (dict[@"enterprise_type"]) {
        [action appendFormat:@"&enterprise_type=%@", dict[@"enterprise_type"]];
    }
        
    if (dict[@"enterprise_level"]) {
        [action appendFormat:@"&enterprise_level=%@", dict[@"enterprise_level"]];
    }
    
    if (dict[@"education"]) {
        [action appendFormat:@"&education=%@", dict[@"education"]];
    }
    
    if (dict[@"salary"]) {
        [action appendFormat:@"&salary=%@", dict[@"salary"]];
    }
    
    if (dict[@"publish_time"]) {
        [action appendFormat:@"&publish_time=%@", dict[@"publish_time"]];
    }
    
    if (dict[@"enterprise_scale"]) {
        [action appendFormat:@"&enterprise_scale=%@", dict[@"enterprise_scale"]];
    }
    
    if (dict[@"experience_time"]) {
        [action appendFormat:@"&experience_time=%@", dict[@"experience_time"]];
    }
    
    if (dict[@"title"]) {
        [action appendFormat:@"&title=%@", dict[@"title"]];
    }
    
    if (dict[@"enterprise_id"]) {
        [action appendFormat:@"&enterprise_id=%@", dict[@"enterprise_id"]];
    }
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelFunctionLevelOneSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"recruit/filters/job_pro_lev1" method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelFunctionlevelTwoParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableString *action = [NSMutableString stringWithFormat:@"recruit/filters/job_pro_lev2"];
    [action appendFormat:@"?parent_id=%@", dict[@"parentID"]];
    
    Request *request = [[Request alloc] init];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelEmploymentCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *action = [NSString stringWithFormat:@"recruit/feed/%@", dict[@"employmentID"]];
    
    Request *request = [[Request alloc] init];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelEmploymentPublishFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"recruit/feed/publish" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getJobChannelEmploymentCommentFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"recruit/comment/publish" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getJobChannelEmploymentCommentFeedFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"recruit/feed/like/%@", dict[@"id"]];
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getJobChannelEmploymentCommentFeedUnFavourParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"recruit/feed/unlike/%@", dict[@"id"]];
    [request requestAction:action method:@"PUT" params:dict success:success failure:failure];
}

+ (void)getJobChannelEnterpriseRelationParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableString *action = [NSMutableString stringWithFormat:@"relation/enterprise/"];
    [action appendFormat:@"%@", dict[@"enterpriseID"]];
    
    NSInteger from = [[dict objectForKey:@"from"] integerValue];
    NSInteger size = [[dict objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%zi&size=%zi", from, size];
    }
    
    Request *request = [[Request alloc] init];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)getJobChannelPostSearchInfoParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"recruit/feedback" method:@"POST" params:dict success:success failure:failure];
}

+ (void)getJobChannelDeleteFeedParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];

    NSString *action = [NSString stringWithFormat:@"recruit/feed/%@", dict[@"feed_id"]];
    
    [request requestAction:action method:@"DELETE" params:dict success:success failure:failure];
}

+ (void)getJobChannelDeleteCommentParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSString *action = [NSString stringWithFormat:@"recruit/comment/%@", dict[@"comment_id"]];
    
    [request requestAction:action method:@"DELETE" params:dict success:success failure:failure];
}

+ (void)getChannelEmploymentByIDParams:(NSDictionary *)dict Success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSString *action = [NSString stringWithFormat:@"recruit/job?job_id%@", dict[@"jod_id"]];
    
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

@end
