//
//  StatusTypes.m
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StatusTypes.h"

@implementation StatusTypes

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"离线" forKey:[NSNumber numberWithInteger:StatusTypes_Offline]];
        [dict setObject:@"在线" forKey:[NSNumber numberWithInteger:StatusTypes_Online]];
        [dict setObject:@"手术中" forKey:[NSNumber numberWithInteger:StatusTypes_Operating]];
        [dict setObject:@"门诊中" forKey:[NSNumber numberWithInteger:StatusTypes_Clinic]];
        [dict setObject:@"工作中" forKey:[NSNumber numberWithInteger:StatusTypes_Working]];
        [dict setObject:@"休假中" forKey:[NSNumber numberWithInteger:StatusTypes_Vacation]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

@end
