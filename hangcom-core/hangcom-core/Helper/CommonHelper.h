//
//  CommonHelper.h
//  hangcom-core
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject

//是否是纯数字
+ (BOOL)isNumberText:(NSString *)str;
+ (BOOL)isPhone:(NSString *)text;
//是否是邮箱
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)isHaveHanZi:(NSString *)hanzi;
+ (NSString *)getDateWithStringToMonth:(NSString *)time;
+ (NSString *)getDateWithStringToDay:(NSString *)time;
@end
