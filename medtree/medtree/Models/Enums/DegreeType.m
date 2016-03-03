//
//  DegreeType.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DegreeType.h"

@implementation DegreeType

+ (NSString *)getLabel:(DegreeTypes)type
{
    NSString *label = [DegreeType dict][@(type)];
    return label ? label : @"";
}

+ (DegreeTypes)getInteger:(NSString *)title
{
    __block DegreeTypes type = DegreeTypesAll;
    [[DegreeType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (DegreeTypes)[key integerValue];
            *stop = true;
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(DegreeTypesAll) : @"学历不限",
             @(DegreeTypesCollege) : @"大中专及以上",
             @(DegreeTypesBachelor) : @"本科及以上",
             @(DegreeTypesMaster) : @"硕士及以上",
             @(DegreeTypesDoctor) : @"博士及以上",
             @(DegreeTypesOther) : @"其他"
             };
}

@end
