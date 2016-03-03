//
//  SalaryType.m
//  medtree
//
//  Created by 孙晨辉 on 15/12/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "SalaryType.h"

@implementation SalaryType

+ (NSString *)getLabel:(SalaryTypes)type
{
    NSString *label = [SalaryType dict][@(type)];
    return label ? label : @"";
}

+ (SalaryTypes)getInteger:(NSString *)title
{
    __block SalaryTypes type = SalaryTypesAll;
    [[SalaryType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (SalaryTypes)[key integerValue];
            *stop = true;
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(SalaryTypesAll):@"不限",
             @(SalaryTypesLow):@"2k-4k",
             @(SalaryTypesMiddle):@"4k-6k",
             @(SalaryTypesHigh):@"6k-10k",
             @(SalaryTypesHigher):@"10k-20k",
             @(SalaryTypesHighest):@"20k以上",
             @(SalaryTypesOther):@"面议"
             };
}

@end
