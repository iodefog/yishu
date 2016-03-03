//
//  FeedManager.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "FeedManager.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"
#import "FeedLikeDTO.h"
#import "DB+Public.h"
#import "UserDTO.h"
#import "LabelDTO.h"
#import "UserManager.h"
#import "MedGlobal.h"
#import "EventManager.h"
#import "DB+EventFeed.h"
#import "HomeArticleAndDiscussionDTO.h"

@implementation FeedManager

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Feed_Start && method < MethodType_Feed_End) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
//        case MethodType_EventFeedList_More:
//        case MethodType_EventFeed2List:
//        case MethodType_EventFeedList: {
//            [FeedManager getEventFeedList:param success:success failure:failure];
//            break;
//        }
//        case MethodType_EventOfficialFeedList_More:
//        case MethodType_EventOfficialFeedList: {
//            [FeedManager getEventOfficialFeedList:param success:success failure:failure];
//            break;
//        }
//        case MethodType_EventFeedSearchPeople: {
//            [FeedManager searchEventFeedForPeople:param success:success failure:failure];
//            break;
//        }
        case MethodType_FeedList_More:
        case MethodType_FeedList: {
            [FeedManager getFeedList:param success:success failure:failure];
            break;
        }
        case MethodType_FeedList_Local: {
            [FeedManager getFeedListFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_NewLike_List:
        case MethodType_Feed_NewLike_List_More: {
            [FeedManager getNewFeedLikeList:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_NewComment_List:
        case MethodType_Feed_NewComment_List_More: {
            [FeedManager getNewFeedCommentList:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_SuggestList_More:
        case MethodType_Feed_SuggestList: {
            [FeedManager getFeedSuggestList:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_GetFeed: {
            [FeedManager getFeedWithID:param success:success failure:failure];
            break;
        }
        case MethodType_FeedCommentList_Refresh:
        case MethodType_FeedCommentList_More:
        case MethodType_FeedCommentList: {
            [FeedManager getFeedCommentList:param success:success failure:failure];
            break;
        }
        case MethodType_FeedList_Person: {
            [FeedManager getPersonFeedList:param success:success failure:failure];
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
        case MethodType_Feed_Report: {
            [FeedManager report:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_Send: {
            [FeedManager sendFeed:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_Delete: {
            [FeedManager deleteFeed:param success:success failure:failure];
            break;
        }
        case MethodType_FeedComment_Send: {
            [FeedManager sendFeedComment:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_Like_Send: {
            [FeedManager sendFeedLike:param success:success failure:failure];
            break;
        }
        case MethodType_Feed_Unlike_Send: {
            [FeedManager sendFeedUnlike:param success:success failure:failure];
            break;
        }
        case MethodType_FeedComment_Like_Send: {
            [FeedManager sendFeedCommentLike:param success:success failure:failure];
            break;
        }
        case MethodType_FeedComment_Delete: {
            [FeedManager deleteFeedComment:param success:success failure:failure];
            break;
        }
    }
}

+ (void)getFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getFeedList:param success:^(id JSON) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            if ([JSON objectForKey:@"meta"]) {
                if ([[JSON objectForKey:@"meta"] objectForKey:@"profiles"]) {
                    NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                    if (user.count > 0) {
                        for (int i = 0; i < user.count; i ++) {
                            UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                            [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                            [UserManager checkUser:dto];
                        }
                    }
                }
            }
            
            NSMutableArray *feeds = [NSMutableArray array];
//            for (int i=0; i<array.count; i++) {
//                NSDictionary *dict = [array objectAtIndex:i];
//                MedFeedDTO *dto = [[MedFeedDTO alloc] init:dict];
//                NSMutableArray *commonArray = [NSMutableArray arrayWithArray:dto.comments];
//                NSMutableArray *data = [NSMutableArray array];
//                for (int i = 0; i < commonArray.count; i ++) {
//                    NSMutableDictionary *cdict= [NSMutableDictionary dictionaryWithDictionary:[commonArray objectAtIndex:i]];
//                    if ([userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]]) {
//                        NSString *name = [userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]];
//                        [cdict setObject:name forKey:@"reply_to_user_name"];
//                    }
//                    [data addObject:cdict];
//                }
//                [dto.comments removeAllObjects];
//                [dto.comments addObjectsFromArray:data];
//                [feeds addObject:dto];
//            }
            
            //缓存好友动态
//            [FeedManager checkFeeds:feeds];
            
            success(feeds);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)getFeedListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllFeeds:^(NSArray *array) {
        success(array);
    }];
}

//活动动态缓存
+ (void)getEventFeedListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
    [[DB shareInstance] selectAllEventFeedsWithId:[param objectForKey:@"eventid"] block:^(NSArray *array) {
        success(array);
    }];
}

+ (void)getFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getFeed:param success:success failure:failure];
}

+ (void)sendFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices sendFeed:param success:success failure:failure];
}

+ (void)deleteFeed:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteFeed:param success:success failure:failure];
}

+ (void)sendFeedLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices sendFeedLike:param success:success failure:failure];
}

+ (void)getNewFeedLikeList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getNewFeedLikeList:param success:^(id JSON) {
        
        NSArray *array = [JSON objectForKey:@"result"];
        NSMutableArray *likes = [NSMutableArray array];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            FeedLikeDTO *dto = [[FeedLikeDTO alloc] init:dict];
            [likes addObject:dto];
        }
        NSInteger total = [[JSON objectForKey:@"total"] integerValue];
        NSDictionary *data = @{@"data": likes, @"total": [NSNumber numberWithInteger:total]};
        success(data);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)sendFeedUnlike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices sendFeedUnlike:param success:success failure:failure];
}

+ (void)getFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getFeedCommentList:param success:^(id JSON) {
            NSArray *array = [JSON objectForKey:@"result"];
            NSMutableArray *feeds = [NSMutableArray array];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dict = [array objectAtIndex:i];
                MedFeedCommentDTO *dto = [[MedFeedCommentDTO alloc] init:dict];
                [feeds addObject:dto];
            }
            NSInteger total = [[JSON objectForKey:@"total"] integerValue];
            NSDictionary *data = @{@"data": feeds, @"total": [NSNumber numberWithInteger:total]};
            success(data);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)getNewFeedCommentList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getNewFeedCommentList:param success:^(id JSON) {
        
        NSArray *array = [JSON objectForKey:@"result"];
        NSMutableArray *likes = [NSMutableArray array];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict = [array objectAtIndex:i];
            MedFeedCommentDTO *dto = [[MedFeedCommentDTO alloc] init:dict];
            [likes addObject:dto];
        }
        NSInteger total = [[JSON objectForKey:@"total"] integerValue];
        NSDictionary *data = @{@"data": likes, @"total": [NSNumber numberWithInteger:total]};
        success(data);
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)sendFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices sendFeedComment:param success:success failure:failure];
}

+ (void)sendFeedCommentLike:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices sendFeedCommentLike:param success:success failure:failure];
}

+ (void)deleteFeedComment:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteFeedComment:param success:success failure:failure];
}

+ (void)getEventFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getEventFeedList:param success:^(id JSON) {
            success([self paraseCommentData:JSON]);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)getEventOfficialFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getEventOfficialFeedList:param success:^(id JSON) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            if ([JSON objectForKey:@"meta"]) {
                if ([[JSON objectForKey:@"meta"] objectForKey:@"profiles"]) {
                    NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                    if (user.count > 0) {
                        for (int i = 0; i < user.count; i ++) {
                            UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                            [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                            [UserManager checkUser:dto];
                        }
                    }
                }
            }
            
//            NSArray *array = [JSON objectForKey:@"result"];
//            NSMutableArray *feeds = [NSMutableArray array];
//            for (int i=0; i<array.count; i++) {
//                NSDictionary *dict = [array objectAtIndex:i];
//                MedFeedDTO *dto = [[MedFeedDTO alloc] init:dict];
//                NSMutableArray *commonArray = [NSMutableArray arrayWithArray:dto.comments];
//                NSMutableArray *data = [NSMutableArray array];
//                for (int i = 0; i < commonArray.count; i ++) {
//                    NSMutableDictionary *cdict= [NSMutableDictionary dictionaryWithDictionary:[commonArray objectAtIndex:i]];
//                    
//                    if ([userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]]) {
//                        NSString *name = [userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]];
//                        [cdict setObject:name forKey:@"reply_to_user_name"];
//                    }
//                    [data addObject:cdict];
//                }
//                [dto.comments removeAllObjects];
//                [dto.comments addObjectsFromArray:data];
//                [feeds addObject:dto];
//            }
//            success(feeds);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)searchEventFeedForPeople:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices searchEventFeedForPeople:param success:^(id JSON) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            if ([JSON objectForKey:@"meta"]) {
                if ([[JSON objectForKey:@"meta"] objectForKey:@"profiles"]) {
                    NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                    if (user.count > 0) {
                        for (int i = 0; i < user.count; i ++) {
                            UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                            [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                            [UserManager checkUser:dto];
                        }
                    }
                }
            }
            
//            NSArray *array = [JSON objectForKey:@"result"];
//            NSMutableArray *feeds = [NSMutableArray array];
//            for (int i=0; i<array.count; i++) {
//                NSDictionary *dict = [array objectAtIndex:i];
//                MedFeedDTO *dto = [[MedFeedDTO alloc] init:dict];
//                NSMutableArray *commonArray = [NSMutableArray arrayWithArray:dto.comments];
//                NSMutableArray *data = [NSMutableArray array];
//                for (int i = 0; i < commonArray.count; i ++) {
//                    NSMutableDictionary *cdict= [NSMutableDictionary dictionaryWithDictionary:[commonArray objectAtIndex:i]];
//                    
//                    if ([userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]]) {
//                        NSString *name = [userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]];
//                        [cdict setObject:name forKey:@"reply_to_user_name"];
//                    }
//                    [data addObject:cdict];
//                }
//                [dto.comments removeAllObjects];
//                [dto.comments addObjectsFromArray:data];
//                [feeds addObject:dto];
//            }
//            success(feeds);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)getFeedSuggestList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getFeedSuggestList:param success:^(id JSON) {
            NSDictionary *result = [JSON objectForKey:@"result"];
            NSMutableDictionary *labels = [NSMutableDictionary dictionary];
            for (int i=0; i<result.allKeys.count; i++) {
                NSString *key = [result.allKeys objectAtIndex:i];
                NSArray *array = [result objectForKey:key];
                NSMutableArray *newArray = [NSMutableArray array];
                for (int j=0; j<array.count; j++) {
                    LabelDTO *dto = [[LabelDTO alloc] init:[array objectAtIndex:j]];
                    [newArray addObject:dto];
                }
                [labels setObject:newArray forKey:key];
            }
            success(labels);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

+ (void)report:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices report:param success:success failure:failure];
}

+ (void)getFeedWithID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getFeedWithID:param success:^(id JSON) {
        NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
        if ([JSON objectForKey:@"meta"]) {
            if ([[JSON objectForKey:@"meta"] objectForKey:@"profiles"]) {
                NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                if (user.count > 0) {
                    for (int i = 0; i < user.count; i ++) {
                        UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                        [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                        [UserManager checkUser:dto];
                    }
                }
            }
        }
        
//        if ([[JSON objectForKey:@"success"] boolValue]) {
//            MedFeedDTO *dto = [[MedFeedDTO alloc] init:[JSON objectForKey:@"result"]];
//            NSMutableArray *commonArray = [NSMutableArray arrayWithArray:dto.comments];
//            NSMutableArray *data = [NSMutableArray array];
//            for (int i = 0; i < commonArray.count; i ++) {
//                NSMutableDictionary *cdict= [NSMutableDictionary dictionaryWithDictionary:[commonArray objectAtIndex:i]];
//                
//                if ([userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]]) {
//                    NSString *name = [userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]];
//                    [cdict setObject:name forKey:@"reply_to_user_name"];
//                }
//                [data addObject:cdict];
//            }
//            [dto.comments removeAllObjects];
//            [dto.comments addObjectsFromArray:data];
//            success(dto);
//        } else {
//            success (nil);
//        }
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)getPersonFeedList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getPersonFeedList:param success:^(id JSON) {
            NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
            if ([JSON objectForKey:@"meta"]) {
                if ([[JSON objectForKey:@"meta"] objectForKey:@"profiles"]) {
                    NSArray *user = [NSArray arrayWithArray:[[JSON objectForKey:@"meta"] objectForKey:@"profiles"]];
                    if (user.count > 0) {
                        for (int i = 0; i < user.count; i ++) {
                            UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                            [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                            [UserManager checkUser:dto];
                        }
                    }
                }
            }
            

            NSMutableArray *result = [JSON objectForKey:@"result"];
             NSMutableArray *userdynamicArray = [[NSMutableArray alloc] init];
            if ([result count] > 0) {
               
                for (NSDictionary *dict in result) {
                    HomeArticleAndDiscussionDTO *dto = [[HomeArticleAndDiscussionDTO alloc] init:dict];
                    [userdynamicArray addObject:dto];
                }
            }
            success(userdynamicArray);
            //
//            NSMutableArray *feeds = [NSMutableArray array];
//            for (int i=0; i < array.count; i++) {
//                NSDictionary *dict = [array objectAtIndex:i];
//                MedFeedDTO *dto = [[MedFeedDTO alloc] init:dict];
//                NSMutableArray *commonArray = [NSMutableArray arrayWithArray:dto.comments];
//                NSMutableArray *data = [NSMutableArray array];
//                for (int i = 0; i < commonArray.count; i ++) {
//                    NSMutableDictionary *cdict= [NSMutableDictionary dictionaryWithDictionary:[commonArray objectAtIndex:i]];
//                    if ([userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]]) {
//                        NSString *name = [userDict objectForKey:[[cdict objectForKey:@"reply_to_user_id"] stringValue]];
//                        [cdict setObject:name forKey:@"reply_to_user_name"];
//                    }
//                    [data addObject:cdict];
//                }
//                [dto.comments removeAllObjects];
//                [dto.comments addObjectsFromArray:data];
//                [feeds addObject:dto];
//            }
//            
//            success(feeds);
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON);
        }];
    }
}

#pragma mark -
#pragma mark - helper -

+ (NSDictionary *)paraseCommentData:(NSDictionary *)dict
{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    if ([dict objectForKey:@"meta"]) {
        if ([[dict objectForKey:@"meta"] objectForKey:@"profiles"]) {
            NSArray *user = [NSArray arrayWithArray:[[dict objectForKey:@"meta"] objectForKey:@"profiles"]];
            if (user.count > 0) {
                for (int i = 0; i < user.count; i ++) {
                    UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                    [UserManager checkUser:dto];
                    
                    [userDict setObject:dto.name forKey:dto.userID];
                }
            }
        }
    }
    
    NSMutableArray *commentArray = [NSMutableArray new];
    for (NSDictionary *dic in dict[@"result"]) {
        MedFeedDTO *dto = [[MedFeedDTO alloc] init:dic nameForIDInfo:userDict];
        
        [commentArray addObject:dto];
    }
    
    NSDictionary *resultDic = @{ @"status" : dict[@"success"],
                                 @"commentArray" : commentArray };
    return resultDic;
}

@end
