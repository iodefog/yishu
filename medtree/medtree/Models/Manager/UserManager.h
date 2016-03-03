//
//  UserManager.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DataManager.h"

@class PeopleDTO;

typedef enum {
    
    MethodType_UserInfo_Start           = 100,
    /*获取用户信息*/
    MethodType_UserInfo                 = 101,
    MethodType_UserInfo_Local           = 102,
    MethodType_UserInfo_Search          = 103,
    MethodType_UserInfo_CheckRequest    = 104,
    MethodType_UserInfo_Account_Token   = 105,
    MethodType_UserInfo_CertificationApply = 106,
    MethodType_UserInfo_Certification   = 107,
    MethodType_UserInfo_Qr_card         = 108,
    MethodType_UserInfo_MatchProcess    = 109,
    MethodType_UserInfo_IM_Password     = 110,
    
    /*更新用户信息*/
    MethodType_UserInfo_Update          = 111,
    MethodType_UserInfo_Update_Local    = 112,
    MethodType_UserInfo_AddExperience   = 113,
    MethodType_UserInfo_UpadteExperience  = 114,
    MethodType_UserInfo_DeleteExperience  = 115,
    MethodType_UserInfo_Feedback        = 116,
    
    
    MethodType_UserInfo_Privacy         = 117,
    MethodType_UserInfo_FriendsPrivacy  = 118,
    
    MethodType_UserInfo_SignPost        = 119,
    MethodType_UserInfo_SignGet         = 120,
    
    MethodType_UserInfo_AddTag          = 121,
    MethodType_UserInfo_SearchName      = 122,
    MethodType_UserInfo_IgnoreUser      = 123,
    MethodType_UserInfo_UserCertification = 124,
    
    /*获取用户学术标签*/
    MethodType_UserInfo_AcademicTag      = 125,
    
    /*获取朋友列表*/
    MethodType_FriendList               = 201,
    MethodType_FriendList_Local         = 202,//好友
    
    MethodType_Comment_FriendList       = 203,
    MethodType_Comment_FriendList_More  = 204,
    MethodType_Comment_FriendList_Local = 205,
    
    /*获取同事列表*/
    MethodType_ColleagueList            = 211,
    MethodType_ColleagueList_Local      = 212,//同事
    
    MethodType_Classmate_Local          = 213,//校友
    
    MethodType_SameOccupation_Local     = 214,//同行
    
    MethodType_FriendFriend_Local       = 215,//好友的好友
    
    /*获取校友列表*/
    MethodType_ClassmateList            = 221,
    MethodType_ClassmateList_Local      = 222,
    
    /*邀请好友*/
    MethodType_Import_Contact           = 231,
    MethodType_Import_Weibo             = 232,
    
    /*添加好友*/
    MethodType_Add_Friend               = 241,
    MethodType_Accept_Friend            = 242,
    MethodType_Deny_Friend              = 243,
    MethodType_Mark_Friend_Local        = 244,
    MethodType_Mark_Friend_Net          = 245,
    MethodType_Delete_Friend            = 246,
    MethodType_Invite_Friend            = 247,
    MethodType_Name_SameUser            = 248,
    MethodType_DiscoveryPeopleNear      = 249,
    MethodType_ConnectionPeer           = 250,
    MethodType_DeleteConnectionPeer     = 251,
    
    /*获取朋友列表*/
    MethodType_NewFriendList            = 251,
    MethodType_NewFriendList_Local      = 252,
    MethodType_NewFriend_Delete         = 253,
    
    /*已加入医树的通讯录好友*/
    MethodType_JoinedFriendList         = 261,
    MethodType_Certification            = 262,
    
    /*职场*/
    MethodType_ConcernEnterprise        = 270,  // 我关注的企业
    MethodType_ConcernEnterprise_Delete = 271,  // 删除我关注的企业
    MethodType_Resume_Post              = 272,  // 投递简历
    MethodType_Resume_Put               = 273,  // 修改简历
    MethodType_Resume_Get               = 274,  // 获取简历
    MethodType_CollectionJobs           = 275,   //我的收藏职位
    MethodType_CollectionJobs_Delete    = 276,   //删除收藏的职位
    
    MethodTypeAboutPoint,
    
    /** 退出登录 */
    MethodType_Logout                   = 298,
    
    MethodType_UserInfo_End             = 299,
} MethodType_UserInfo_Interval;

typedef enum {
    MethodType_User_Start               = 1000,
    /*注册*/
    MethodType_UserLogin                = 1001,
    MethodType_UserLogout               = 1002,
    MethodType_UserRegister             = 1003,
    MethodType_UserRegisterAll          = 1004,
    MethodType_User_End                 = 1999,
} MethodType_User;


typedef enum {
    
   MethodType_User_RegisterDevice      = 5000,
   MethodType_User_DeleteDevice        = 5001,
} MethodType_User_RegisterDevice_Info;


@class UserDTO;
@class NotificationDTO;

@interface UserManager : DataManager

+ (void)getUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserInfoFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserInfoFull:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)searchUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//+ (void)getFriendList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFriendListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFriendListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//+ (void)getColleagueList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getColleagueListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//+ (void)getClassmateList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getClassmateListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;


+ (void)login:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)logout:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)reg:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 3.5的手机注册 */
+ (void)registerAllInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)checkUser:(UserDTO *)dto type:(NSInteger)type;
+ (void)checkUser:(UserDTO *)dto;
+ (void)loadCacheData;

+ (void)importContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)statContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)addFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)acceptFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)denyFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)addFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)receivedFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFriendRequestFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFriendRequestFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)checkNotification:(NotificationDTO *)dto;
+ (void)checkFriendRequestFromLocal:(NSArray *)array;

+ (void)markAllNotificationAsRead;
+ (void)getAllNotificationUnreadCounts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getMarkFriendFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getMarkFriendFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getPeopleSameName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)markFriendRelation:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)checkFriendRelationsFromLocal:(NSArray *)array;

+ (void)checkContactUpdate;
+ (void)checkContactUpdate:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getJoinedContactsFromNet:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)checkFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)getMatchProcess:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)feedback:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getAccess_tokenRefresh:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getIm_password:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)certificationApply:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)certification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)qr_card:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)discoveryPeopleNear:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)connectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteConnectionPeer:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)connectionUserSelf:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)connectionUserFriends:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;


+ (void)pointSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getSignIn:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)addUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)searchMarkUserListWithName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)ignoreUser:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getCommentFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUserCertification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)delUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)reportUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)registerDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//同事缓存
+ (void)getColleagueFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//校友缓存
+ (void)getClassmateFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//同行缓存
+ (void)getSameOccupationFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//好友的好友缓存
+ (void)getFriendFriendFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//缓存用户关系
+ (void)cacheRelation:(PeopleDTO *)dto type:(NSInteger)type;

// 切换网络退出用户，切换引擎
+ (void)logoutExitEngine:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**获取用户学术标签*/
+ (void)getAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**获取用户系统学术标签*/
+ (void)getAcademicTagSystem:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**编辑用户名片*/
+(void)postUserCard:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**添加用户学术标签*/
+ (void)addAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**删除用户学术标签*/
+ (void)delAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**对用户学术标签点赞*/
+ (void)likeAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**获取我关注的企业*/
+ (void)getConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/**删除我关注的企业*/
+ (void)deleteConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)insertUsers:(NSArray *)users;

/**获取我收藏的职位*/
+ (void)getCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getPointSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
