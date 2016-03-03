//
//  ServiceManager.m
//  zhihu
//
//  Created by lyuan on 14-3-10.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "ServiceManager.h"
#import "UserManager.h"
#import "MessageManager.h"
#import "MessageManager+Count.h"
#import "EventManager.h"
#import "FeedManager.h"
#import "DegreeManager.h"
#import "CommonManager.h"
#import "DB+Public.h"
#import "RegisterManager.h"
#import "MoodManager.h"
#import "TopicManager.h"
#import "ForumManager.h"

@implementation ServiceManager

+ (ServiceManager *)shareInstance
{
    static ServiceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ServiceManager alloc] init];
        instance->dataDict = [[NSMutableDictionary alloc] init];
    });
    return instance;
}

- (void)setObject:(id)json key:(NSString *)key
{
    if ((NSObject *)json != [NSNull null] && json != nil) {
        [dataDict setObject:json forKey:key];
    }
}

- (id)getObject:(NSString *)key
{
    return [dataDict objectForKey:key];
}

+ (void)setObject:(id)json key:(NSString *)key
{
    [[ServiceManager shareInstance] setObject:json key:key];
}

+ (id)getObject:(NSString *)key
{
    return [[ServiceManager shareInstance] getObject:key];
}

+ (void)getData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    
    if ([UserManager isHit:method]) {
        [UserManager getData:dict success:success failure:failure];
    } else if ([MoodManager isHit:method]) {
        
        [MoodManager getData:dict success:success failure:failure];
    } else if ([RegisterManager isHit:method]) {
        
        [RegisterManager getData:dict success:success failure:failure];
    } else if ([EventManager isHit:method]) {
        
        [EventManager getData:dict success:success failure:failure];
    } else if ([FeedManager isHit:method]) {
        
        [FeedManager getData:dict success:success failure:failure];
    } else if ([DegreeManager isHit:method]) {
        
        [DegreeManager getData:dict success:success failure:failure];
    } else if ([CommonManager isHit:method]) {
        
        [CommonManager getData:dict success:success failure:failure];
    } else if ([MessageManager isHit:method]) {
        
        [MessageManager getData:dict success:success failure:failure];
    }
    

}

+ (void)setData:(NSDictionary *)dict success:(SuccessBlock)success failure:(FailureBlock)failure
{
    int method = [[dict objectForKey:@"method"] intValue];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dict];
    [param removeObjectForKey:@"method"];
    
    
    if ([UserManager isHit:method]) {
        [UserManager setData:dict success:success failure:failure];
    } else if ([MoodManager isHit:method]) {
        
        [MoodManager setData:dict success:success failure:failure];
    } else if ([RegisterManager isHit:method]) {
        
        [RegisterManager setData:dict success:success failure:failure];
    } else if ([EventManager isHit:method]) {
        
        [EventManager setData:dict success:success failure:failure];
    } else if ([FeedManager isHit:method]) {
        
        [FeedManager setData:dict success:success failure:failure];
    } else if ([DegreeManager isHit:method]) {
        
        [DegreeManager setData:dict success:success failure:failure];
    } else if ([CommonManager isHit:method]) {
        
        [CommonManager setData:dict success:success failure:failure];
    } else if ([MessageManager isHit:method]) {
        
        [MessageManager setData:dict success:success failure:failure];
    }
}


+ (void)loadCacheData
{
    [UserManager loadCacheData];
    [MessageManager loadCacheData];
    [ForumManager loadCacheData];
}

@end
