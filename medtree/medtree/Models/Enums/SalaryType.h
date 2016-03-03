//
//  SalaryType.h
//  medtree
//
//  Created by 孙晨辉 on 15/12/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, SalaryTypes) {
    SalaryTypesAll,
    SalaryTypesLow,
    SalaryTypesMiddle,
    SalaryTypesHigh,
    SalaryTypesHigher,
    SalaryTypesHighest,
    SalaryTypesOther
};

@interface SalaryType : EnumBase

+ (NSString *)getLabel:(SalaryTypes)type;
+ (SalaryTypes)getInteger:(NSString *)title;

@end
