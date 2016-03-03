//
//  FeedManager.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DataManager.h"

typedef enum {
    MethodType_Feed_Start               = 500,
    /*动态*/
    MethodType_FeedList                 = 501,
    MethodType_FeedList_More            = 502,
    MethodType_FeedList_Local           = 503,
    MethodType_Feed_Send                = 504,
    MethodType_Feed_Like_Send           = 505,
    MethodType_Feed_Delete              = 506,
    MethodType_Feed_Unlike_Send         = 507,
    MethodType_Feed_SuggestList         = 508,
    MethodType_Feed_SuggestList_More    = 509,
    MethodType_Feed_GetFeed             = 510,
    MethodType_FeedList_Person          = 555,//某人的动态
    MethodType_FeedList_Person_More     = 556,
    MethodType_FeedList_Person_Local    = 557,
    
    /*动态评论*/
    MethodType_FeedCommentList          = 511,
    MethodType_FeedCommentList_More     = 512,
    MethodType_FeedCommentList_Local    = 513,
    MethodType_FeedComment_Send         = 514,
    MethodType_FeedComment_Like_Send    = 515,
    MethodType_FeedComment_Delete       = 516,
    MethodType_FeedCommentList_Refresh  = 517,
    MethodType_Feed_Report              = 518,
    
    MethodType_Feed_NewComment_List     = 521,
    MethodType_Feed_NewComment_List_More= 522,
    MethodType_Feed_NewLike_List        = 523,
    MethodType_Feed_NewLike_List_More   = 524,
    MethodType_Feed_End                 = 599,
} MethodType_Feed;

@class EventDTO;

@interface FeedManager : DataManager

+ (void)getFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedUnlike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEventFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEventOfficialFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendFeedCommentLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)searchEventFeedForPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)deleteAllFeedCache;
//+ (void)checkFeeds:(NSArray *)array;
+ (void)getFeedSuggestList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//+ (void)loadCacheData;

+ (void)getNewFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getNewFeedLikeList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getFeedWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getPersonFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
@end
