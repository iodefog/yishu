//
//  DateUtil.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

+ (NSString *)getFormatTime:(NSDate *)date format:(NSString *)format;
+ (NSString *)getFormatTime:(NSDate *)date;
+ (NSDate *)convertTime:(NSString *)time;
+ (NSDate *)convertTime:(NSString *)time formate:(NSString *)format;
+ (NSDate *)convertTimeFromNumber:(NSNumber *)time;
+ (NSDate *)dateFromComponent:(NSDateComponents *)omponent;
+ (NSString *)convertToDay:(NSDate *)date;
+ (NSNumber *)convertNumberFromTime:(NSDate *)time;
+ (NSString *)getMessageTime:(NSDate *)date;
+ (NSString *)getDisplayTime:(NSDate *)date;
+ (NSString *)getYears:(NSDate *)date;
+ (NSString *)getDisplayTime:(NSDate *)date num:(NSInteger)num;
+ (NSDateComponents *)getComponenet:(NSDate *)date;
+ (NSString *)getYear;
+ (NSString *)getMonth:(NSDate *)date;
+ (NSString *)getYearMonthDay:(NSDate *)date;
+ (NSMutableArray *)getMonthArray;
+ (NSDate *)convertDay:(NSString *)time;
+ (NSString *)getYearMonth:(NSDate *)date;
+ (NSMutableArray *)getMonthArrayFrom2014;
+ (NSInteger)getWeekDay:(NSString *)theDay;
+ (NSMutableArray *)getYearArrayFrom2014;
+ (NSMutableArray *)getMonthByYearArrayFrom2014;
+ (NSString *)getYesterday;
+ (NSNumber *)convertNumberFromTime1000:(NSDate *)time;
+ (NSNumber *)convertNumberFromTimeString:(NSString *)time;

+ (BOOL)isToday:(NSDate *)date;
+ (BOOL)isTommorrow:(NSDate *)date;
+ (BOOL)isYesterday:(NSDate *)date;
+ (NSInteger)calcDayDiff:(NSDate *)date;

@end
