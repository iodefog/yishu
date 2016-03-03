//
//  IServices+Forum.h
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Forum)

+ (void)getForumList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getForumWithPostID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getForumUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getForumCategories:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)postForumWithPostID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postQuestion:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)closePost:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postInviteUsers:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUnreadInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getForumWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteForumComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)forumShareToFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)forumAddPoint:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getRecommendForumList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)notLikeForumCommont:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)likeForumCommont:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
