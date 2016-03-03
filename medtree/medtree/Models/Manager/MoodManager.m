//
//  MoodManager.m
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MoodManager.h"
#import "MoodDTO.h"
#import "DB+Mood.h"
#import "DateUtil.h"

@implementation MoodManager

+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Mood_Start && method < MethodType_Mood_End) {
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
        case MethodType_Mood_GetMood: {
            [MoodManager getMood:param success:success failure:failure];
            break;
        }
        case MethodType_Mood_GetMoodStatistics:{
            [MoodManager getMoodStatistics:param success:success failure:failure];
            break;
        }
        case MethodType_Mood_GetMoodLocal: {
            [MoodManager getMoodFromLocal:param success:success failure:failure];
            break;
        }
        case MethodType_Mood_PostMood: {
            [MoodManager postMood:param success:success failure:failure];
            break;
        }
        case MethodType_Mood_DeleteMood: {
            [MoodManager deleteMood:param success:success failure:failure];
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
        case MethodType_Mood_PostMood: {
            [MoodManager postMood:param success:success failure:failure];
            break;
        }
        case MethodType_Mood_DeleteMood: {
            [MoodManager deleteMood:param success:success failure:failure];
            break;
        }
    }
}

+ (void)getMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getMood:param success:^(id JSON) {
        NSMutableArray *data = [NSMutableArray array];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[JSON objectForKey:@"result"]];
        for (int i = 0; i < array.count; i ++) {
            MoodDTO *dto = [[MoodDTO alloc] init:[array objectAtIndex:i]];
            dto.isPost = YES;
            [dto updateInfo:[NSNumber numberWithBool:YES] forKey:@"isPost"];
            [[DB shareInstance] selectMoodWithTime:^(NSArray *array) {
                if (array.count > 0) {
                    [[DB shareInstance] updateUserMood:dto];
                } else {
                    [[DB shareInstance] insertUserMood:dto];
                }
            } time:dto.mood_time];
            [data addObject:dto];
        }
        success (data);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)getMoodFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectMoodResult:^(NSArray *array) {
        success(array);
    }];
}

+ (void)postMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices postMood:param success:^(id JSON) {
        MoodDTO *dto = [[MoodDTO alloc] init:[JSON objectForKey:@"result"]];
        dto.isPost = YES;
        [[DB shareInstance] selectMoodWithID:^(NSArray *array) {
            if (array.count > 0) {
                [[DB shareInstance] updateUserMood:dto];
            } else {
                [[DB shareInstance] insertUserMood:dto];
            }
        } dto:dto];
        success (dto);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)deleteMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices deleteMood:param success:^(id JSON) {
        
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)getMoodStatistics:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices getMoodStatistics:param success:^(id JSON) {
        
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)uploadMoodDate
{
    [[DB shareInstance] selectMoodWithNotPost:^(NSArray *array) {
        for (int i = 0; i < array.count; i ++) {
            MoodDTO *dto = [array objectAtIndex:i];
            if (!dto.isPost) {
                if (dto.emotion==0 && dto.actions.count==0 && dto.mood_content.length==0 && dto.images.count==0) {
                    if (dto.mood_id.length < 2 ) {
                        [[DB shareInstance] deleteUserMoodWithTime:dto];
                    } else {
                        [IServices deleteMood:@{@"mood_id":dto.mood_id} success:^(id JSON) {
                            
                            if ([[JSON objectForKey:@"success"] boolValue]) {
                                [[DB shareInstance] deleteUserMood:dto];
                            }
                        } failure:^(NSError *error, id JSON) {
                            
                        }];
                    }
                } else {
                    NSString *time = [DateUtil convertToDay:dto.mood_time];
                    [IServices postMood:@{@"actions":dto.actions,@"emotion":[NSNumber numberWithInteger:dto.emotion],@"surgery_count":[NSNumber numberWithInteger:dto.surgery_count],@"patient_count":[NSNumber numberWithInteger:dto.patient_count],@"images":dto.images,@"content":dto.mood_content,@"mood_time":[NSString stringWithFormat:@"%@ 00:00:00",time]} success:^(id JSON) {
                        
                        
                        MoodDTO *mdto = [[MoodDTO alloc] init:[JSON objectForKey:@"result"]];
                        mdto.isPost = YES;
                        [mdto updateInfo:[NSNumber numberWithBool:YES] forKey:@"isPost"];
                        [[DB shareInstance] updateUserMood:mdto];
                        
                    } failure:^(NSError *error, id JSON) {
                        
                    }];
                }
            }
        }
    }];
}

@end
