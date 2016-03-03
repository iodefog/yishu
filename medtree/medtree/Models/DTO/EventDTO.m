//
//  EventDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDTO.h"
#import "DateUtil.h"

@implementation EventDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.sysid = [self getStrValue:[dict objectForKey:@"id"]];
    self.event_type = [self getIntValue:[dict objectForKey:@"event_type"]];
    self.is_end = [self getIntValue:[dict objectForKey:@"is_end"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.desc = [self getStrValue:[dict objectForKey:@"desc"]];
    self.small_image_id = [self getStrValue:[dict objectForKey:@"small_image_id"]];
    self.large_image_id = [self getStrValue:[dict objectForKey:@"large_image_id"]];
    self.tag = [self getStrValue:[dict objectForKey:@"tag"]];
    self.url = [self getStrValue:[dict objectForKey:@"url"]];
    self.share_url = [self getStrValue:[dict objectForKey:@"share_url"]];
    self.start_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"start_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.end_time = [DateUtil convertTime:[self getStrValue:[dict objectForKey:@"end_time"]] formate:@"yyyy-MM-dd HH:mm:ss"];
    self.comment_count = [self getIntValue:[dict objectForKey:@"comment_count"]];
    self.like_count = [self getIntValue:[dict objectForKey:@"like_count"]];
    self.offic_count = [self getIntValue:[dict objectForKey:@"offic_count"]];
    {
        if (self.links == nil) {
            self.links = [[NSMutableArray alloc] init];
        }
        [self.links addObjectsFromArray:[dict objectForKey:@"links"]];
    }
    self.place = [dict objectForKey:@"place"];
    self.summary = [dict objectForKey:@"summary"];
    return tf;
}

@end
