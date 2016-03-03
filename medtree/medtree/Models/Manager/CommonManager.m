//
//  CommonManager.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "CommonManager.h"
#import "DTOBase.h"
#import "DB+Public.h"
#import "IServices+Public.h"
#import "PhotoHelper.h"
#import "FileUtil.h"
#import "UIImageView+setImageWithURL.h"
#import "MedGlobal.h"

@implementation CommonManager

//
+ (BOOL)isHit:(NSInteger)method
{
    if (method > MethodType_CommonInfo_Start && method < MethodType_CommonInfo_End) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
 
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_CommonInfo_Degree: {
            [CommonManager getCommonInfo:param success:success failure:failure];
            break;
        }
    }
}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    switch (method) {
        case MethodType_CommonInfo_Degree: {
            [CommonManager setCommonInfo:param success:success failure:failure];
            break;
        }
    }

}

+ (void)getCommonInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = [param objectForKey:@"key"];
    [[DB shareInstance] selectCommon:key result:^(NSArray *array) {
        success(array);
    }];
}

+ (void)setCommonInfo:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = [param objectForKey:@"key"];
    DTOBase *info = [param objectForKey:@"info"];
    [[DB shareInstance] selectCommon:key result:^(NSArray *array) {
        dispatch_async([MedGlobal getDbQueue], ^{
            if (array.count > 0) {
                [[DB shareInstance] updateCommon:info key:key];
            } else {
                [[DB shareInstance] insertCommon:info key:key];
            }
        });
    }];
}

+ (void)checkUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices checkVersion:param success:success failure:failure];
    }
}

+ (void)checkConfigUpdate:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices checkConfigUpdate:param success:^(id JSON) {
            NSDictionary *result = [JSON objectForKey:@"result"];
            NSString *image_url_prefix = [result objectForKey:@"image_url_prefix"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[result objectForKey:@"splash_image"]];
            if (image_url_prefix) {
                [MedGlobal setPicHost:image_url_prefix];
            }
            if (array.count > 0) {
                for (int i = 0; i < array.count; i ++) {
                    [PhotoHelper getPhoto:[array objectAtIndex:i] completionHandler:^(NSDictionary *dict) {
                        NSString *path = nil;
                        NSFileManager *fm = [NSFileManager defaultManager];
                        NSString *name = [NSString stringWithFormat:@"app_splash%d.png",i];
                        path = [[FileUtil getAdPath] stringByAppendingPathComponent:name];
                        if ([fm fileExistsAtPath:path]) {
                            [fm removeItemAtPath:path error:nil];
                        }
                        [fm createFileAtPath:path contents:UIImageJPEGRepresentation([dict objectForKey:@"fetchedImage"], 1) attributes:nil];
                    } errorHandler:^(NSDictionary *dict) {
                        
                    } progressHandler:^(NSDictionary *dict) {
                        
                    }];
                }
                [MedGlobal setSplashImages:array];
            } else {
                [MedGlobal setSplashImages:[NSArray array]];
            }
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

+ (void)updateAPNS:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    if ([MedGlobal checkNetworkStatus]) {
        [IServices updateAPNS:param success:success failure:failure];
    }
}

+ (void)getIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = @"im_iplist";
    [[DB shareInstance] selectCommon:key result:^(NSArray *array) {
        BOOL isExist = NO;
        if (array.count > 0) {
            isExist = YES;
        }
        if (isExist) {
            if (array.count > 0) {
                success([array objectAtIndex:0]);
            } else {
                dispatch_async([MedGlobal getNetQueue], ^{
                    if ([MedGlobal checkNetworkStatus]) {
                        [IServices getIpList:param success:^(id JSON) {
                            //
                            DTOBase *info = [[DTOBase alloc] init:JSON];
                            [[DB shareInstance] updateCommon:info key:key];
                            //
                            success(JSON);
                        } failure:failure];
                    }
                });
            }
        } else {
            dispatch_async([MedGlobal getNetQueue], ^{
                if ([MedGlobal checkNetworkStatus]) {
                    [IServices getIpList:param success:^(id JSON) {
                        //
                        DTOBase *info = [[DTOBase alloc] init:JSON];
                        [[DB shareInstance] insertCommon:info key:key];
                        //
                        success(JSON);
                    } failure:failure];
                }
            });
        }
    }];
}

+ (void)deleteIp:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = @"im_iplist";
    [[DB shareInstance] deleteCommon:key];
    success(nil);
}

+ (void)setIpList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSString *key = @"im_iplist";
    DTOBase *info = [[DTOBase alloc] init:param];
    //
    [[DB shareInstance] selectCommon:key result:^(NSArray *array) {
        dispatch_async([MedGlobal getDbQueue], ^{
            if (array.count > 0) {
                [[DB shareInstance] updateCommon:info key:key];
            } else {
                [[DB shareInstance] insertCommon:info key:key];
            }
        });
    }];
}

+ (void)appEventCollect:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [IServices appEventCollect:param success:success failure:failure];
}

@end
