//
//  AccountHelper.h
//  zhcolors
//
//  Created by lyuan on 14-2-21.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@class UserDTO;
@class SignDTO;

@interface AccountHelper : NSObject
{
    UserDTO     *userDTO;
    SignDTO     *signDTO;
}

+ (UserDTO *)getAccount;
+ (void)setLoginState:(BOOL)loginState;
+ (BOOL)getLoginState;
+ (void)setAccount:(UserDTO *)dto;
//
+ (void)cleanAccount;
+ (void)cleanToken;
+ (void)syncAccount:(UserDTO *)dto token:(NSString *)token;

+ (void)tryToLoginByToken:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)tryToLogin:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)tryToLogout:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)getUser_Access_token:(SuccessBlock)success;
+ (void)getUser_Access_tokenWithService:(SuccessBlock)success;

+ (void)getUser_Im_password:(SuccessBlock)success;

+ (void)getSignInfo:(SuccessBlock)success;
+ (SignDTO *)getSign;
+ (void)getUserSignInfoWithService:(SuccessBlock)success;
+ (void)setSignInfo:(SignDTO *)dto;

+ (void)deleteDevice:(NSString *)userID success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)registerDevice;
+ (void)getUserInfo;

/** 3.5版本注册 */
+ (void)tryToVeryfyInformation:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)tryToRegisterAll:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 更换网络引擎 */
+ (void)tryToChangeEngineSuccess:(SuccessBlock)success failure:(FailureBlock)failure;

@end
