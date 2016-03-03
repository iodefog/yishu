//
//  IServices+Version.h
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Version)

+ (void)checkVersion:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)checkConfigUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)updateAPNS:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
