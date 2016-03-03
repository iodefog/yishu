//
//  IServices+Register.h
//  medtree
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices.h"

@interface IServices (Register)

+ (void)verifyPhoneOrEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)verificationCodeWithPhone:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)verificationCodeWithEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)userRegister:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)passwordResetCode:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)resetPassword:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)registerAccount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)registerExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
