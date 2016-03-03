//
//  StatisticManager.h
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceManager.h"

@class ActionDTO;

@interface StatisticManager : ServiceManager

+ (void)getStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)addAction:(ActionDTO *)dto;

@end
