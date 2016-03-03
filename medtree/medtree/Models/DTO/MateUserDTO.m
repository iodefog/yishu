//
//  MateUserDTO.m
//  medtree
//
//  Created by 陈升军 on 15/4/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateUserDTO.h"

@implementation MateUserDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.mateID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    self.marked_user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"marked_user_id"] longLongValue]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    
    self.match_type = [self getIntValue:[dict objectForKey:@"match_type"]];
    self.same_name_count = [self getIntValue:[dict objectForKey:@"same_name_count"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.relation = [self getIntValue:[dict objectForKey:@"relation"]];


    //
    {
        if (self.phones_encrypted == nil) {
            self.phones_encrypted = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"phones_encrypted"] != [NSNull null] && [dict objectForKey:@"phones_encrypted"] != nil) {
            [self.phones_encrypted removeAllObjects];
            NSArray *array = [dict objectForKey:@"phones_encrypted"];
            [self.phones_encrypted addObjectsFromArray:array];
        }
    }
    
    //
    {
        if (self.matched_users == nil) {
            self.matched_users = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"matched_users"] != [NSNull null] && [dict objectForKey:@"matched_users"] != nil) {
            [self.matched_users removeAllObjects];
            NSArray *array = [dict objectForKey:@"matched_users"];
            [self.matched_users addObjectsFromArray:array];
        }
    }
    
    return YES;
}

@end
