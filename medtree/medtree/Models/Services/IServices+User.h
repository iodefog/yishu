//
//  IServices+User.h
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServices.h"
#import "DataManager.h"

@interface IServices (User)

/*个人信息*/
+ (void)getUserInfo:(NSString *)userid success:(SuccessBlock)success failure:(FailureBlock)failure;
/*获取用户信息*/
+ (void)searchUserInfo:(NSString *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure;
/*用户列表*/
+ (void)getUserList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*上传联系人列表*/
+ (void)importContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*通讯录好友统计*/
//+ (void)statContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*已加入医树的通讯录好友*/
+ (void)getJoinedContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*获取标记好友列表*/
+ (void)getMarkContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*获取好友匹配进度*/
//+ (void)getMatchProcess:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*标记好友*/
+ (void)markContacts:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*添加好友*/
+ (void)addFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*删除好友*/
+ (void)deleteFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*处理好友请求*/
+ (void)processFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*获取好友请求列表*/
+ (void)getFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*删除好友请求*/
+ (void)deleteFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*更新个人信息*/
+ (void)updateUserInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*增加个人经历*/
+ (void)addUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*更新个人经历*/
+ (void)updateUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*删除个人经历*/
+ (void)deleteUserExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*检查好友请求状态*/
+ (void)checkFriendRequest:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/*用户反馈*/
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

/*添加用户标签*/
+ (void)addUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*删除标签*/
+ (void)delUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*举报标签*/
+ (void)reportUserTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)searchMarkUserListWithName:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)ignoreUser:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/*得到共同好友*/
+ (void)getCommonFriend:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getUserCertification:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)registerDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteDevice:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
// 切换网络退出用户，切换引擎
+ (void)logoutExitEngine:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getCertificationChange:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**获取用户学术标签*/
+ (void)getAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/**获取用户学术系统标签*/
+ (void)getAcademicTagSystem:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**用户名片信息修改*/
+ (void)postUserCard:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**添加用户学术标签*/
+ (void)addAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**删除用户学术标签*/
+ (void)delAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**对用户学术标签点赞*/
+ (void)likeAcademicTag:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//v4.1
/**我关注的企业*/
+ (void)getConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteConcernEnterprise:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 添加简历 */
+ (void)addResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 修改简历 */
+ (void)putResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 获取简历 */
+ (void)getResume:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**我的收藏的职位*/
+ (void)getCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**删除收藏的职位*/
+ (void)deleteCollectionJobs:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  关于积分
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)getPointSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
