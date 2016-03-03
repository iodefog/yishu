//
//  OrganizationTypes.m
//  medtree
//
//  Created by 无忧 on 14-9-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "OrganizationTypes.h"

@implementation OrganizationTypes

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"其他" forKey:[NSNumber numberWithInteger:OrganizationTypes_Other]];
        [dict setObject:@"医学院" forKey:[NSNumber numberWithInteger:OrganizationTypes_School]];
        [dict setObject:@"医院" forKey:[NSNumber numberWithInteger:OrganizationTypes_Hospital]];
        [dict setObject:@"机构" forKey:[NSNumber numberWithInteger:OrganizationTypes_Institue]];
        [dict setObject:@"学会" forKey:[NSNumber numberWithInteger:OrganizationTypes_Learn]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

@end
