//
//  ForumDTO.m
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ForumDTO.h"
#import "UserDTO.h"
#import "DateUtil.h"

@implementation ForumDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"user_id"] longLongValue]];
    self.forumID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    self.bonus_assignment_summary = [self getStrValue:[dict objectForKey:@"bonus_assignment_summary"]];
    {
        long long time = [[dict objectForKey:@"updated"] longLongValue];
        self.updated = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
    }
    {
        long long time = [[dict objectForKey:@"created"] longLongValue];
        self.created = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
    }
    self.user_name = [self getStrValue:[dict objectForKey:@"user_name"]];
    self.category = [self getStrValue:[dict objectForKey:@"category"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.content = [self getStrValue:[dict objectForKey:@"content"]];
    self.is_liked = [[dict objectForKey:@"is_liked"] boolValue];
    self.is_helped = [[dict objectForKey:@"is_helped"] boolValue];
    self.is_anonymous = [[dict objectForKey:@"is_anonymous"] boolValue];
    self.user_count = [self getIntValue:[dict objectForKey:@"user_count"]];
    self.bonus_sys = [self getIntValue:[dict objectForKey:@"bonus_sys"]];
    self.bounty = [self getIntValue:[dict objectForKey:@"bonus"]];
    self.comment_count = [self getIntValue:[dict objectForKey:@"comment_count"]];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.zone = [self getIntValue:[dict objectForKey:@"zone"]];
    self.relation_summary = [self getStrValue:[dict objectForKey:@"relation_summary"]];
    
    self.category_icon = [self getStrValue:[dict objectForKey:@"category_icon"]];
    self.category_image = [self getStrValue:[dict objectForKey:@"category_image"]];
    //
    {
        if (self.bonus_assignment == nil) {
            self.bonus_assignment = [[NSDictionary alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"bonus_assignment"] != [NSNull null] && [dict objectForKey:@"bonus_assignment"] != nil) {
            self.bonus_assignment = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"bonus_assignment"]];
        }
    }
    //
    {
        if (self.images == nil) {
            self.images = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
            [self.images removeAllObjects];
            NSArray *array = [dict objectForKey:@"images"];
            [self.images addObjectsFromArray:array];
        }
    }
    
    //
    {
        if (self.tagArray == nil) {
            self.tagArray = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"tag"] != [NSNull null] && [dict objectForKey:@"tag"] != nil) {
            [self.tagArray removeAllObjects];
            NSArray *array = [dict objectForKey:@"tag"];
            [self.tagArray addObjectsFromArray:array];
        }
    }
    
    self.forumtype = ForumDTO_Type_Title;
    
    return YES;
}

@end
