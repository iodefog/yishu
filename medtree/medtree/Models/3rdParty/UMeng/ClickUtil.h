//
//  ClickUtil.h
//  zhihuhd
//
//  Created by 无忧 on 13-11-5.
//  Copyright (c) 2013年 mobimac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobClick.h"

@interface ClickUtil : NSObject

+ (void)setLogEnabled:(BOOL)value;
+ (void)startWithAppkey:(NSString *)appid reportPolicy:(ReportPolicy)reportPolicy channelId:(NSString *)channelId;
+ (void)clickEvent:(NSString *)event;
+ (void)beginEvent:(NSString *)eventId;
+ (void)endEvent:(NSString *)eventId;
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

//+ (void)sendUsage:(NSDictionary *)info success:(void (^)(id JSON))success failure:(void (^)(NSError *error, id JSON))failure;

@end