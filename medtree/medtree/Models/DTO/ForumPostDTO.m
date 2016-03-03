//
//  ForumPostDTO.m
//  medtree
//
//  Created by 陈升军 on 15/3/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ForumPostDTO.h"
#import "DateUtil.h"

@implementation ForumPostDTO

- (BOOL)parse:(NSDictionary *)dict
{
    NSLog(@"%@",dict);
    self.user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"user_id"] longLongValue]];
    self.postID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    self.reply_to_user_name = [self getStrValue:[dict objectForKey:@"reply_to_user_name"]];
    self.user_name = [self getStrValue:[dict objectForKey:@"user_name"]];
    {
        long long time = [[dict objectForKey:@"created"] longLongValue];
        self.created = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:time/1000]];
    }
    self.is_anonymous = [[dict objectForKey:@"is_anonymous"] boolValue];
    self.reply_to_post_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_post_id"] longLongValue]];
    self.reply_to_user_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_user_id"] longLongValue]];
    self.content = [self getStrValue:[dict objectForKey:@"content"]];
    
    //
    {
        if (self.comments == nil) {
            self.comments = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"sub_comment_list"] != [NSNull null] && [dict objectForKey:@"sub_comment_list"] != nil) {
            NSArray *array = [dict objectForKey:@"sub_comment_list"];
            [self.comments addObjectsFromArray:array];
        }
    }
    
    self.is_liked = [[dict objectForKey:@"is_liked"] boolValue];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.likes_str = [self getStrValue:[dict objectForKey:@"likes_summary"]];
    return YES;
}

@end
