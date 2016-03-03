//
//  CommonHelper.m
//  hangcom-core
//
//  Created by 无忧 on 14-9-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "CommonHelper.h"
#import "DateUtil.h"

@implementation CommonHelper

//是否是纯数字
+ (BOOL)isNumberText:(NSString *)str
{
    NSString * regex = @"^[0-9]+$";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}

+ (BOOL)isPhone:(NSString *)text
{
//
    NSString * regex = @"1[3|5|7|8|][0-9]{9}";//@"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:text];
    return isMatch;
}

//是否是邮箱
+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isHaveHanZi:(NSString *)hanzi
{
    
    for(int i = 0; i < [hanzi length]; i++) {
        int a = [hanzi characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    }
    return NO;
}

+ (NSString *)getDateWithStringToMonth:(NSString *)time
{
    NSString *timeStr = time;
    
    if ((NSObject *)time != [NSNull null] && time.length > 4) {
        timeStr = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        timeStr = [timeStr substringToIndex:4];
    }
    
    return timeStr;
}

+ (NSString *)getDateWithStringToDay:(NSString *)time
{
    NSString *timeStr = @"";
    
    if ((NSObject *)time != [NSNull null] && time.length > 10) {
        timeStr = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        timeStr = [timeStr substringToIndex:10];
    }
    
    return timeStr;
}

@end
