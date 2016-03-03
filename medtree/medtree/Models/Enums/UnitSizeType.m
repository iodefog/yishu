//
//  UnitSizeType.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "UnitSizeType.h"

@implementation UnitSizeType

+ (NSString *)getLabel:(UnitSizeTypes)type
{
    NSString *label = [UnitSizeType dict][@(type)];
    return label ? label : @"";
}

+ (UnitSizeTypes)getInteger:(NSString *)title
{
    __block UnitSizeTypes type = UnitSizeTypesAll;
    [[UnitSizeType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (UnitSizeTypes)[key integerValue];
            *stop = true;
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(UnitSizeTypesAll) : @"不限",
             @(UnitSizeTypesSmaller) : @"1-400人",
             @(UnitSizeTypesSmall) : @"400人以上",
             @(UnitSizeTypesMiddle) : @"1000人以上",
             @(UnitSizeTypesBig) : @"2000人以上",
             @(UnitSizeTypesHuge) : @"4000人以上"
             };
}

@end
