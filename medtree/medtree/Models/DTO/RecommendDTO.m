//
//  RecommendDTO.m
//  medtree
//
//  Created by 陈升军 on 15/1/20.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "RecommendDTO.h"
#import "EventDTO.h"

@implementation RecommendDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.recommendID = [self getStrValue:[dict objectForKey:@"id"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.summary = [self getStrValue:[dict objectForKey:@"summary"]];
    self.content_type = [self getIntValue:[dict objectForKey:@"content_type"]];
    self.eventDTO = [[EventDTO alloc] init:[dict objectForKey:@"content"]];
    self.url = [self getStrValue:[dict objectForKey:@"url"]];
    self.image_id = [self getStrValue:[dict objectForKey:@"image_id"]];
    
    return YES;
}

@end
