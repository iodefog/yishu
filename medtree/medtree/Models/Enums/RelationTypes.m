//
//  RelationTypes.m
//  mcare-model
//
//  Created by sam on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RelationTypes.h"

@implementation RelationTypes

+ (NSString *)getLabel:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    if (dict == nil) {
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:@"未设置" forKey:[NSNumber numberWithInteger:RelationTypes_None]];
        [dict setObject:@"好友" forKey:[NSNumber numberWithInteger:RelationTypes_Friend]];
        [dict setObject:@"同学" forKey:[NSNumber numberWithInteger:RelationTypes_Classmate]];
        [dict setObject:@"校友" forKey:[NSNumber numberWithInteger:RelationTypes_Alumni]];
        [dict setObject:@"同行" forKey:[NSNumber numberWithInteger:RelationTypes_Peer]];
        [dict setObject:@"导师" forKey:[NSNumber numberWithInteger:RelationTypes_Tutor]];
        [dict setObject:@"同事" forKey:[NSNumber numberWithInteger:RelationTypes_Colleague]];
        [dict setObject:@"好友的好友" forKey:[NSNumber numberWithInteger:RelationTypes_otherFriend]];
        
        [dict setObject:@"学会会员" forKey:[NSNumber numberWithInteger:RelationTypes_Membership]];
        [dict setObject:@"陌生人" forKey:[NSNumber numberWithInteger:RelationTypes_Stranger]];
    }
    NSString *label = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return label ? label : @"";
}

@end
