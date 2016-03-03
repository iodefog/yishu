//
//  ChannelManager.m
//  medtree
//
//  Created by tangshimi on 9/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "ChannelManager.h"
#import "IServices+Channel.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "UserDTO.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "UserManager.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"
#import "RecommendDTO.h"
#import "AccountHelper.h"
#import "HomeJobChannelHotEmploymentDTO.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "HomeJobChannelEmploymentDTO.h"
#import "DataManager+Cache.h"

@implementation ChannelManager

+ (void)getChannelParam:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    MethodTypeChannel method = [[dict objectForKey:@"method"] integerValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];

    switch (method) {
        case MethodTypeChannelHomePage:{
            [IServices getChannelHomePageParams:param Success:^(id JSON) {
                NSDictionary *dic = JSON;
                
                success([self paraseDiscussionAndArticleData:dic]);
                
                [DataManager cache:dict data:JSON];
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelRecommend: {
            [IServices getChannelRecommendParams:param Success:^(id JSON) {
                success([self paraseDiscussionAndArticleData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelRecommendTags: {
            [IServices getChannelRecommendTagsParams:param Success:^(id JSON) {
                NSDictionary *dict = JSON;
                
                NSDictionary *resultDic = @{ @"status" : dict[@"success"],
                                             @"myTags" : dict[@"meta"][@"mytags"],
                                             @"allTags" : dict[@"result"] };
                success(resultDic);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelRecommendPostTags: {
            [IServices getChannelRecommendPostTagsParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelSquare: {
            [IServices getChannelSquareParams:param Success:^(id JSON) {
                success([self paraseDiscussionAndArticleData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelPublishDiscussion: {
            [IServices getChannelPublishDiscussionParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelFavour: {
            [IServices getChannelFavourParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelUnFavour: {
            [IServices getChannelUnFavourParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelInvitePeopleList: {
            [IServices getChannelInvitePeopleListParams:param Success:^(id JSON) {
                if (JSON[@"success"]) {
                    NSMutableArray *array = [NSMutableArray new];
                    for (NSDictionary *dic in JSON[@"result"]) {
                        UserDTO *dto = [[UserDTO alloc] init:dic];
                        [array addObject:dto];
                    }
                    success(array);
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelInvitePeople: {
            [IServices getChannelInvitePeopleParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelDetailComment: {
            [IServices getChannelDetailCommentParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelComment: {
            [IServices getChannelCommentParams:param Success:^(id JSON) {
                success([self paraseCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelCommentByID: {
            [IServices getChannelCommentByIDParams:param Success:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    HomeArticleAndDiscussionDTO *dto = [[HomeArticleAndDiscussionDTO alloc] init:JSON[@"result"]];
                    success(dto);
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                } 
            }];
            break;
        }
        case MethodTypeChannelCommentFeed: {
            [IServices getChannelCommentFeedParams:param Success:^(id JSON) {
                success([self paraseFeedCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelDeleteCommentFeed: {
            [IServices getChannelDeleteCommentFeedParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelDailyAdvertisement: {
            [IServices getChannelDailyAdvertisementSuccess:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    NSMutableArray *array = [NSMutableArray new];
                    for (NSDictionary *dic in JSON[@"result"]) {
                        RecommendDTO *dto = [[RecommendDTO alloc] init:dic];
                        [array addObject:dto];
                    }
                    success(array);
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelHomepageAdvertisement: {
            [IServices getChannelHomepageAdvertisementSuccess:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    NSMutableArray *array = [NSMutableArray new];
                    for (NSDictionary *dic in JSON[@"result"]) {
                        RecommendDTO *dto = [[RecommendDTO alloc] init:dic];
                        [array addObject:dto];
                    }
                    success(array);
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelHomePage: {
            [IServices getJobChannelHomePageParams:param Success:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    success([self paraseHotEmploymentEnterpriseAndEmployment:JSON]);
                    
                    [DataManager cache:dict data:JSON];
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelPostinterests: {
            [IServices getJobChannelPostInterestParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                } 
            }];
            break;
        }
        case MethodtypeJonChannelGetInterests: {
            [IServices getJobChannelGetInterestSuccess:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            
            break;
        }
        case MethodTypeChannelDeleteDiscussion: {
            [IServices getChannelDeleteDiscussionParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeChannelMoreChannel: {
            [IServices getChannelMoreParams:param Success:^(id JSON) {
                NSMutableArray *array = [NSMutableArray new];
                for (NSDictionary *dict in JSON[@"result"]) {
                    HomeRecommendChannelDetailDTO *dto = [[HomeRecommendChannelDetailDTO alloc] init:dict];
                    [array addObject:dto];
                }
                
                NSDictionary *result = @{ @"success" : JSON[@"success"], @"channelArray" : array };
                success(result);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
            
        case MethodTypeJobChannelEnterprise: {
           [IServices getJobChannelEnterpriseParams:param Success:^(id JSON) {
               if ([JSON[@"success"] boolValue]) {
                   NSMutableArray *array = [NSMutableArray new];
                   for (NSDictionary *dic in JSON[@"result"]) {
                       HomeJobChannelHotEmploymentDetailDTO *dto = [[HomeJobChannelHotEmploymentDetailDTO alloc] init:dic];
                       [array addObject:dto];
                   }
                   success( @{ @"resultArray" : array });
               }
           } failure:^(NSError *error, id JSON) {
               if (failure) {
                   failure(error, JSON);
               }
           }];
            break;
        }
        case MethodTypeJobChannelEmployment: {
            [IServices getJobChannelEmploymentParams:param Success:^(id JSON) {
                if ([JSON[@"success"] boolValue]) {
                    NSMutableArray *array = [NSMutableArray new];
                    for (NSDictionary *dic in JSON[@"result"]) {
                        HomeJobChannelEmploymentDTO *dto = [[HomeJobChannelEmploymentDTO alloc] init:dic];
                        [array addObject:dto];
                    }
                    success( @{ @"resultArray" : array });
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelFunctionLevelOne: {
            [IServices getJobChannelFunctionLevelOneSuccess:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelFunctionLevelTwo: {
            [IServices getJobChannelFunctionlevelTwoParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEmploymentComment:{
            [IServices getJobChannelEmploymentCommentParams:param Success:^(id JSON) {
                success([self paraseCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEmploymentPublishFeed: {
            [IServices getJobChannelEmploymentPublishFeedParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEmploymentCommentFeed: {
            [IServices getJobChannelEmploymentCommentFeedParams:param Success:^(id JSON) {
                success([self paraseFeedCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEmploymenFeedFavour: {
            [IServices getJobChannelEmploymentCommentFeedFavourParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }

            }];
            break;
        }
        case MethodTypeJobChannelEmploymenFeedUnFavour: {
            [IServices getJobChannelEmploymentCommentFeedUnFavourParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEnterpriseRelation: {
            [IServices getJobChannelEnterpriseRelationParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            
            break;
        }
        case MethodTypeJonChannelSearchPostInfomation:{
            [IServices getJobChannelPostSearchInfoParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelDeleteFeed: {
            [IServices getJobChannelDeleteFeedParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelDeleteComment: {
            [IServices getJobChannelDeleteCommentParams:param Success:^(id JSON) {
                success(JSON);
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
        case MethodTypeJobChannelEmploymentByID: {
            [IServices getChannelEmploymentByIDParams:param Success:^(id JSON) {
                if (JSON[@"success"]) {
                    HomeJobChannelEmploymentDTO *dto = [[HomeJobChannelEmploymentDTO alloc] init:JSON[@"result"]];
                    
                    success(@{@"success" : @(YES), @"employment" : dto } );
                } else {
                    success(JSON);
                }
            } failure:^(NSError *error, id JSON) {
                if (failure) {
                    failure(error, JSON);
                }
            }];
            break;
        }
    }
}

+ (void)getChannelFromLocalParam:(NSDictionary *)dict success:(SuccessBlock)success
{
    id json = [DataManager redaCache:dict];
    
    MethodTypeChannel method = [[dict objectForKey:@"method"] integerValue];

    switch (method) {
        case MethodTypeChannelHomePage:
            if (json) {
                success([self paraseDiscussionAndArticleData:json]);
            } else {
                success(nil);
            }
            break;
        case MethodTypeJobChannelHomePage:
            if (json) {
                success([self paraseHotEmploymentEnterpriseAndEmployment:json]);
            } else {
                success(nil);
            }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - helper -

+ (NSDictionary *)paraseDiscussionAndArticleData:(NSDictionary *)dict
{
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] init];
    if ([dict objectForKey:@"meta"]) {
        if ([[dict objectForKey:@"meta"] objectForKey:@"profiles"]) {
            NSArray *user = [NSArray arrayWithArray:[[dict objectForKey:@"meta"] objectForKey:@"profiles"]];
            if (user.count > 0) {
                for (int i = 0; i < user.count; i ++) {
                    UserDTO *dto = [[UserDTO alloc] init:[user objectAtIndex:i]];
                    [userDict setObject:dto.name forKeyedSubscript:dto.userID];
                    if (![[AccountHelper getAccount].userID isEqualToString:dto.userID]) {
                        [UserManager checkUser:dto];
                    }
                }
            }
        }
    }
    
    NSMutableArray *channelArray = [NSMutableArray new];
    for (NSDictionary *channelDic in dict[@"meta"][@"channels"]) {
        HomeRecommendChannelDetailDTO *dto = [[HomeRecommendChannelDetailDTO alloc] init:channelDic];
        [channelArray addObject:dto];
    }
    
    NSMutableArray *articleAndDiscussionArray = [NSMutableArray new];
    for (NSDictionary *dic in dict[@"result"]) {
        HomeArticleAndDiscussionDTO *dto = [[HomeArticleAndDiscussionDTO alloc] init:dic];
        [articleAndDiscussionArray addObject:dto];
    }
    
    NSMutableDictionary *resultDic = @{ @"status" : dict[@"success"],
                                        @"recommandChannel" : channelArray,
                                        @"ArticleAndDiscussion" : articleAndDiscussionArray }.mutableCopy;
    if (dict[@"meta"][@"has_more_channel"]) {
        resultDic[@"hasMoreChannel"] = dict[@"meta"][@"has_more_channel"];
    }
    
    return resultDic;
}

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
    
    NSMutableDictionary *resultDic = @{ @"status" : dict[@"success"],
                                        @"commentArray" : commentArray }.mutableCopy;
    if (dict[@"message"]) {
        resultDic[@"message"] = dict[@"message"];
    }
    
    return resultDic;
}

+ (NSDictionary *)paraseFeedCommentData:(NSDictionary *)dict
{
    if ([dict[@"success"] integerValue]) {
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
        
        if (dict[@"result"]) {
            MedFeedCommentDTO *feed = [[MedFeedCommentDTO alloc] init:dict[@"result"]];
            feed.creatorName = [userDict objectForKey:[NSString stringWithFormat:@"%@", feed.creatorID]];
            feed.replyUserName = [userDict objectForKey:[NSString stringWithFormat:@"%@", feed.replyUserID]];
            NSDictionary *resultDic = @{ @"success" : @(YES), @"comment" : feed };
            
            return resultDic;
        }
    } else {
        return dict;
    }
    return nil;
}

+ (NSDictionary *)paraseHotEmploymentEnterpriseAndEmployment:(NSDictionary *)dict
{
    NSMutableArray *hotEmploymentEnterPriseArray = [NSMutableArray new];
    for (NSDictionary *dic in dict[@"meta"][@"enterprises"]) {
        HomeJobChannelHotEmploymentDetailDTO *dto = [[HomeJobChannelHotEmploymentDetailDTO alloc] init:dic];
        [hotEmploymentEnterPriseArray addObject:dto];
    }
    
    NSMutableArray *jobDTOArray = [NSMutableArray new];
    for (NSDictionary *dic in dict[@"result"]) {
        HomeJobChannelEmploymentDTO *dto = [[HomeJobChannelEmploymentDTO alloc] init:dic];
        [jobDTOArray addObject:dto];
    };
    
    NSDictionary *resultDic = @{ @"status" : dict[@"success"],
                                 @"hotEmploymentEnterprise" : hotEmploymentEnterPriseArray,
                                 @"employment" : jobDTOArray };
    return resultDic;
}

@end
