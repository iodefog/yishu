//
//  ArticleCommentDTO.m
//  medtree
//
//  Created by 边大朋 on 15-4-14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ArticleCommentDTO.h"
#import "DateUtil.h"
@implementation ArticleCommentDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    
    self.cellType = [self getIntValue:[dict objectForKey:@"cellType"]];
    self.comment_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"comment_id"] longLongValue]];
    self.comment_content = [self getStrValue:[dict objectForKey:@"comment_content"]];
    
    self.user_avatar = [self getStrValue:[dict objectForKey:@"user_avatar"]];
    self.userName = [self getStrValue:[dict objectForKey:@"user_name"]];

    self.comment_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"comment_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    
    self.user_id = [self getIntValue:[dict objectForKey:@"user_id"]];
    //self.reply_to_feed_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_feed_id"] longLongValue]];
    
    self.reply_to_article_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"reply_to_feed_id"] longLongValue]];
    
    self.reply_to_user_id = [self getIntValue:[dict objectForKey:@"reply_to_user_id"]];//扩展字段，3.0版本用不到
    
     self.commentCount = [self getIntValue:[dict objectForKey:@"comment_count"]];
     self.likeCount = [self getIntValue:[dict objectForKey:@"likeCount"]];
    
    return tf;
}

@end
