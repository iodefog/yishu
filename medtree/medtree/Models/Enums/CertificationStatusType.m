//
//  CertificationStatusType.m
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "CertificationStatusType.h"

@implementation CertificationStatusType

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未认证" forKey:[NSNumber numberWithInteger:CertificationStatusType_No]];
        [dict setObject:@"认证中" forKey:[NSNumber numberWithInteger:CertificationStatusType_Wait]];
        [dict setObject:@"已认证" forKey:[NSNumber numberWithInteger:CertificationStatusType_Pass]];
        [dict setObject:@"未通过" forKey:[NSNumber numberWithInteger:CertificationStatusType_NotPass]];
        [dict setObject:@"自动屏蔽" forKey:[NSNumber numberWithInteger:CertificationStatusType_Screen]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

+ (NSInteger)getInteger:(NSString *)title
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"未认证" forKey:[NSNumber numberWithInteger:CertificationStatusType_No]];
        [dict setObject:@"认证中" forKey:[NSNumber numberWithInteger:CertificationStatusType_Wait]];
        [dict setObject:@"已认证" forKey:[NSNumber numberWithInteger:CertificationStatusType_Pass]];
        [dict setObject:@"未通过" forKey:[NSNumber numberWithInteger:CertificationStatusType_NotPass]];
        [dict setObject:@"自动屏蔽" forKey:[NSNumber numberWithInteger:CertificationStatusType_Screen]];
    }
    
    NSArray *array = [dict allKeys];
    NSInteger keyNum = 0;
    for (NSString *key in array)
    {
        if (  [title isEqualToString:[dict objectForKey:key] ] )
        {
            keyNum = [key integerValue];
            break;
        }
    }
    return keyNum;
}

@end
