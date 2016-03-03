//
//  UserManager.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "UserManager.h"
#import "CommonManager.h"
#import "UserDTO.h"
#import "NotificationDTO.h"
#import "DB+Public.h"
#import "ContactUtil.h"
#import "ContactInfo.h"
#import "RelationTypes.h"
#import "MessageDTO.h"
#import "NotificationDTO.h"
#import "CertificationDTO.h"
#import "AccountHelper.h"
#import "MateUserDTO.h"
#import "PeopleDTO.h"
#import "MedGlobal.h"
#import "AcademicTagDTO.h"
#import "EnterpriseDTO.h"
#import "HomeJobChannelEmploymentDTO.h"
@implementation UserManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_UserInfo_UserCertification: {
            [UserManager getUserCertification:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_SearchName: {
            [UserManager searchMarkUserListWithName:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo: {
            [UserManager getUserInfo:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Qr_card: {
            [UserManager qr_card:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Account_Token: {
            [UserManager getAccess_tokenRefresh:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_IM_Password: {
            [UserManager getIm_password:param  success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_CheckRequest: {
            [UserManager checkFriendRequest:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Certification: {
            [UserManager certification:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Local: {
            [UserManager getUserInfoFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Search: {
            [UserManager searchUserInfo:param success:success failure:failure];
            break;
        }
        case MethodType_FriendList: {
            [UserManager getFriendList:param success:success failure:failure];
            break;
        }
        case MethodType_FriendList_Local: {
            [UserManager getFriendListFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_UserLogin: {
            [UserManager login:param success:success failure:failure];
            break;
        }
        case MethodType_UserLogout: {
            [UserManager logout:param success:success failure:failure];
            break;
        }
        case MethodType_UserRegister: {
            [UserManager reg:param success:success failure:failure];
            break;
        }
        case MethodType_NewFriendList_Local: {
            [UserManager getFriendRequestFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_NewFriendList: {
            [UserManager getFriendRequestFromNet:param success:success failure:failure];
            break;
        }
        case MethodType_JoinedFriendList: {
            [UserManager getJoinedContactsFromNet:param success:success failure:failure];
            break;
        }
        case MethodType_Mark_Friend_Local: {
            [UserManager getMarkFriendFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_Mark_Friend_Net: {
            [UserManager getMarkFriendFromNet:param success:success failure:failure];
            break;
        }
        case MethodType_Name_SameUser: {
            [UserManager getPeopleSameName:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_SignGet: {
            [UserManager getSignIn:param success:success failure:failure];
            break;
        }
        case MethodType_ColleagueList_Local: { //同事缓存
            [UserManager getColleagueFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_Classmate_Local: { //校友缓存
            [UserManager getClassmateFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_SameOccupation_Local: { //同行缓存
            [UserManager getSameOccupationFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_FriendFriend_Local: { //好友的好友缓存
            [UserManager getFriendFriendFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_Logout: {
            // 切换网络引擎
            [UserManager logoutExitEngine:param success:success failure:failure];
            break;
        }
        case MethodType_Certification: { //认证通过轮询
            [UserManager getCertificationChange:param success:success failure:failure];
            break;
        }
        case MethodType_ConcernEnterprise: {//我关注的企业
            [UserManager getConcernEnterprise:param success:success failure:failure];
            break;
        }
        case MethodType_Resume_Get: {
            [IServices getResume:param success:success failure:failure];
            break;
        }
        case MethodType_CollectionJobs: {//我的收藏职位
            [UserManager getCollectionJobs:param success:success failure:failure];
            break;
        }
    }
    
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_User_RegisterDevice: {
            [UserManager registerDevice:param success:success failure:failure];
            break;
        }
        case MethodType_UserRegisterAll: {
            [UserManager registerAllInfo:param success:success failure:failure];
            break;
        }
        case MethodType_User_DeleteDevice: {
            [UserManager deleteDevice:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_IgnoreUser: {
            [UserManager ignoreUser:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Update_Local: {
            UserDTO *dto = [param objectForKey:@"info"];
            [UserManager checkUser:dto];
            break;
        }
        case MethodType_UserInfo_SignPost: {
            [UserManager pointSignIn:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_CertificationApply: {
            [UserManager certificationApply:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Privacy: {
            [UserManager connectionUserSelf:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_FriendsPrivacy: {
            [UserManager connectionUserFriends:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Feedback: {
            [UserManager feedback:param success:success failure:failure];
            break;
        }
        case MethodType_DiscoveryPeopleNear: {
            [UserManager discoveryPeopleNear:param success:success failure:failure];
            break;
        }
        case MethodType_ConnectionPeer: {
            [UserManager connectionPeer:param success:success failure:failure];
            break;
        }
        case MethodType_DeleteConnectionPeer: {
            [UserManager deleteConnectionPeer:param success:success failure:failure];
            break;
        }
        case MethodType_Import_Contact: {
            [UserManager importContacts:param success:success failure:failure];
            break;
        }
        case MethodType_Add_Friend: {
            [UserManager addFriend:param success:success failure:failure];
            break;
        }
        case MethodType_Delete_Friend: {
            [UserManager deleteFriend:param success:success failure:failure];
            break;
        }
        case MethodType_Accept_Friend: {
            [UserManager acceptFriendRequest:param success:success failure:failure];
            break;
        }
        case MethodType_Deny_Friend: {
            [UserManager denyFriendRequest:param success:success failure:failure];
            break;
        }
        case MethodType_Invite_Friend: {
            [UserManager addFriendRequest:param success:success failure:failure];
            break;
        }
        case MethodType_NewFriend_Delete: {
            [UserManager deleteFriendRequest:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_Update: {
            [IServices updateUserInfo:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_AddExperience: {
            [IServices addUserExperience:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_UpadteExperience: {
            [IServices updateUserExperience:param success:success failure:failure];
            break;
        }
        case MethodType_UserInfo_DeleteExperience: {
            [IServices deleteUserExperience:param success:success failure:failure];
            break;
        }
        case MethodType_ConcernEnterprise_Delete: {
            [IServices deleteConcernEnterprise:param success:success failure:failure];
            break;
        }
        case MethodType_Resume_Post: { //
            [IServices addResume:param success:success failure:failure];
            break;
        }
        case MethodType_Resume_Put: {
            [IServices putResume:param success:success failure:failure];
            break;
        }
        case MethodType_CollectionJobs_Delete:{//删除收藏
            [IServices deleteCollectionJobs:param success:success failure:failure];
            break;
        }
    }
}

+ (void)getUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        NSString *userid = [param objectForKey:@"userid"];
        [IServices getUserInfo:userid success:^(id JSON) {
            UserDTO *dto = [[UserDTO alloc] init:JSON];
            //
            if ([dto.userID isEqualToString:[[AccountHelper getAccount] userID]]) {
                if (dto.user_status == [[AccountHelper getAccount] user_status]) {
                    
                    [AccountHelper setAccount:dto];
            
                }
            }
            [UserManager checkUser:dto];
            //
            success(dto);
        } failure:^(NSError *error, id JSON) {
            if (failure) {
                failure(error,JSON);
            }
        }];
    }
    /*
    [UserManager getUserInfoFromLocal:param success:^(id JSON) {
        if (JSON != nil) {
            success(JSON);
        } else {
            if ([MedGlobal checkNetworkStatus]) {
                NSString *userid = [param objectForKey:@"userid"];
                [IServices getUserInfo:userid success:^(id JSON) {
                    UserDTO *dto = [[UserDTO alloc] init:JSON];
                    //
                    [UserManager checkUser:dto type:RelationType_All];
                    //
                    success(dto);
                } failure:^(NSError *error, id JSON) {
                    
                }];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
     */
}

+ (void)searchUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        NSString *userid = [param objectForKey:@"userInfo"];
        [IServices searchUserInfo:userid success:^(id JSON) {
            success(JSON);
        } failure:^(NSError *error, id JSON) {
            failure(error,JSON);
        }];
    }
}

+ (void)getUserInfoFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = @"userid";
    NSString *value = [param objectForKey:key];
    if (value == nil) {
        key = @"chatid";
        value = [param objectForKey:key];
    }
    [[DB shareInstance] selectUser:key value:value result:^(NSArray *array) {
        if (array.count > 0) {
            success([array objectAtIndex:0]);
        } else {
            success(nil);
        }
    }];
}

+ (void)getFriendList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getUserList:param success:^(id JSON) {
            NSMutableArray *users = [NSMutableArray array];
            NSArray *result = [JSON objectForKey:@"result"];
            
            //
            if ([JSON objectForKey:@"timestamp"]) {
                [UserManager setFrinedTimeStampInfo:@{@"friendTimeStamp":[JSON objectForKey:@"timestamp"]} key:@"friendTimeStamp"];
            }
            //
            
            for (int i=0; i<result.count; i++) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [users addObject:dto];
                //
                [UserManager checkUser:dto type:RelationType_Friend];
            }
            success(users);
        } failure:^(NSError *error, id JSON) {
            failure(error,JSON);
        }];
    }
}

+ (void)setFrinedTimeStampInfo:(NSDictionary *)dict key:(NSString *)key
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key,@"info":dto} success:^(id JSON) {

    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getFriendListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllRelations:^(NSArray *array) {
        success(array);
    } type:RelationType_Friend];
}

//同事缓存
+ (void)getColleagueFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllAllRelations:^(NSArray *array) {
        success(array);
    } type:RelationType_Colleague];
}

//校友缓存
+ (void)getClassmateFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllAllRelations:^(NSArray *array) {
        success(array);
    } type:RelationType_Classmate];
}

//同行缓存
+ (void)getSameOccupationFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllAllRelations:^(NSArray *array) {
        success(array);
    } type:RelationType_SameOccupation];
}

//好友的好友缓存
+ (void)getFriendFriendFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllAllRelations:^(NSArray *array) {
        success(array);
    } type:RelationType_FriendFriend];
}


+ (void)deleteFriendListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSInteger type = [[param objectForKey:@"type"] integerValue];
    [[UserManager getUserIDs:type] removeAllObjects];
    [[DB shareInstance] deleteRelations:^(NSArray *array) {
        success(array);
    } type:type];
}

/*
+ (void)getColleagueList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getUserList:param success:^(id JSON) {
            NSMutableArray *users = [NSMutableArray array];
            NSArray *result = [JSON objectForKey:@"result"];
            for (int i=0; i<result.count; i++) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [users addObject:dto];
                //
//                [UserManager checkUser:dto type:RelationType_Colleague];
            }
            success(users);
        } failure:^(NSError *error, id JSON) {
            failure(error,JSON);
        }];
    }
}
 */

+ (void)getColleagueListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
}

/*
+ (void)getClassmateList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getUserList:param success:^(id JSON) {
            NSMutableArray *users = [NSMutableArray array];
            NSArray *result = [JSON objectForKey:@"result"];
            for (int i=0; i<result.count; i++) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [users addObject:dto];
                //
//                [UserManager checkUser:dto type:RelationType_Classmate];
            }
            success(users);
        } failure:^(NSError *error, id JSON) {
            failure(error,JSON);
        }];
    }
}
 */

+ (void)getClassmateListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
}

+ (void)login:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices login:param success:success failure:failure];
    }
}

+ (void)logout:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices logout:param success:success failure:failure];
    }
}

+ (void)reg:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices reg:param success:success failure:failure];
    }
}

+ (void)registerAllInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices registerAllInfo:param success:success failure:failure];
    }
}

+ (void)checkUser:(UserDTO *)dto type:(NSInteger)type
{
    {
        NSMutableArray *ids = [UserManager getUserIDs:RelationType_All];
        if ([ids containsObject:dto.userID]) {
            [[DB shareInstance] updateUser:dto];
        } else {
            [[DB shareInstance] insertUser:dto];
            [ids addObject:dto.userID];
        }
    }
    if (type != RelationType_All) {
        NSMutableArray *ids = [UserManager getUserIDs:type];
        if ([ids containsObject:dto.userID]) {

        } else {
            [[DB shareInstance] insertRelation:dto type:type];
            [ids addObject:dto.userID];
        }
    }
}

//缓存用户关系
+ (void)cacheRelation:(PeopleDTO *)dto type:(NSInteger)type
{
    NSArray *ids = [[DB shareInstance] selectAllRelationIDs:type];
    if ([ids containsObject:dto.peopleID]) {
        [[DB shareInstance] updateAllRelation:dto type:type];
    } else {
        [[DB shareInstance] insertAllRelation:dto type:type];
    }
}

+ (void)checkUser:(UserDTO *)dto
{
    {
        NSMutableArray *ids = [UserManager getUserIDs:RelationType_All];
        if ([ids containsObject:dto.userID]) {
            if ([dto.userID isEqualToString:[[AccountHelper getAccount] userID]]) {
                if (dto.user_status == [[AccountHelper getAccount] user_status]) {
                    [[DB shareInstance] updateUser:dto];
                    [AccountHelper setAccount:dto];
                }
            } else {
                [[DB shareInstance] updateUser:dto];
            }
        } else {
            [[DB shareInstance] insertUser:dto];
            [ids addObject:dto.userID];
        }
    }
    //
    NSMutableArray *ids = [UserManager getUserIDs:RelationType_Friend];
    if (dto.isFriend) {
        if ([ids containsObject:dto.userID]) {
            
        } else {
            [[DB shareInstance] insertRelation:dto type:RelationType_Friend];
            [ids addObject:dto.userID];
        }
    } else {
        if ([ids containsObject:dto.userID]) {
            [ids removeObject:dto.userID];
        }
        [[DB shareInstance] deleteRelation:dto type:RelationType_Friend];
    }
}

+ (NSMutableArray *)getUserIDs:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    __block NSMutableArray *ma = [dict objectForKey:[NSNumber numberWithInteger:type]];
    if (ma == nil) {
        ma = [NSMutableArray array];
        [dict setObject:ma forKey:[NSNumber numberWithInteger:type]];
    }
    return ma;
}

+ (void)loadCacheData
{
    for (int type=RelationType_All; type<=RelationType_Friend; type++) {
        NSMutableArray *ma = [UserManager getUserIDs:type];
        [ma removeAllObjects];
        //
        if (type == RelationType_All) {
            [ma addObjectsFromArray:[[DB shareInstance] selectUserIDs]];
        } else {
            [ma addObjectsFromArray:[[DB shareInstance] selectRelationIDs:type]];
        }
    }
    {
        NSMutableArray *ma = [UserManager getUserIDs:NewRelationStatus_All];
        [ma removeAllObjects];
        //
        [ma addObjectsFromArray:[[DB shareInstance] selectNewRelationIDs]];
    }
    {
        NSMutableArray *ma = [UserManager getUserIDs:MarkRelationType_All];
        [ma removeAllObjects];
        //
        [ma addObjectsFromArray:[[DB shareInstance] selectMarkRelationIDs]];
    }
}

+ (void)importContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices importContacts:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

/*
+ (void)statContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices statContacts:param success:^(id JSON) {
            NSDictionary *result = [JSON objectForKey:@"result"];
            success(result);
        } failure:failure];
    }
}
 */

+ (void)addFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices addFriend:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

+ (void)deleteFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteFriend:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

+ (void)getUserInfoFull:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    dispatch_async([MedGlobal getDbQueue], ^{
        NSString *userid = [dict objectForKey:@"userid"];
        NSDictionary *param = @{@"userid": userid, @"method": [NSNumber numberWithInteger:MethodType_UserInfo_Local]};
        [ServiceManager getData:param success:^(id JSON) {
            if (JSON != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    success(JSON);
                });
            } else {
                NSDictionary *param = @{@"userid": userid, @"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
                [ServiceManager getData:param success:^(id JSON) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success(JSON);
                    });
                } failure:^(NSError *error, id JSON) {
                    if (failure) {
                        failure(error, JSON);
                    }
                }];
            }
        } failure:^(NSError *error, id JSON) {
            if (failure) {
                failure(error, JSON);
            }
        }];
    });
}

+ (void)receivedFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NotificationDTO *dto = [param objectForKey:@"data"];
    NSMutableArray *ids = [UserManager getUserIDs:NewRelationStatus_All];
    dto.unread = MessageUnRead;
    if ([ids containsObject:dto.userID]) {
        [[DB shareInstance] updateNewRelation:dto];
    } else {
        [[DB shareInstance] insertNewRelation:dto];
        [ids addObject:dto.userID];
    }
}

+ (void)acceptFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NotificationDTO *dto = [param objectForKey:@"data"];
    NSDictionary *dict = @{@"ticket": dto.ticket, @"parent_ticket": dto.parent_ticket, @"action": @"allow"};
    [IServices processFriendRequest:dict success:^(id JSON) {
        dto.status = NewRelationStatus_Friend_Request_Accept;
        [[DB shareInstance] updateNewRelation:dto];
        success(JSON);
    } failure:failure];
}

+ (void)denyFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NotificationDTO *dto = [param objectForKey:@"data"];
    NSDictionary *dict = @{@"ticket": dto.ticket, @"parent_ticket": dto.parent_ticket, @"action": @"deny"};
    [IServices processFriendRequest:dict success:success failure:failure];
}

+ (void)addFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NotificationDTO *dto = [param objectForKey:@"data"];
    NSDictionary *dict = @{@"ticket": dto.ticket, @"parent_ticket": dto.parent_ticket, @"action": @"add"};
    [IServices processFriendRequest:dict success:^(id JSON) {
        dto.status = NewRelationStatus_Friend_Request_Sent;
        [[DB shareInstance] updateNewRelation:dto];
        success(JSON);
    } failure:failure];
}

+ (void)deleteFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NotificationDTO *dto = [param objectForKey:@"data"];
    NSDictionary *dict = @{@"userid": dto.userID};
    [IServices deleteFriendRequest:dict success:^(id JSON) {
        [[DB shareInstance] deleteNewRelation:dto];
        success(JSON);
    } failure:failure];
}

+ (void)getFriendRequestFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllNewRelations:^(NSArray *array) {
        success(array);
    }];
}

+ (void)getFriendRequestFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getFriendRequest:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            NotificationDTO *dto = [[NotificationDTO alloc] init:[result objectAtIndex:i]];
            [array addObject:dto];
        }
        success(array);
    } failure:failure];
}

+ (void)checkFriendRequestFromLocal:(NSArray *)array
{
    [[DB shareInstance] deleteAllNewRelation];
    [[UserManager getUserIDs:NewRelationStatus_All] removeAllObjects];
    //
    NSMutableArray *ids = [UserManager getUserIDs:NewRelationStatus_All];
    for (int i=0; i<array.count; i++) {
        NotificationDTO *dto = [array objectAtIndex:i];
        dto.unread = MessageRead;
        //
        if ([ids containsObject:dto.userID]) {
            [[DB shareInstance] updateNewRelation:dto];
        } else {
            [[DB shareInstance] insertNewRelation:dto];
            [ids addObject:dto.userID];
        }
    }
}

+ (void)checkNotification:(NotificationDTO *)dto
{
    [dto updateInfo:[NSNumber numberWithInteger:dto.status] forKey:@"status"];
    [[DB shareInstance] updateNewRelation:dto];
}

+ (void)markAllNotificationAsRead
{
    [[DB shareInstance] markAllNotificationAsRead];
}

+ (void)getAllNotificationUnreadCounts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] getAllNotificationUnreadCounts:^(NSArray *array) {
        success(array);
    }];
}

+ (void)getMarkFriendFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllMarkRelations:^(NSArray *array) {
        success(array);
    }];
}

+ (void)getCheckMarkContacts:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"getMarkContacts"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success ([dataDict objectForKey:@"data"]);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

+ (void)setCheckMarkContacts:(NSDictionary *)dict
{
//    dispatch_async(dispatch_get_MedGlobal_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DTOBase *dto = [[DTOBase alloc] init:dict];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"getMarkContacts",@"info":dto} success:^(id JSON) {
        } failure:^(NSError *error, id JSON) {
            
        }];
//    });
}

+ (void)setPeopleSameNameTimeStampInfo:(NSDictionary *)dict key:(NSString *)key
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key,@"info":dto} success:^(id JSON) {

    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getPeopleSameName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getMarkContacts:param success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([JSON objectForKey:@"timestamp"]) {
                [UserManager setPeopleSameNameTimeStampInfo:@{@"contactTimeStamp":[JSON objectForKey:@"timestamp"]} key:@"contactTimeStamp"];
            }
        });
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *result = [NSMutableArray arrayWithArray:[JSON objectForKey:@"result"]];
        for (int i = 0; i < result.count; i ++) {
            NSDictionary *dto = [result objectAtIndex:i];
            [array addObject:dto];
        }
        
        success(@{@"data":array,@"offset":[JSON objectForKey:@"offset"]?[JSON objectForKey:@"offset"]:[NSNumber numberWithInt:0],@"total":[JSON objectForKey:@"total"]?[JSON objectForKey:@"total"]:[NSNumber numberWithInt:0]});
    } failure:failure];
    
//    [IServices getMarkContacts:param success:^(id JSON) {
//        NSMutableArray *array = [NSMutableArray array];
//        NSArray *result = [JSON objectForKey:@"result"];
        /*
        NSMutableArray *copyCheckArray = [NSMutableArray array];
        [UserManager getCheckMarkContacts:^(id JSON) {
            
            NSMutableDictionary *checkDataDict = [NSMutableDictionary dictionary];
            if (JSON != nil) {
                NSMutableArray *checkArray = [NSMutableArray array];
                [checkArray addObjectsFromArray:JSON];
                for (int i = 0; i < checkArray.count; i ++) {
                    NSDictionary *contactDict = [checkArray objectAtIndex:i];
                    NSNumber *contact_id = [contactDict objectForKey:@"contact_id"];
                    if (contact_id != nil) {
                        [checkDataDict setObject:contactDict forKey:[contactDict objectForKey:@"contact_id"]];
                    }
                }
            }
            for (int i=0; i<result.count; i++) {
                if ([result objectAtIndex:i] != [NSNull null]) {
                    NSMutableArray *users = [NSMutableArray array];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[result objectAtIndex:i]];
                    
                    NSMutableArray *matchedArray = [NSMutableArray arrayWithArray:[dict objectForKey:@"matched_users"]];
                    NSMutableArray *userIDArray = [NSMutableArray array];
                    for (int j = 0; j < matchedArray.count; j ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[matchedArray objectAtIndex:j]];
                        [userIDArray addObject:dto.userID];
                        [users addObject:dto];
                    }
                    
                    if (checkDataDict.allKeys.count > 0) {
                        NSDictionary *dataDict = [checkDataDict objectForKey:[dict objectForKey:@"id"]];
                        if (dataDict != nil) {
                            if ([[dataDict objectForKey:@"isOverlook"] boolValue]) {
                                [copyCheckArray addObject:dataDict];
                            } else {
                                if ([[dataDict objectForKey:@"isVerify"] boolValue]) {
                                    for (int m = 0; m < userIDArray.count; m ++) {
                                        if ([[userIDArray objectAtIndex:m] isEqualToString:[dataDict objectForKey:@"selectID"]]) {
                                            UserDTO *mDTO = [users objectAtIndex:m];
                                            [users removeAllObjects];
                                            [users addObject:mDTO];
                                            break;
                                        }
                                    }
                                    [copyCheckArray addObject:dataDict];
                                    [array addObject:@{@"name":[dict objectForKey:@"name"],@"data":users,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:YES]}];
                                } else {
                                    [copyCheckArray addObject:dataDict];
                                    [array addObject:@{@"name":[dict objectForKey:@"name"],@"data":users,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:NO]}];
                                }
                            }
                        } else {
                            [copyCheckArray addObject:@{@"name":[dict objectForKey:@"name"],@"data":userIDArray,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:NO],@"selectID":@""}];
                            
                            [array addObject:@{@"name":[dict objectForKey:@"name"],@"data":users,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:NO]}];
                        }
                    } else {
                        [copyCheckArray addObject:@{@"name":[dict objectForKey:@"name"],@"data":userIDArray,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:NO],@"selectID":@""}];
                        
                        [array addObject:@{@"name":[dict objectForKey:@"name"],@"data":users,@"phone":[dict objectForKey:@"phones_encrypted"],@"contact_id":[dict objectForKey:@"id"],@"isOverlook":[NSNumber numberWithBool:NO],@"isVerify":[NSNumber numberWithBool:NO]}];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [UserManager setCheckMarkContacts:@{@"data":copyCheckArray}];
            });
            */
//            success(JSON);
//        }];
//    */
//    } failurefailure];
}

+ (void)getMarkFriendFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getMarkContacts:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            if ([result objectAtIndex:i] != [NSNull null]) {
                UserDTO *dto = [[UserDTO alloc] init];
                [dto parse2:[result objectAtIndex:i]];
                [dto setJSON:[result objectAtIndex:i]];
                NSLog(@"Mark %@",dto.name);
                [array addObject:dto];
            }
        }
        success(array);
    } failure:failure];
}

+ (void)markFriendRelation:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    UserDTO *dto = [param objectForKey:@"data"];
    NSMutableDictionary *one = [NSMutableDictionary dictionaryWithDictionary:[dto JSON]];
    [one setObject:[NSNumber numberWithInteger:dto.relation] forKey:@"relation"];
    NSDictionary *dict = @{@"data": @[one]};
    //
    [IServices markContacts:dict success:^(id JSON) {
        NSMutableArray *ids = [UserManager getUserIDs:MarkRelationType_All];
        if ([ids containsObject:dto.userID]) {
            [[DB shareInstance] updateMarkRelation:dto];
        } else {
            [[DB shareInstance] insertMarkRelation:dto];
            [ids addObject:dto.userID];
        }
        success(JSON);
    } failure:failure];
}

+ (void)checkFriendRelationsFromLocal:(NSArray *)array
{
    [[DB shareInstance] deleteAllMarkRelation];
    [[UserManager getUserIDs:MarkRelationType_All] removeAllObjects];
    //
    NSMutableArray *ids = [UserManager getUserIDs:MarkRelationType_All];
    for (int i=0; i<array.count; i++) {
        UserDTO *dto = [array objectAtIndex:i];
        //
        if ([ids containsObject:dto.userID]) {
            [[DB shareInstance] updateMarkRelation:dto];
        } else {
            [[DB shareInstance] insertMarkRelation:dto];
            [ids addObject:dto.userID];
        }
    }
}

+ (void)checkContactUpdate
{
    [UserManager checkContactUpdate:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)checkContactUpdate:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSMutableArray *newContacts = [NSMutableArray array];
    NSDictionary *dict = [ContactUtil getAllContactIDs];
    if (dict.allKeys.count > 0) {
        NSDictionary *param = @{@"key": [NSNumber numberWithInteger:MethodType_CommonInfo_ContactIDs]};
        [CommonManager getCommonInfo:param success:^(id JSON) {
            NSArray *array = (NSArray *)JSON;
            if (array.count > 0) {
                NSDictionary *contacts = [array objectAtIndex:0];
                for (int i=0; i<dict.allKeys.count; i++) {
                    NSString *key = [dict.allKeys objectAtIndex:i];
                    NSNumber *value = [dict objectForKey:key];
                    //
                    NSObject *obj = [contacts objectForKey:key];
                    if (obj == [NSNull null]) {
                        [newContacts addObject:key];
                    } else {
                        double time = [((NSNumber *)obj) doubleValue];
                        if (time != [value doubleValue]) {
                            [newContacts addObject:key];
                        }
                    }
                }
            }
            if (array.count == 0 && newContacts.count == 0) {
                [newContacts addObjectsFromArray:dict.allKeys];
            }
            if (newContacts.count > 0) {
                dispatch_async([MedGlobal getDbQueue], ^{
                    // upload contacts
                    NSMutableArray *uploadContacts = [NSMutableArray array];
                    NSArray *contacts = [ContactUtil getContacts:newContacts];
                    for (int i=0; i<contacts.count; i++) {
                        ContactInfo *ci = [contacts objectAtIndex:i];
                        for (int i=0; i<ci.phones.count; i++) {
                            NSString *phone = [ci.phones objectAtIndex:i];
                            [ci.phones replaceObjectAtIndex:i withObject:[ContactUtil formatPhone:phone]];
                        }
                        NSDictionary *dict = @{@"name": ci.name, @"phones": ci.phones};
                        [uploadContacts addObject:dict];
                    }
                    if (uploadContacts.count > 0) {
                        [UserManager importContacts:@{@"data": uploadContacts} success:^(id JSON) {
                            DTOBase *dto = [[DTOBase alloc] init:dict];
                            NSDictionary *param = @{@"key": [NSNumber numberWithInteger:MethodType_CommonInfo_ContactIDs], @"info": dto};
                            [CommonManager setCommonInfo:param success:nil failure:nil];
                            success(newContacts);
                        } failure:failure];
                    }
                });
            } else {
                success(newContacts);
            }
        } failure:failure];
    }
}

+ (NSInteger)convertRelation:(NSInteger)relation
{
    NSInteger relationType = RelationType_All;
    if (relation > RelationTypes_None && relation < RelationTypes_Stranger) {
        relationType = RelationType_Friend;
    }
    return relationType;
}

+ (void)getJoinedContactsFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getJoinedContacts:nil success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            if ([result objectAtIndex:i] != [NSNull null]) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [array addObject:dto];
            }
        }
        success(array);
    } failure:failure];
}

+ (void)checkFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices checkFriendRequest:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i = 0; i < result.count; i ++) {
            NotificationDTO *dto = [[NotificationDTO alloc] init:[result objectAtIndex:i]];
            [array addObject:dto];
        }
        success(array);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

/*
+ (void)getMatchProcess:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getMatchProcess:nil success:^(id JSON) {
        NSDictionary *result = [JSON objectForKey:@"result"];
        NSNumber *process = [result objectForKey:@"status"];
        success(process);
    } failure:failure];
}
 */

+ (void)feedback:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices feedback:param success:success failure:failure];
}

+ (void)getAccess_tokenRefresh:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getAccess_tokenRefresh:param success:success failure:failure];
}

+ (void)getIm_password:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getIm_password:param success:success failure:failure];
}

+ (void)certificationApply:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices certificationApply:param success:success failure:failure];
}

+ (void)certification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices certification:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i = 0; i < result.count; i ++) {
            CertificationDTO *dto = [[CertificationDTO alloc] init:[result objectAtIndex:i]];
            [array addObject:dto];
        }
        success(array);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)qr_card:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices qr_card:param success:success failure:failure];
}

+ (void)discoveryPeopleNear:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices discoveryPeopleNear:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *result = [JSON objectForKey:@"result"];
        for (int i=0; i<result.count; i++) {
            if ([result objectAtIndex:i] != [NSNull null]) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [array addObject:dto];
            }
        }
        success(array);
    } failure:failure];
}

+ (void)connectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices connectionPeer:param success:success failure:failure];
}

+ (void)deleteConnectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteConnectionPeer:param success:success failure:failure];
}

+ (void)connectionUserSelf:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices connectionUserSelf:param success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            UserDTO *dto = [AccountHelper getAccount];
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendListChangeNotification object:nil];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dto preferences]];
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary *uDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
                if ([[uDict objectForKey:@"key"] isEqualToString:@"close_my_connection"]) {
                    BOOL isOn = YES;
                    if ([[param objectForKey:@"key"] isEqualToString:@"_open"]) {
                        isOn = NO;
                    }
                    [uDict setObject:[NSNumber numberWithBool:isOn] forKey:@"value"];
                    [[dto preferences] replaceObjectAtIndex:i withObject:uDict];
                    [UserManager checkUser:dto];
                    break;
                }
            }
        }
        success (JSON);
    } failure:^(NSError *error, id JSON) {
        failure (error,JSON);
    }];
}

+ (void)connectionUserFriends:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices connectionUserFriends:param success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendListChangeNotification object:nil];
            UserDTO *dto = [param objectForKey:@"user"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:dto.preferences];
            if (array.count > 0) {
                for (int i = 0; i < array.count; i ++) {
                    NSMutableDictionary *uDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:i]];
                    if ([[uDict objectForKey:@"key"] isEqualToString:@"hide_friend"]) {
                        BOOL isOn = YES;
                        if ([[param objectForKey:@"key"] isEqualToString:@"_show"]) {
                            isOn = NO;
                        }
                        [uDict setObject:[NSNumber numberWithBool:isOn] forKey:@"value"];
                        [dto.preferences replaceObjectAtIndex:i withObject:uDict];
                        [UserManager checkUser:dto];
                        break;
                    }
                }
            } else {
                NSMutableDictionary *uDict = [NSMutableDictionary dictionary];
                [uDict setObject:@"hide_friend" forKey:@"key"];
                [uDict setObject:[NSNumber numberWithBool:NO] forKey:@"value"];
                [dto.preferences addObject:uDict];
                [UserManager checkUser:dto];
            }
            
        }
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)pointSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices pointSignIn:param success:success failure:failure];
}

+ (void)getSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getSignIn:param success:success failure:failure];
}

+ (void)addUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices addUserTag:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

+ (void)searchMarkUserListWithName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices searchMarkUserListWithName:param success:^(id JSON) {
        NSMutableArray *array = [NSMutableArray array];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSMutableArray *result = [NSMutableArray arrayWithArray:[JSON objectForKey:@"result"]];
            for (int i = 0; i < result.count; i ++) {
                UserDTO *dto = [[UserDTO alloc] init:[result objectAtIndex:i]];
                [array addObject:dto];
            }
        }
        success (array);
    } failure:failure];
}

+ (void)ignoreUser:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices ignoreUser:param success:success failure:failure];
}


+ (void)getCommentFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getCommonFriend:param success:success failure:failure];
}

+ (void)getUserCertification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getUserCertification:param success:success failure:failure];
}

+ (void)delUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices delUserTag:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

+ (void)reportUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices reportUserTag:param success:(SuccessBlock)success failure:(FailureBlock)failure];
}

+ (void)registerDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices registerDevice:param success:success failure:failure];
}

+ (void)deleteDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteDevice:param success:success failure:failure];
}

+ (void)getCertificationChange:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getCertificationChange:param success:success failure:failure];
    }
}

+ (BOOL)isHit:(NSInteger)method
{
    if (
        (method > MethodType_UserInfo_Start && method < MethodType_UserInfo_End)
        ||(method > MethodType_User_Start && method < MethodType_User_End)
        || MethodType_UserInfo_Update == method
        || MethodType_UserInfo_AddExperience == method
        || MethodType_UserInfo_UpadteExperience == method
        || MethodType_UserInfo_DeleteExperience == method
        || MethodType_User_RegisterDevice == method
        || MethodType_User_DeleteDevice == method
        ) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)logoutExitEngine:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices logoutExitEngine:param success:success failure:failure];
}

/**获取用户学术标签*/
+ (void)getAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getAcademicTag:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSArray *result = JSON[@"result"];
            NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
            if (result.count > 0) {
                [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AcademicTagDTO *dto = [[AcademicTagDTO alloc] init:obj];
                    [dtoArray addObject:dto];
                }];
            }
             success(dtoArray);
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

/**获取用户系统学术标签*/
+ (void)getAcademicTagSystem:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getAcademicTagSystem:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSArray *result = JSON[@"result"];
            NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
            if (result.count > 0) {
                [result enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AcademicTagDTO *dto = [[AcademicTagDTO alloc] init];
                    dto.tagName = obj;
                    [dtoArray addObject:dto];
                }];
                
                success(dtoArray);
            }
        }

    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)postUserCard:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices postUserCard:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

/**添加用户学术标签*/
+ (void)addAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices addAcademicTag:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

/**删除用户学术标签*/
+ (void)delAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices delAcademicTag:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

/**对用户学术标签点赞*/
+ (void)likeAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices likeAcademicTag:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

/**获取我关注的企业*/
+ (void)getConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getConcernEnterprise:param success:^(id JSON) {
         NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
        if ([JSON[@"success"] boolValue]) {
            NSArray *result = JSON[@"result"];
            [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * stop) {
                EnterpriseDTO *dto = [[EnterpriseDTO alloc] init:obj];
                [dtoArray addObject:dto];
            }];
        }
        success(dtoArray);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

/**删除我关注的企业*/
+ (void)deleteConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getConcernEnterprise:param success:^(id JSON) {
        NSMutableArray *dtoArray = [[NSMutableArray alloc] init];
        if ([JSON[@"success"] boolValue]) {
            NSArray *result = JSON[@"result"];
            [result enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * stop) {
                EnterpriseDTO *dto = [[EnterpriseDTO alloc] init:obj];
                [dtoArray addObject:dto];
            }];
        }
        success(dtoArray);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)insertUsers:(NSArray *)users
{
    [[DB shareInstance] insertUsers:users];
}

/**获取我收藏的职位*/
+ (void)getCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getCollectionJobs:param success:^(id JSON) {
        NSArray *array = [JSON objectForKey:@"result"];
        NSMutableArray *positons = [NSMutableArray array];
        for (NSInteger i = 0; i < array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            HomeJobChannelEmploymentDTO *dto = [[HomeJobChannelEmploymentDTO alloc] init:dict];
            [positons addObject:dto];
        }
        success(positons);
        
    } failure:^(NSError *error, id JSON) {
        
        failure (error, JSON);
        
    }];
}

+ (void)getPointSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getPointSuccess:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure (error, JSON);
    }];
}

@end
