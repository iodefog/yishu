//
//  TopicManager.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TopicManager.h"
#import "IServices+Public.h"
#import "TopicDTO.h"
#import "FeedDTO.h"
#import "DB+Public.h"

@implementation TopicManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
    switch (method) {
        case MethodType_Topic_GetTopicDB:
        {
            [[DB shareInstance] selectTopicDTOResult:^(NSArray *array) {
                success(array);
            }];
            break;
        }
        case MethodType_Topic_GetTopic:{
            [IServices getTopic:param success:^(id JSON) {
                NSMutableArray *array = [NSMutableArray array];
                NSMutableArray *result = [JSON objectForKey:@"result"];
                for (int i = 0; i < result.count; i ++) {
                    TopicDTO *dto = [[TopicDTO alloc] init:[result objectAtIndex:i]];
                    [[DB shareInstance] selecTopicWithTopicID:^(NSArray *array) {
                        if (array.count > 0) {
                            [[DB shareInstance] updateTopic:dto];
                        } else {
                            [[DB shareInstance] insertTopic:dto];
                        }
                    } topicID:dto.topicID];
                    [array addObject:dto];
                }
                success(array);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Topic_GetTopicFeedsMore:
        case MethodType_Topic_GetTopic2Feeds:
        case MethodType_Topic_GetTopicFeeds:{
            [IServices getTopicFeeds:param success:^(id JSON) {
                NSArray *array = [JSON objectForKey:@"result"];
                NSMutableArray *feeds = [NSMutableArray array];
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dict = [array objectAtIndex:i];
                    FeedDTO *dto = [[FeedDTO alloc] init:dict];
                    [feeds addObject:dto];
                }
                success(feeds);
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Topic_SearchTopicUsers:{
            [IServices searchTopicUsers:param success:^(id JSON) {
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Topic_GetTopicByID:{
            [IServices getTopicByID:param success:^(id JSON) {
                NSDictionary *dict = [JSON objectForKey:@"result"];
                TopicDTO *dto = [[TopicDTO alloc] init:dict];
                success(dto);
            } failure:^(NSError *error, id JSON) {
 
                failure(error,JSON);
            }];
            break;
        }
        default:
            break;
    }
            
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    //
    switch (method) {
        case MethodType_Topic_PostTopicLike:{
            [IServices postTopicLike:param success:^(id JSON) {

                success(JSON);
            } failure:^(NSError *error, id JSON) {

                failure(error,JSON);
            }];
            break;
        }
        case MethodType_Topic_DeleteTopicLike:{
            [IServices deleteTopicLike:param success:^(id JSON) {

                success(JSON);
            } failure:^(NSError *error, id JSON) {

                failure(error,JSON);
            }];
            break;
        }
        default:
            break;
    }
}

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Topic_Start && method < MethodType_Topic_End) {
        return YES;
    } else {
        return NO;
    }
}

@end
