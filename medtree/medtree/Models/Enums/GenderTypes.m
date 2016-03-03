//
//  GenderTypes.m
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GenderTypes.h"

@implementation GenderTypes

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"保密" forKey:[NSNumber numberWithInteger:GenderTypes_Secrecy]];
        [dict setObject:@"男" forKey:[NSNumber numberWithInteger:GenderTypes_Male]];
        [dict setObject:@"女" forKey:[NSNumber numberWithInteger:GenderTypes_Female]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

@end
