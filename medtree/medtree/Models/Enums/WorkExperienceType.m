//
//  WorkExperienceType.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "WorkExperienceType.h"

@implementation WorkExperienceType

+ (NSString *)getLabel:(WorkExperienceTypes)type
{
    NSString *label = [WorkExperienceType dict][@(type)];
    return label ? label : @"";
}

+ (WorkExperienceTypes)getInteger:(NSString *)title;
{
    __block WorkExperienceTypes type = WorkExperienceTypesAll;
    [[WorkExperienceType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (WorkExperienceTypes)[key integerValue];
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(WorkExperienceTypesAll) : @"不限",
             @(WorkExperienceTypesGraduates) : @"应届毕业生",
             @(WorkExperienceTypesOverOneYear) : @"1年以上",
             @(WorkExperienceTypesOverTwoYear) : @"2年以上",
             @(WorkExperienceTypesOverThreeYear) : @"3年以上",
             @(WorkExperienceTypesOverFiveYear) : @"5年以上",
             @(WorkExperienceTypesOverTenYear) : @"10年以上",
             };
}

@end
