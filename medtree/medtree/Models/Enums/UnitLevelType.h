//
//  UnitLevelType.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, UnitLevelTypes) {
    UnitLevelTypesAll,
    UnitLevelTypesHighest,
    UnitLevelTypesHigher,
    UnitLevelTypesHigh,
    UnitLevelTypesLow,
    UnitLevelTypesLower,
    UnitLevelTypesOther
};

@interface UnitLevelType : EnumBase

+ (NSString *)getLabel:(UnitLevelTypes)type;
+ (UnitLevelTypes)getInteger:(NSString *)title;
+ (NSDictionary *)dict;

@end
