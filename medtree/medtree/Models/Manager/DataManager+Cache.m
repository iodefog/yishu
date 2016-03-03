//
//  DataManager+Cache.m
//  medtree
//
//  Created by tangshimi on 5/26/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DataManager+Cache.h"
#import "DB+Global.h"
#import "NSDictionary+RequestEncoding.h"
#import "AccountHelper.h"
#import "UserDTO.h"

@implementation DataManager (Cache)

+ (void)cache:(NSDictionary *)param data:(id)json
{
    NSString *url = [DataManager cacheURL:param];
    if (url) {
        [[DB shareInstance] cacheWithURL:url data:json];
    }
}

+ (id)redaCache:(NSDictionary *)param
{
    NSString *url = [DataManager cacheURL:param];
    if (url) {
        return [[DB shareInstance] readCacheWithURL:url];
    }
    
    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - helper -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)cacheURL:(NSDictionary *)param
{
    if (![AccountHelper getAccount]) {
        return nil;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:param];
    [dic setObject:@"userID" forKey:[AccountHelper getAccount].userID];
    
    if (param && [param objectForKey:@"from"] != [NSNull null]) {
        if ([param[@"from"] integerValue] == 0) {
            return [dic jsonEncodedKeyValueString];
        } else {
            return nil;
        }
    } else {
        return [dic jsonEncodedKeyValueString];
    }
    
    return nil;
}

@end
