//
//  EventManager.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "EventManager.h"
#import "EventDTO.h"
#import "UserDTO.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"

@implementation EventManager

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodTypeEventList: {
            [IServices getEventList:param success:^(id JSON) {
                NSArray *array = [JSON objectForKey:@"result"];
                NSMutableArray *events = [NSMutableArray array];
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dict = [array objectAtIndex:i];
                    EventDTO *dto = [[EventDTO alloc] init:dict];
                    [events addObject:dto];
                }
                success(events);
            }failure:^(NSError *error, id JSON) {
                failure (error, JSON);
            }];
             break;
        }
        case MethodTypeEventFeedList: {
            [IServices getEventFeedList:param success:^(id JSON) {
                success([self paraseCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];

            break;
        }
        case MethodTypeEventFeedSearch: {
            [IServices searchEventFeedForPeople:param success:^(id JSON) {
                success([self paraseCommentData:JSON]);
            } failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
            
            break;
        }
        case MethodTypeEventFeedByID: {
            [IServices getEventByID:param success:^(id JSON) {
                if ([[JSON objectForKey:@"success"] boolValue]) {
                    NSDictionary *dict = [JSON objectForKey:@"result"];
                    EventDTO *dto = [[EventDTO alloc] init:dict];
                    success(dto);
                } else {
                    success(nil);
                }
                
            } failure:^(NSError *error, id JSON) {
                failure(error,JSON);
            }];
        
            break;
        }
    }
}



+ (void)getEventList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getEventList:param success:^(id JSON) {
            NSArray *array = [JSON objectForKey:@"result"];
            NSMutableArray *events = [NSMutableArray array];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dict = [array objectAtIndex:i];
                EventDTO *dto = [[EventDTO alloc] init:dict];
                [events addObject:dto];
            }
            success(events);
        } failure:^(NSError *error, id JSON) {
            failure (error, JSON);
        }];
    }
}

+ (void)getEventListFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllEvents:^(NSArray *array) {
        success(array);
    }];
}

+ (void)getEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getEvent:param success:success failure:failure];
}

+ (void)getEventByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getEventByID:param success:^(id JSON) {
        
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSDictionary *dict = [JSON objectForKey:@"result"];
            EventDTO *dto = [[EventDTO alloc] init:dict];
            success(dto);
        } else {
            success(nil);
        }
        
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)setRecommendEvent:(NSDictionary *)dict
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"recommendEvent",@"info":dto} success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getRecommendEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices getRecommendEvent:param success:^(id JSON) {
            NSArray *array = [JSON objectForKey:@"result"];
//            #warning 推荐缓存
            dispatch_async(dispatch_get_main_queue(), ^{
                if (array.count > 0) {
                    DTOBase *baseDTO = [[DTOBase alloc] init:JSON];
                    NSDictionary *dict = @{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree], @"key": [NSString stringWithFormat:@"getRecommendEvent_%@",[param objectForKey:@"channel"]], @"info": baseDTO};
                    [ServiceManager setData:dict success:^(id JSON) {
                        NSLog(@"update %@", JSON);
                    } failure:^(NSError *error, id JSON) {
                        
                    }];
                }
            });
            NSMutableArray *events = [NSMutableArray array];
            for (int i=0; i<array.count; i++) {
//                NSDictionary *dict = [array objectAtIndex:i];
//                RecommendDTO *dto = [[RecommendDTO alloc] init:dict];
//                [events addObject:dto];
            }
            [EventManager setRecommendEvent:JSON];
            success(events);
        } failure:^(NSError *error, id JSON) {
            if (failure) {
                failure (error, JSON);
            }
        }];
    }
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
    
    NSDictionary *resultDic = @{ @"status" : dict[@"success"],
                                 @"commentArray" : commentArray };
    return resultDic;
}

@end
