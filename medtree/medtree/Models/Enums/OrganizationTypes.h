//
//  OrganizationTypes.h
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "EnumBase.h"

@interface OrganizationTypes : EnumBase

typedef enum {
    OrganizationTypes_Other          = 0,
    OrganizationTypes_School         = 10,
    OrganizationTypes_Hospital       = 20,
    OrganizationTypes_Institue       = 30,
    OrganizationTypes_Learn          = 40
} Organization_Types;

+ (NSString *)getLabel:(NSInteger)type;

@end
