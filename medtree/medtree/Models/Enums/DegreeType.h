//
//  DegreeType.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, DegreeTypes) {
    DegreeTypesAll,
    DegreeTypesCollege,
    DegreeTypesBachelor,
    DegreeTypesMaster,
    DegreeTypesDoctor,
    DegreeTypesPostdoctor,
    DegreeTypesOther
};

@interface DegreeType : EnumBase

+ (NSString *)getLabel:(DegreeTypes)type;
+ (DegreeTypes)getInteger:(NSString *)title;
+ (NSDictionary *)dict;

@end
