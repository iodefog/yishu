//
//  FeedCommentDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedCommentDTO.h"
#import "FeedDTO.h"
#import "DateUtil.h"
#import "UserManager.h"
#import "UserDTO.h"

@implementation FeedCommentDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.reply_to_feed_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_feed_id"] longLongValue]];
    self.reply_to_user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_user_id"] longLongValue]];
    self.user_id = [NSString stringWithFormat:@"%@", [dict objectForKey:@"user_id"]];
    self.user_name = [self getStrValue:[dict objectForKey:@"user_name"]];
    self.comment_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"comment_id"] longLongValue]];
    self.comment_content = [self getStrValue:[dict objectForKey:@"comment_content"]];
    self.comment_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"comment_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    //
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.is_liked = [[dict objectForKey:@"is_liked"] boolValue];
    //
    self.feed = [[FeedDTO alloc] init:[dict objectForKey:@"feed"]];
    self.reply_to_user_name = [self getStrValue:[dict objectForKey:@"reply_to_user_name"]];
    self.cellType = [self getIntValue:[dict objectForKey:@"cellType"]];
    //
    return tf;
}

- (void)dictToDTO:(NSDictionary *)dictionary
{
    self.comment_content = [self getStrValue:[dictionary objectForKey:@"content"]];
    self.comment_time = [DateUtil convertTime:[self getStrValue:[dictionary objectForKey:@"comment_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.user_id = [self getStrValue:[dictionary objectForKey:@"creater"]];
    self.comment_id = [self getStrValue:[dictionary objectForKey:@"id"]];
    self.reply_to_item_id = [self getStrValue:[dictionary objectForKey:@"reply_to_item_id"]];
}

@end
