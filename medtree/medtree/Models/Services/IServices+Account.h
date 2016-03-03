//
//  IServices+Account.h
//
//  Created by lyuan on 14-4-2.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServices.h"
#import "DataManager.h"

@interface IServices (Account)

+ (void)login:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)logout:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)reg:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 3.5 注册全部信息 手机注册 */
+ (void)registerAllInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
