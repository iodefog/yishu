
//
//  UnitLevelType.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "UnitLevelType.h"

@implementation UnitLevelType

+ (NSString *)getLabel:(UnitLevelTypes)type
{
    NSString *label = [UnitLevelType dict][@(type)];
    return label ? label : @"";
}

+ (UnitLevelTypes)getInteger:(NSString *)title
{
    __block UnitLevelTypes type = UnitLevelTypesAll;
    [[UnitLevelType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (UnitLevelTypes)[key integerValue];
            *stop = true;
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(UnitLevelTypesAll) : @"不限",
             @(UnitLevelTypesHighest) : @"三级甲等",
             @(UnitLevelTypesHigher) : @"三级乙等",
             @(UnitLevelTypesHigh) : @"二级甲等",
             @(UnitLevelTypesLow) : @"二级二等",
             @(UnitLevelTypesLower) : @"一级",
             @(UnitLevelTypesOther) : @"其他"
             };
}

@end
