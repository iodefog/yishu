//
//  ProfessionTypes.m
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ProfessionTypes.h"

@implementation ProfessionTypes

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未知" forKey:[NSNumber numberWithInteger:ProfessionTypes_Unknown]];
        [dict setObject:@"医生" forKey:[NSNumber numberWithInteger:ProfessionTypes_Doctor]];
        [dict setObject:@"护士" forKey:[NSNumber numberWithInteger:ProfessionTypes_Nurse]];
        [dict setObject:@"医学生" forKey:[NSNumber numberWithInteger:ProfessionTypes_Student]];
        [dict setObject:@"医护工作者" forKey:[NSNumber numberWithInteger:ProfessionTypes_Worker]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

@end
