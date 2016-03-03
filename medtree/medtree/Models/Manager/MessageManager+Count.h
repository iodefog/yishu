//
//  MessageManager+Count.h
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageManager.h"

@class NewCountDTO;

extern NSString *const kNotifyMessage;
extern NSString *const kMatchNewFriend;
extern NSString *const kNotifyJob;
extern NSString *const kNotifyNewJob;

@interface MessageManager (Count)

+ (void)getNewCountList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)addNewCount:(NewCountDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)markNewCountAsRead:(NSString *)key;
+ (void)getNewCountByKey:(NSString *)key success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (NSInteger)getAllNotifyCount;

@end
