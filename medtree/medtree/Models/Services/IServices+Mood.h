//
//  IServices+Mood.h
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Mood)

+ (void)getMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)postMood:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getMoodStatistics:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
