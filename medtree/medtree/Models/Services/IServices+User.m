//
//  IServices+User.m
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "IServices+User.h"
#import "Request+Logout.h"

@implementation IServices (User)

+ (void)getUserInfo:(NSString *)userid success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/%@", userid] method:@"GET" params:nil success:success failure:failure];
}

+ (void)searchUserInfo:(NSString *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/get/%@", userInfo] method:@"GET" params:nil success:success failure:failure];
}

+ (void)getUserList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"connection/friends"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    if ([param objectForKey:@"timestamp"]) {
        [action appendFormat:@"&timestamp=%@", [param objectForKey:@"timestamp"]];
    }
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

+ (void)importContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/contacts/import" method:@"POST" params:param success:success failure:failure];
}

/*
+ (void)statContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/contacts/stats" method:@"GET" params:param success:success failure:failure];
}
 */

+ (void)getJoinedContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/contacts/joined" method:@"GET" params:param success:success failure:failure];
}

+ (void)getMarkContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithString:@"connection/contacts"];
//    NSInteger matchType = [[param objectForKey:@"matchType"] integerValue];
//    [action appendFormat:@"?match_type=%d", matchType];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    if ([param objectForKey:@"timestamp"]) {
        [action appendFormat:@"&timestamp=%@", [param objectForKey:@"timestamp"]];
    }
    
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

/*
+ (void)getMatchProcess:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/contacts/match_process" method:@"GET" params:param success:success failure:failure];
}
 */

+ (void)markContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/contacts/remark" method:@"POST" params:param success:success failure:failure];
}

+ (void)addFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/friends/request" method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"connection/friends/%@",[param objectForKey:@"friend_id"]] method:@"DELETE" params:param success:success failure:failure];
}

+ (void)processFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/friends/process" method:@"POST" params:param success:success failure:failure];
}

+ (void)getFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/friends/requests" method:@"GET" params:param success:success failure:failure];
}

+ (void)deleteFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"connection/friend/%@/requests",[param objectForKey:@"userid"]] method:@"DELETE" params:param success:success failure:failure];
}

+ (void)updateUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/profile" method:@"PUT" params:param success:success failure:failure];
}

/**添加个人经历**/
+ (void)addUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/profile/experience" method:@"POST" params:param success:success failure:failure];
}

/**修改个人经历**/
+ (void)updateUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/experience/%@",[param objectForKey:@"id"]] method:@"PUT" params:param success:success failure:failure];
}

/**删除经历**/
+ (void)deleteUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/experience/%@",[param objectForKey:@"id"]] method:@"DELETE" params:param success:success failure:failure];
}

+ (void)checkFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *userID = [param objectForKey:@"userID"];
    [request requestAction:[NSString stringWithFormat:@"connection/friend/%@/requests",userID] method:@"GET" params:param success:success failure:failure];
}

+ (void)feedback:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"feedback" method:@"POST" params:param success:success failure:failure];
}

+ (void)getAccess_tokenRefresh:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"auth/access_token/_refresh" method:@"GET" params:param success:success failure:failure];
}

+ (void)getIm_password:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"im/password/_refresh" method:@"GET" params:param success:success failure:failure];
}

+ (void)certificationApply:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"certification/_apply" method:@"POST" params:param success:success failure:failure];
}

+ (void)certification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"certification" method:@"GET" params:param success:success failure:failure];
}

+ (void)qr_card:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/profile/qr_card" method:@"GET" params:param success:success failure:failure];
}

+ (void)discoveryPeopleNear:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"discovery/people/nearby/_refresh"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"POST" params:param success:success failure:failure];
}

+ (void)connectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/peer" method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteConnectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"connection/peer/%@",[param objectForKey:@"user_id"]] method:@"DELETE" params:param success:success failure:failure];
}

+ (void)connectionUserSelf:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"connection/%@",[param objectForKey:@"key"]] method:@"POST" params:nil success:success failure:failure];
}

+ (void)connectionUserFriends:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"connection/friends/%@/%@",[param objectForKey:@"friends_id"],[param objectForKey:@"key"]] method:@"POST" params:nil success:success failure:failure];
}

+ (void)pointSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"daily/checkin" method:@"POST" params:nil success:success failure:failure];
}

+ (void)getSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"daily/checkin" method:@"GET" params:nil success:success failure:failure];
}

+ (void)addUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/profile/tag" method:@"POST" params:param success:success failure:failure];
}

+ (void)searchMarkUserListWithName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"people/_search?name=%@",[param objectForKey:@"name"]];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"&from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)ignoreUser:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"connection/ignore" method:@"POST" params:param success:success failure:failure];
}

+ (void)getCommonFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"user/profile/%@/common_friends?",[param objectForKey:@"userID"]];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"from=%@&size=%@", @(from), @(size)];
    }
    Request *request = [[Request alloc] init];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

+ (void)getUserCertification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSMutableString *action = [NSMutableString stringWithFormat:@"user/profile/certification"];
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}


+ (void)delUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *tag = [param objectForKey:@"tag"];
    tag = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                       (CFStringRef)tag, nil,
                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *action = [NSMutableString stringWithFormat:@"user/profile/tag/%@", tag];
   
    [request requestAction:action method:@"DELETE" params:param success:success failure:failure];
}

+ (void)reportUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/report" method:@"POST" params:param success:success failure:failure];
}

+ (void)registerDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/message/_register_device" method:@"POST" params:param success:success failure:failure];
}

+ (void)deleteDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"/message/_delete_device" method:@"POST" params:param success:success failure:failure];
}

+ (void)logoutExitEngine:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request closeEngineWithType:1 success:success failure:failure];
}

+ (void)getCertificationChange:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"certification/lastpass/%@",[param objectForKey:@"timestamp"]] method:@"GET" params:param success:success failure:failure];

}

/**获取用户学术标签*/
+ (void)getAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/tag/academic"] method:@"GET" params:param success:success failure:failure];
}

/**添加用户学术标签*/
+ (void)addAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/tag/academic/add"] method:@"POST" params:param success:success failure:failure];
}

/**获取用户学术系统标签*/
+ (void)getAcademicTagSystem:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@"tag/academic"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

/**用户名片信息修改*/
+ (void)postUserCard:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/name_card"] method:@"POST" params:param success:success failure:failure];
}

/**删除用户学术标签*/
+ (void)delAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/profile/tag/academic/delete" method:@"POST" params:param success:success failure:failure];
}

/**对用户学术标签点赞*/
+ (void)likeAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"user/profile/tag/academic"] method:@"POST" params:param success:success failure:failure];
}

//v4.1 TODO 接口待定
/**我关注的企业*/
+ (void)getConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithFormat:@""];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:[NSString stringWithFormat:@""] method:@"GET" params:param success:success failure:failure];
}

+ (void)deleteConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
{
    Request *request = [[Request alloc] init];
    [request requestAction:[NSString stringWithFormat:@"%@", [param objectForKey:@"enterprise_id"]] method:@"DELETE" params:param success:success failure:failure];
}

#pragma mark - 投递简历
+ (void)addResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"resume/delivery" method:@"POST" params:param success:success failure:failure];
}

#pragma mark - 修改简历
+ (void)putResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"resume/%@", param[@"resumeId"]];
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:param];
    [dictM removeObjectForKey:@"resumeId"];
    [request requestAction:action method:@"PUT" params:dictM success:success failure:failure];
}

#pragma mark - 获取简历
+ (void)getResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"resumes" method:@"GET" params:param success:success failure:failure];
}
#pragma mark - 收藏的职位
+ (void)getCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSInteger from = [[param objectForKey:@"from"] integerValue];
    NSInteger size = [[param objectForKey:@"size"] integerValue];
    NSMutableString *action = [NSMutableString stringWithString:@"/recruit/store_job"];
    if (from >= 0 && size > 0) {
        [action appendFormat:@"?from=%@&size=%@", @(from), @(size)];
    }
    [request requestAction:action method:@"GET" params:param success:success failure:failure];
}

#pragma mark - 删除收藏职位 
+ (void)deleteCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"/recruit/store_job"];
    [request requestAction:action method:@"PUT" params:param success:success failure:failure];
}

+ (void)getPointSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    NSString *action = [NSString stringWithFormat:@"point/mine"];
    [request requestAction:action method:@"GET" params:nil success:success failure:failure];
}

@end
