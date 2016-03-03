//
//  HomeDiscussionDTO.m
//  medtree
//
//  Created by tangshimi on 9/1/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeArticleAndDiscussionDTO.h"
#import <DateUtil.h>

@implementation HomeArticleAndDiscussionDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.id = [self getStrValue:[dict objectForKey:@"id"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.channelID = [self getStrValue:[dict objectForKey:@"channel_id"]];
    self.channelName = [self getStrValue:[dict objectForKey:@"channel_name"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.content = [self getStrValue:[dict objectForKey:@"content"]];
    self.images = [self getArrayValue:[dict objectForKey:@"images"]];
    self.tags = [self getArrayValue:[dict objectForKey:@"tags"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.anonymous = [self getBoolValue:[dict objectForKey:@"is_anonymous"]];
    self.createrID = [self getStrValue:[dict objectForKey:@"creator"]];
    self.createdTime = [DateUtil getDisplayTime:[self getDateValue:[dict objectForKey:@"created"]]];
    self.updatedTime = [DateUtil getDisplayTime:[self getDateValue:[dict objectForKey:@"updated"]]];
    self.commentCount = [self getIntValue:[dict objectForKey:@"comment_count"]];
    self.favourCount = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.favour = [self getBoolValue:[dict objectForKey:@"isliked"]];
    self.contentLevel = [self getIntValue:[dict objectForKey:@"content_level"]];
    self.clickCount = [self getIntValue:[dict objectForKey:@"click_count"]];
    self.virtualCount = [self getIntValue:[dict objectForKey:@"virtual_count"]];
    self.autor = [self getStrValue:[dict objectForKey:@"author"]];
    self.subTitle = [self getStrValue:[dict objectForKey:@"sub_title"]];
    self.source = [self getStrValue:[dict objectForKey:@"source"]];
    self.summary = [self getStrValue:[dict objectForKey:@"summary"]];
    self.articleURL = [self getStrValue:[dict objectForKey:@"url"]];
    self.shareURL = [self getStrValue:[dict objectForKey:@"share_url"]];
    self.isEssence = [self getBoolValue:dict[@"high_light"]];
    
    return YES;
}

@end
