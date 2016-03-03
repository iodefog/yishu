//
//  WorkExperienceType.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, WorkExperienceTypes) {
    WorkExperienceTypesAll      = 0,
    WorkExperienceTypesGraduates,
    WorkExperienceTypesOverOneYear,
    WorkExperienceTypesOverTwoYear,
    WorkExperienceTypesOverThreeYear,
    WorkExperienceTypesOverFiveYear,
    WorkExperienceTypesOverTenYear
};

@interface WorkExperienceType : EnumBase

+ (NSString *)getLabel:(WorkExperienceTypes)type;
+ (WorkExperienceTypes)getInteger:(NSString *)title;
+ (NSDictionary *)dict;

@end
