//
//  TopicDTO.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TopicDTO.h"
#import "DateUtil.h"

@implementation TopicDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.create_time = [DateUtil convertTime:[dict objectForKey:@"create_time"]];
    self.start_time = [DateUtil convertTime:[dict objectForKey:@"start_time"]];
    self.end_time = [DateUtil convertTime:[dict objectForKey:@"end_time"]];
    
    self.topicID = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
    self.large_image_id = [self getStrValue:[dict objectForKey:@"large_image_id"]];
    self.small_image_id = [self getStrValue:[dict objectForKey:@"small_image_id"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.desc = [self getStrValue:[dict objectForKey:@"desc"]];
    self.tag = [self getStrValue:[dict objectForKey:@"tag"]];
    self.url = [self getStrValue:[dict objectForKey:@"url"]];
    self.summary = [self getStrValue:[dict objectForKey:@"summary"]];
    self.event_type = [self getIntValue:[dict objectForKey:@"event_type"]];
    self.is_end = [self getIntValue:[dict objectForKey:@"is_end"]];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.post_count = [self getIntValue:[dict objectForKey:@"post_count"]];
    
    self.creater = [NSString stringWithFormat:@"%0.0f", [[dict objectForKey:@"creater"] doubleValue]];
    self.creater_name = [self getStrValue:[dict objectForKey:@"creater_name"]];
    self.avatar = [self getStrValue:[dict objectForKey:@"avatar"]];
    
    self.is_liked = [self getIntValue:[dict objectForKey:@"is_liked"]];
    self.share_url = [self getStrValue:[dict objectForKey:@"share_url"]];
    self.avatar = [self getStrValue:[dict objectForKey:@"avatar"]];
    
    {
        if (self.links == nil) {
            self.links = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"links"] != [NSNull null] && [dict objectForKey:@"links"] != nil) {
            NSArray *array = [dict objectForKey:@"links"];
            [self.links addObjectsFromArray:array];
        }
    }
    
    return YES;
}

@end
