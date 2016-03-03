//
//  IServices+Feed.h
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServices.h"
#import "DataManager.h"

@interface IServices (Feed)

+ (void)getFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getNewFeedLikeList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedUnlike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getNewFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedCommentLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEventFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEventOfficialFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)searchEventFeedForPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedSuggestList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
/** 获取某人的动态列表 */
+ (void)getPersonFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
