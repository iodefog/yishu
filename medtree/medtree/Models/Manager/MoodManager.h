//
//  MoodManager.h
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceManager.h"
#import "DataManager.h"

typedef enum {
        MethodType_Mood_Start               = 4000,
        MethodType_Mood_GetMood             = 4001,
        MethodType_Mood_PostMood            = 4002,
        MethodType_Mood_GetMoodLocal        = 4003,
        MethodType_Mood_DeleteMood          = 4004,
        MethodType_Mood_GetMoodStatistics   = 4005,
        MethodType_Mood_End                 = 4999,
} MethodType_Mood;

@interface MoodManager : DataManager

+ (void)getMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getMoodFromLocal:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)uploadMoodDate;
+ (void)getMoodStatistics:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
