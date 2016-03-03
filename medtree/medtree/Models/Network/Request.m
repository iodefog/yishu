//
//  Request.m
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "Request.h"
#import "MedGlobal.h"
#import "Request+Error.h"
#import "CommonHelper.h"
#import "DB+Global.h"
#import "JSONKit.h"

@implementation Request

- (MKNetworkEngine *)getEngine:(NSInteger)type
{
    if (type == 0) {
        static MKNetworkEngine *engine = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableDictionary *header = [NSMutableDictionary dictionary];
            engine = [[MKNetworkEngine alloc] initWithHostName:[MedGlobal getHost0] apiPath:@"" customHeaderFields:header];
        });
        return engine;
    } else if (type == 1) {
            static MKNetworkEngine *engine = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSMutableDictionary *header = [NSMutableDictionary dictionary];
                engine = [[MKNetworkEngine alloc] initWithHostName:[MedGlobal getHost] apiPath:@"v2" customHeaderFields:header];
            });
            return engine;
    } else {
        return nil;
    }
}

- (MKNetworkOperation *)returnFailure:(void (^)(NSError *error, id JSON))failure
{
    MKNetworkOperation *op = [[self getEngine:1] operationWithPath:@"" params:nil httpMethod:@"" ssl:[self getSSLEnable]];
    failure(nil,@{@"message":@"未获取到数据",@"success":@"false"});
    return op;
}

- (MKNetworkOperation *)requestAction:(NSString *)action
                               method:(NSString *)method
                               params:(NSDictionary *)params
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error, id JSON))failure
{
    if ([CommonHelper isHaveHanZi:action]) {
        return [self returnFailure:failure];
    } else {
        return [self requestAction:action method:method params:params version:1 success:success failure:failure];
    }
}

- (BOOL)getSSLEnable
{
    return [[MedGlobal getHost] isEqualToString:@"api.medtree.cn"];
}

- (MKNetworkOperation *)requestAction:(NSString *)action
                               method:(NSString *)method
                               params:(NSDictionary *)params
                              version:(NSInteger)version
                              success:(void (^)(id JSON))success
                              failure:(void (^)(NSError *error, id JSON))failure
{
    MKNetworkOperation *op = [[self getEngine:version] operationWithPath:action params:nil httpMethod:method ssl:YES];
    if ([action isEqualToString:@"diagnose/exception"] == NO && [method isEqualToString:@"DELETE"] == NO) {
        [op setPostDataEncoding:MKNKPostDataEncodingTypeJSON];
    }
    [op addHeaders:[Request getHeader]];
    [op addParams:params];
    //
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[completedOperation responseJSON]];
        [dict setObject:action forKey:@"action"];
        success(dict);
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        if ([errorOp responseString].length > 0) {
            [self checkError:[errorOp responseString] action:action error:error failure:^(NSError *error, id JSON) {
                failure(error, JSON);
            }];
        } else {
            failure(error,nil);
        }
    }];
    [op onDownloadProgressChanged:^(double progress) {
        NSLog(@"action:%@    %f",action,progress);
    }];
    [[self getEngine:version] enqueueOperation:op];
    return op;
}

+ (NSMutableDictionary *)getHeader
{
    static NSMutableDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [[NSMutableDictionary alloc] init];
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
        [dict setObject:[NSString stringWithFormat:@"%@ %@",version,@(revision)] forKey:@"X-CLIENT-VER"];
    });
    return dict;
}

+ (void)setHeader:(NSDictionary *)dict
{
    [[Request getHeader] setObject:[dict objectForKey:@"token"] forKey:@"X-AUTH-TOKEN"];
    [[Request getHeader] setObject:[dict objectForKey:@"client"] forKey:@"X-CLIENT-ID"];
    [[Request getHeader] setObject:[dict objectForKey:@"device"] forKey:@"X-DEVICE-ID"];
}

@end
