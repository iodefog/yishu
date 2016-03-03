//
//  RegisterManager.m
//  medtree
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "RegisterManager.h"
#import "commonHelper.h"

@implementation RegisterManager

//
+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_Register_Start && method < MethodType_Register_End) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_Register_PhoneOrEmail: {
            [RegisterManager verifyPhoneOrEmail:param success:success failure:failure];
            break;
        }
        case MethodType_Register_VerifyPhone: {
            [RegisterManager verificationCodeWithPhone:param success:success failure:failure];
            break;
        }
        case MethodType_Register_VerifyEmail: {
            [RegisterManager verificationCodeWithEmail:param success:success failure:failure];
            break;
        }
        case MethodType_Register_Register: {
            [RegisterManager userRegister:param success:success failure:failure];
            break;
        }
        case MethodType_Register_PassResetCode: {
            [RegisterManager passwordResetCode:param success:success failure:failure];
            break;
        }
        case MethodType_Register_ResetPassword: {
            [RegisterManager resetPassword:param success:success failure:failure];
            break;
        }
        case MethodType_Register_RegisterAccount: {
            [RegisterManager registerAccount:param success:success failure:failure];
            break;
        }
        case MethodType_Register_RegisterExperience: {
            [RegisterManager registerExperience:param success:success failure:failure];
            break;
        }
    }
}

+ (void)verifyPhoneOrEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices verifyPhoneOrEmail:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)verificationCodeWithPhone:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices verificationCodeWithPhone:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)verificationCodeWithEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices verificationCodeWithEmail:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)userRegister:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices userRegister:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)passwordResetCode:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices passwordResetCode:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)resetPassword:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices resetPassword:param success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        failure(error,JSON);
    }];
}

+ (void)registerAccount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices registerAccount:param success:success failure:failure];
}

+ (void)registerExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices registerExperience:param success:success failure:failure];
}

@end
