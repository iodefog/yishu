//
//  UnitNatureType.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, UnitNatureTypes) {
    UnitNatureTypesAll,
    UnitNatureTypesPublic,
    UnitNatureTypesStateAdministration,
    UnitNatureTypesStateOwnedEnterprise,
    UnitNatureTypesStateOwnedHoldingEnterprise,
    UnitNatureTypesForeignCompany,
    UnitNatureTypesJointCompany,
    UnitNatureTypesPrivateCompany
};

@interface UnitNatureType : EnumBase

+ (NSString *)getLabel:(UnitNatureTypes)type;
+ (UnitNatureTypes)getInteger:(NSString *)title;
+ (NSDictionary *)dict;

@end
