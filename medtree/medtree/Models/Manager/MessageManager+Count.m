//
//  MessageManager+Count.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageManager+Count.h"
#import "JSONKit.h"
#import "UserManager.h"
#import "MessageDTO.h"
#import "NewCountDTO.h"
#import "DateUtil.h"

NSString *const kNotifyMessage = @"NotifyMessage";
NSString *const kMatchNewFriend = @"kMatchNewFriend";
NSString *const kNotifyJob = @"kNotifyJob";
NSString *const kNotifyNewJob = @"kNotifyNewJob";

@implementation MessageManager (Count)

+ (void)getNewCountList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectAllNewCounts:^(NSArray *array) {
        success(array);
    }];
}

+ (void)addNewCount:(NewCountDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSArray *keys = [[DB shareInstance] selectNewCountIDs];
    if ([keys containsObject:dto.key]) {
        [[DB shareInstance] updateNewCount:dto];
    } else {
        [[DB shareInstance] insertNewCount:dto];
    }
}

+ (void)markNewCountAsRead:(NSString *)key
{
    [[DB shareInstance] clearNotifyCount:key];
}

+ (void)getNewCountByKey:(NSString *)key success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] getNewCountByKey:key success:success];
}

+ (NSInteger)getAllNotifyCount
{
    return [[DB shareInstance] getAllNotifyCount];
}

@end
