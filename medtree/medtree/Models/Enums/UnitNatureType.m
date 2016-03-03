//
//  UnitNatureType.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "UnitNatureType.h"

@implementation UnitNatureType

+ (NSString *)getLabel:(UnitNatureTypes)type
{
    NSString *label = [UnitNatureType dict][@(type)];
    return label ? label : @"";
}

+ (UnitNatureTypes)getInteger:(NSString *)title
{
    __block UnitNatureTypes type = UnitNatureTypesAll;
    [[UnitNatureType dict] enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *obj, BOOL * stop) {
        if (obj == title) {
            type = (UnitNatureTypes)[key integerValue];
            *stop = true;
        }
    }];
    return type;
}

+ (NSDictionary *)dict
{
    return @{
             @(UnitNatureTypesAll) : @"不限",
             @(UnitNatureTypesPublic) : @"事业单位",
             @(UnitNatureTypesStateAdministration) : @"国家行政机关",
             @(UnitNatureTypesStateOwnedEnterprise) : @"国有企业",
             @(UnitNatureTypesStateOwnedHoldingEnterprise) : @"国有控股企业",
             @(UnitNatureTypesForeignCompany) : @"外资企业",
             @(UnitNatureTypesJointCompany) : @"合资企业",
             @(UnitNatureTypesPrivateCompany) : @"私营企业",
             };
}

@end
