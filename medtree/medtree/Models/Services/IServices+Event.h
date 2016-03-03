//
//  IServices+Event.h
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServices.h"
#import "DataManager.h"

@interface IServices (Event)

+ (void)getEventList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getRecommendEvent:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getEventByID:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
