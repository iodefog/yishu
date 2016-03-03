//
//  AccountHelper.m
//  zhcolors
//
//  Created by lyuan on 14-2-21.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "AccountHelper.h"
#import "UserDTO.h"
#import "Keychain.h"
#import "Request.h"
#import "ServiceManager+Public.h"
#import "EncodeUtil.h"
#import "DB+Public.h"
#import "OpenUDID.h"
#import "DateUtil.h"
#import "SignDTO.h"
#import "JSONKit.h"

@interface AccountHelper()

/** 保存是否已登录 */
@property (nonatomic, assign, getter=isLogin) BOOL loginState;

@end

@implementation AccountHelper

+ (AccountHelper *)shareInstance
{
    static AccountHelper *instance = nil;
    if (instance == nil) {
        instance = [[AccountHelper alloc] init];
    }
    return instance;
}

- (void)setAccount:(UserDTO *)dto
{
    userDTO = dto;
}

- (UserDTO *)getAccount
{
    return userDTO;
}

+ (UserDTO *)getAccount
{
    return [[AccountHelper shareInstance] getAccount];
}

+ (void)setAccount:(UserDTO *)dto
{
    [[AccountHelper shareInstance] setAccount:dto];
}

+ (void)cleanAccount
{
    [AccountHelper syncAccount:nil token:@""];
}

+ (void)cleanToken
{
    [Keychain setValue:@"" key:@"token"];
}

+ (void)syncAccount:(UserDTO *)dto token:(NSString *)token
{
    if (dto.userID != nil) {
        [Keychain setValue:dto.userID key:@"userid"];
    }
    if (dto.chatID != nil) {
        [Keychain setValue:dto.chatID key:@"chatid"];
    }
    if (token != nil) {
        [Keychain setValue:token key:@"token"];
    }
}

+ (void)setLoginState:(BOOL)loginState
{
    [[AccountHelper shareInstance] setLoginState:loginState];
}

+ (BOOL)getLoginState
{
    return [[AccountHelper shareInstance] isLogin];
}

+ (void)deleteDevice:(NSString *)userID success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
    
    NSString *device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    BOOL inHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    NSInteger push_channel = 8;
#if DEBUG
    push_channel = inHouse ? 2 : 4;
#else
    push_channel = inHouse ? 1 : 3;
#endif
    if (device_token.length > 10) {
        NSDictionary *sdict = @{@"push_channel": [NSNumber numberWithInteger:push_channel],@"token": device_token.length>0?device_token:@"", @"user_id": userID, @"client": [NSNumber numberWithInteger:1],@"method":[NSNumber numberWithInteger:MethodType_User_DeleteDevice],@"version":[NSString stringWithFormat:@"%@ %zi",version,revision]};
        
        [ServiceManager setData:sdict success:^(id JSON) {
            
            success (JSON);
        } failure:^(NSError *error, id JSON) {
            failure (error, JSON);;
        }];
    } else {
        success(@{@"success":[NSNumber numberWithBool:YES]});
    }
}

+ (void)registerDevice
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
    
    NSString *device_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
    
    BOOL inHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    NSInteger push_channel = 8;
#if DEBUG
    push_channel = inHouse ? 2 : 4;
#else
    push_channel = inHouse ? 1 : 3;
#endif
    if (device_token.length > 10) {
        NSDictionary *sdict = @{@"push_channel": [NSNumber numberWithInteger:push_channel],@"token": device_token.length>0?device_token:@"", @"client": [NSNumber numberWithInteger:1],@"method":[NSNumber numberWithInteger:MethodType_User_RegisterDevice],@"version":[NSString stringWithFormat:@"%@ %zi",version,revision]};
        
        [ServiceManager setData:sdict success:^(id JSON) {
            
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

+ (void)tryToLoginByToken:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *token = [userInfo objectForKey:@"token"];
    NSString *userid = [userInfo objectForKey:@"userid"];
    if (token != nil && userid != nil && ![token isEqualToString:@""] && ![userid isEqualToString:@""]) {
        NSDictionary *dict = @{@"token": token, @"device": [OpenUDID value], @"client": @"iOS"};
        [Request setHeader:dict];
        //
        [AccountHelper loadUserCache:userid];
        [[AccountHelper shareInstance] setLoginState:YES];
        [AccountHelper registerDevice];
        //
        NSDictionary *param = @{@"userid": userid, @"method": [NSNumber numberWithInteger:MethodType_UserInfo_Local]};
        [ServiceManager getData:param success:^(id JSON) {
            UserDTO *dto = (UserDTO *)JSON;
            if (dto != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AccountHelper setAccount:dto];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
                    success(@{@"token": token, @"user": dto});
                });
              
            } else {
                success(nil);
            }
            //
            NSDictionary *param = @{@"token": token, @"loadCache": @NO};
            [AccountHelper checkUserInfo:param success:nil failure:nil];
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

+ (void)tryToLogin:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *password = [userInfo objectForKey:@"password"];
    NSString *username = [userInfo objectForKey:@"username"];
    if (username != nil && password != nil && ![username isEqualToString:@""] && ![password isEqualToString:@""]) {
        password = [EncodeUtil getMD5ForStr:password];
        NSDictionary *param = @{@"username": username, @"password": password, @"method": [NSNumber numberWithInteger:MethodType_UserLogin]};
        [ServiceManager getData:param success:^(id JSON) {
            BOOL tf = [[JSON objectForKey:@"success"] boolValue];
            if (tf) {
                
                NSString *token = [JSON objectForKey:@"token"];
                //
                NSDictionary *dict = @{@"token": token, @"device": [OpenUDID value], @"client": @"iOS"};
                [Request setHeader:dict];
                //
                UserDTO *dto = [[UserDTO alloc] init:JSON];
                [AccountHelper setAccount:dto];
                [AccountHelper syncAccount:dto token:token];
                
                [[AccountHelper shareInstance] setLoginState:YES];
                [AccountHelper registerDevice];
                
                //
                NSDictionary *param = @{@"token": token, @"loadCache": @YES};
                [AccountHelper checkUserInfo:param success:^(id JSON) {
                    success(@{@"token": token, @"user": JSON,@"success":[NSNumber numberWithBool:YES]});
                } failure:^(NSError *error, id JSON) {
                    success(@{@"success":[NSNumber numberWithBool:YES]});
                }];
                //
            } else {
                success(JSON);
            }
        } failure:^(NSError *error, id JSON) {
            failure(error, JSON?[JSON objectFromJSONString]:@{@"message":@"当前网络不好，请稍后重试"});
        }];
    } else {
        failure(nil, userInfo);
    }
}

+ (void)tryToLogout:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [Keychain setValue:@"" key:@"token"];
    
    success(nil);
}

+ (void)tryToChangeEngineSuccess:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *param = @{@"method":[NSNumber numberWithInteger:MethodType_Logout]};
    [ServiceManager getData:param success:^(id JSON) {
        if (success) {
            success(nil);
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)tryToVeryfyInformation:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [ServiceManager setData:userInfo success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id JSON) {
        
    }];
}

/** 注册 */
+ (void)tryToRegisterAll:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [ServiceManager setData:userInfo success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            
            NSString *token = nil;
            if (JSON[@"token"]) {
                token = [JSON objectForKey:@"token"];
                //
                NSDictionary *dict = @{@"token": token, @"device": [OpenUDID value], @"client": @"iOS"};
                [Request setHeader:dict];
            }
            
            //
            UserDTO *dto = [[UserDTO alloc] init:JSON];
            [AccountHelper setAccount:dto];
            [AccountHelper syncAccount:dto token:token];
            
            [[AccountHelper shareInstance] setLoginState:YES];
            [AccountHelper registerDevice];
            
            //
            NSDictionary *param = @{@"token": token, @"loadCache": @YES};
            [AccountHelper checkUserInfo:param success:^(id JSON) {
                success(@{@"token":token, @"user": JSON, @"success":[NSNumber numberWithBool:YES]});
            } failure:^(NSError *error, id JSON) {
                success(JSON);
            }];
        } else {
            success(JSON);
        }
    } failure:^(NSError *error, id JSON) {
        failure(error, JSON);
    }];
}

+ (void)loadUserCache:(NSString *)userid
{
    // load db
    [DB shareWithName:[NSString stringWithFormat:@"%@.db", userid]];
    [ServiceManager loadCacheData];
    //
}

+ (void)checkUserInfo:(NSDictionary *)userInfo success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *token = [userInfo objectForKey:@"token"];
    BOOL isLoadCache = [[userInfo objectForKey:@"loadCache"] boolValue];
    NSDictionary *param = @{@"userid": @"mine", @"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
    //
    [ServiceManager getData:param success:^(id JSON) {
        UserDTO *dto = (UserDTO *)JSON;
        [AccountHelper setAccount:dto];
        [AccountHelper syncAccount:dto token:token];
        //
        if (isLoadCache) {
            [AccountHelper loadUserCache:dto.userID];
        }
        if (success != nil) {
            success(dto);
        }
        //
        NSDictionary *param = @{@"info": dto, @"method": [NSNumber numberWithInteger:MethodType_UserInfo_Update_Local]};
        [ServiceManager setData:param success:^(id JSON) {
            
        } failure:^(NSError *error, id JSON) {
//            failure(error,JSON);
        }];
    } failure:^(NSError *error, id JSON) {
//        failure(error,JSON);
    }];
}

+ (NSMutableDictionary *)getAccess_token
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    return dict;
}

+ (void)setSplashImages:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"splashImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getSplashImages
{
    NSMutableArray *splashImages = [NSMutableArray array];
    [splashImages addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"splashImages"]];
    return splashImages;
}

+ (void)getUser_Access_token:(SuccessBlock)success
{
    if ([[[AccountHelper getAccess_token] allKeys] count] > 0) {
        if ([[[AccountHelper getAccess_token] objectForKey:@"user_id"] isEqualToString:[[AccountHelper getAccount] userID]]) {
            NSDate *time = [DateUtil convertTimeFromNumber:[[AccountHelper getAccess_token] objectForKey:@"time"]];
            NSNumber *expire = [[AccountHelper getAccess_token] objectForKey:@"expire"];
            if ([[AccountHelper getAccess_token] objectForKey:@"access_token"] == nil) {
                [AccountHelper getUser_Access_tokenWithService:^(id JSON) {
                    success(JSON);
                }];
            } else {
                if (0-[time timeIntervalSinceNow] < [expire integerValue]-600) {
                    success([[AccountHelper getAccess_token] objectForKey:@"access_token"]);
                }else {
                    [AccountHelper getUser_Access_tokenWithService:^(id JSON) {
                        success(JSON);
                    }];
                }
            }
        } else {
            [AccountHelper getUser_Access_tokenWithService:^(id JSON) {
                success(JSON);
            }];
        }
    } else {
        [AccountHelper getUser_Access_tokenWithService:^(id JSON) {
            success(JSON);
        }];
    }
}

+ (void)getUser_Access_tokenWithService:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Account_Token]} success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSDictionary *dict = [JSON objectForKey:@"result"];
            [[AccountHelper getAccess_token] removeAllObjects];
            [[AccountHelper getAccess_token] setObject:[dict objectForKey:@"access_token"] forKey:@"access_token"];
            [[AccountHelper getAccess_token] setObject:[dict objectForKey:@"expire"] forKey:@"expire"];
            [[AccountHelper getAccess_token] setObject:[[AccountHelper getAccount] userID] forKey:@"user_id"];
            [[AccountHelper getAccess_token] setObject:[DateUtil convertNumberFromTime:[NSDate date]] forKey:@"time"];
            success([dict objectForKey:@"access_token"]);
        } else {
            success(@"");
        }
    } failure:^(NSError *error, id JSON) {
        success(@"");
    }];
}

+ (NSMutableDictionary *)getUser_Im_password
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
    }
    return dict;
}

+ (void)getUser_Im_password:(SuccessBlock)success
{
    if ([[AccountHelper getUser_Im_password] allKeys].count > 0) {
        if ([[[AccountHelper getUser_Im_password] objectForKey:@"user_id"] isEqualToString:[[AccountHelper getAccount] userID]]) {
            
            NSDate *time = [DateUtil convertTimeFromNumber:[[AccountHelper getUser_Im_password] objectForKey:@"time"]];
            NSNumber *expire = [[AccountHelper getUser_Im_password] objectForKey:@"expire"];
            
            if ([[AccountHelper getUser_Im_password] objectForKey:@"password"] == nil) {
                [AccountHelper getUser_Im_passwordWithService:^(id JSON) {
                    success(JSON);
                }];
            } else {
                if (0-[time timeIntervalSinceNow] < [expire integerValue]-600) {
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ChangeNewPassword"] boolValue]) {
                        [AccountHelper getUser_Im_passwordWithService:^(id JSON) {
                            success(JSON);
                        }];
                    } else {
                        success([[AccountHelper getUser_Im_password] objectForKey:@"password"]);
                    }
                } else {
                    [AccountHelper getUser_Im_passwordWithService:^(id JSON) {
                        success(JSON);
                    }];
                }
            }
        } else {
            [AccountHelper getUser_Im_passwordWithService:^(id JSON) {
                success(JSON);
            }];
        }
    } else {
        [AccountHelper getUser_Im_passwordWithService:^(id JSON) {
            success(JSON);
        }];
    }
}

+ (void)getUser_Im_passwordWithService:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_IM_Password]} success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSDictionary *dict = [JSON objectForKey:@"result"];
            [[AccountHelper getUser_Im_password] removeAllObjects];
            [[AccountHelper getUser_Im_password] setObject:[dict objectForKey:@"expire"] forKey:@"expire"];
            [[AccountHelper getUser_Im_password] setObject:[dict objectForKey:@"password"] forKey:@"password"];
            [[AccountHelper getUser_Im_password] setObject:[[AccountHelper getAccount] userID] forKey:@"user_id"];
            [[AccountHelper getUser_Im_password] setObject:[DateUtil convertNumberFromTime:[NSDate date]] forKey:@"time"];
            success(dict[@"password"]);
        } else {
            success(@"");
        }
    } failure:^(NSError *error, id JSON) {
        success(@"");
    }];
}

+ (NSString *)getUserSignInfo
{
    return @"";
}

+ (void)getUserSignInfoWithService:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_SignGet]} success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            SignDTO *dto = [[SignDTO alloc] init:[JSON objectForKey:@"result"]];
            [AccountHelper setCheckSignInfo:[JSON objectForKey:@"result"]];
            [AccountHelper setSignInfo:dto];
            success (dto);
            [self cacheBalance:dto.balance];
        } else {
            success(nil);
        }
    } failure:^(NSError *error, id JSON) {
        success(nil);
    }];
}

+ (void)cacheBalance:(NSInteger)balance
{
    NSString *userKey = [NSString stringWithFormat:@"UserBalance%@", [AccountHelper getUserId]];

    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", (long)balance] forKey:userKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getUserId
{
    return [[AccountHelper getAccount] userID];
}

- (void)setSignInfo:(SignDTO *)dto
{
    signDTO = dto;
}

- (SignDTO *)getSignInfo
{
    return signDTO;
}

+ (SignDTO *)getSign
{
    return [[AccountHelper shareInstance] getSignInfo];
}

+ (void)getSignInfo:(SuccessBlock)success
{
    [AccountHelper getCheckSignInfo:^(id JSON) {
        if (JSON) {
            SignDTO *dto = [[SignDTO alloc] init:JSON];
            if ([DateUtil calcDayDiff:dto.todayTime] == 0) {
                if (dto.today_check) {
                    [AccountHelper setSignInfo:dto];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        success (dto);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [AccountHelper getUserSignInfoWithService:^(id JSON) {
                            success (JSON);
                        }];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [AccountHelper getUserSignInfoWithService:^(id JSON) {
                        success (JSON);
                    }];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [AccountHelper getUserSignInfoWithService:^(id JSON) {
                    success (JSON);
                }];
            });
        }
    }];
}

+ (void)setSignInfo:(SignDTO *)dto
{
    [[AccountHelper shareInstance] setSignInfo:dto];
}

+ (void)getCheckSignInfo:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"sign_info"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success ([dataDict objectForKey:@"data"]);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

+ (void)setCheckSignInfo:(NSDictionary *)dict
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"sign_info",@"info":dto} success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

+ (void)getUserInfo
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInteger:MethodType_UserInfo],@"userid":[[AccountHelper getAccount] userID]} success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

@end
