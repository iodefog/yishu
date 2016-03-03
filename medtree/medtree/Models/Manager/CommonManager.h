//
//  CommonManager.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DataManager.h"

typedef enum {
    MethodType_CommonInfo_Start         = 600,
    MethodType_CommonInfo_Degree        = 601,
    MethodType_CommonInfo_ContactIDs    = 602,
    MethodType_CommonInfo_MatchContact  = 603,
    
    MethodType_CommonInfo_End           = 699,
} MethodType_CommonInfo;

@class DTOBase;

@interface CommonManager : DataManager

+ (void)getCommonInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)setCommonInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)checkUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)checkConfigUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)updateAPNS:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)setIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)deleteIp:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)appEventCollect:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
