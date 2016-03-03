//
//  IServices+Register.m
//  medtree
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "IServices+Register.h"

@implementation IServices (Register)

+ (void)verifyPhoneOrEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/_verify" method:@"POST" params:param success:success failure:failure];
}

+ (void)verificationCodeWithPhone:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/_send_verify_sms" method:@"POST" params:param success:success failure:failure];
}

+ (void)verificationCodeWithEmail:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/_verify_email" method:@"POST" params:param success:success failure:failure];
}

+ (void)userRegister:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register" method:@"POST" params:param success:success failure:failure];
}

+ (void)passwordResetCode:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/_send_password_reset_code" method:@"POST" params:param success:success failure:failure];
}

+ (void)resetPassword:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/_reset_password" method:@"POST" params:param success:success failure:failure];
}

+ (void)registerAccount:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/account" method:@"POST" params:param success:success failure:failure];
}

+ (void)registerExperience:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    Request *request = [[Request alloc] init];
    [request requestAction:@"user/register/experience" method:@"POST" params:param success:success failure:failure];
}

@end
