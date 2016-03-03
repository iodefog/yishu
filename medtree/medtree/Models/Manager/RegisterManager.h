//
//  RegisterManager.h
//  medtree
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ServiceManager.h"
#import "DataManager.h"

typedef enum {
    MethodType_Register_Start           = 3000,
    /*注册*/
    MethodType_Register_PhoneOrEmail    = 3001,
    MethodType_Register_VerifyPhone     = 3002,
    MethodType_Register_VerifyEmail     = 3003,
    MethodType_Register_Register        = 3004,
    MethodType_Register_ResetPassword   = 3005,
    MethodType_Register_PassResetCode   = 3006,
    MethodType_Register_RegisterAccount = 3007,
    MethodType_Register_RegisterExperience = 3008,
    
    MethodType_Register_End             = 3999,
} MethodType_Register;

@interface RegisterManager : DataManager

+ (void)verifyPhoneOrEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)verificationCodeWithPhone:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)verificationCodeWithEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)userRegister:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)passwordResetCode:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)resetPassword:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)registerAccount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)registerExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
