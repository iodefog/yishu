//
//  UnitSizeType.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "EnumBase.h"

typedef NS_ENUM(NSUInteger, UnitSizeTypes) {
    UnitSizeTypesAll,
    UnitSizeTypesSmaller,
    UnitSizeTypesSmall,
    UnitSizeTypesMiddle,
    UnitSizeTypesBig,
    UnitSizeTypesHuge
};

@interface UnitSizeType : EnumBase

+ (NSString *)getLabel:(UnitSizeTypes)type;
+ (UnitSizeTypes)getInteger:(NSString *)title;
+ (NSDictionary *)dict;

@end
