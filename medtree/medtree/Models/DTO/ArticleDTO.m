//
//  ArticleDTO.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ArticleDTO.h"
#import "DateUtil.h"

@implementation ArticleDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.articleID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    self.summary = [self getStrValue:[dict objectForKey:@"summary"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.create_time = [DateUtil convertTime:[dict objectForKey:@"create_time"]];
    self.read_count = [self getIntValue:[dict objectForKey:@"read_count"]];
    self.url = [self getStrValue:[dict objectForKey:@"url"]];
    self.source = [self getStrValue:[dict objectForKey:@"source"]];
    self.author = [self getStrValue:[dict objectForKey:@"author"]];
    self.image_id = [self getStrValue:[dict objectForKey:@"image_id"]];
    self.share_url = [self getStrValue:[dict objectForKey:@"share_url"]];
    self.articleType = [self getIntValue:[dict objectForKey:@"article_type"]];
    self.comment_count = [self getIntValue:[dict objectForKey:@"comment_count"]];
    self.is_like = [self getIntValue:[dict objectForKey:@"is_liked"]];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    return YES;
}

@end
