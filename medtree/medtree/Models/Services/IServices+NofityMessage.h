//
//  IServices+NofityMessage.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  获取通知消息

#import "IServices.h"

@interface IServices (NofityMessage)

+ (void)getLastestNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getHistoryNotifyMessage:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getPushJobList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)getRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)putRefuseState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

//获得消息免打扰状态
+ (void)getDisturbState:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
//设置免打扰状态
+ (void)setDisturb:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
