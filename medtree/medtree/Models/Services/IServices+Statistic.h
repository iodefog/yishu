//
//  IServices+Statistic.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Statistic)

+ (void)sendStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 轮询获取未读消息 */
+ (void)sendUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 主动获取未读消息数 */
+ (void)readUnReadMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
