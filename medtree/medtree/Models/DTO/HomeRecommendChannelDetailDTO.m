//
//  HomeRecommendChannelDTO.m
//  medtree
//
//  Created by tangshimi on 8/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeRecommendChannelDetailDTO.h"
#import "MedGlobal.h"
#import <DateUtil.h>

@implementation HomeRecommendChannelDetailDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.channelID =  [self getStrValue:[dict objectForKey:@"id"]];
    self.channelName = [self getStrValue:[dict objectForKey:@"name"]];
    self.channelImage = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], [self getStrValue:[dict objectForKey:@"avatar"]]];
    self.alreadySetTags = [self getBoolValue:[dict objectForKey:@"user_has_tag"]];
    self.channelHaveTags = [self getBoolValue:[dict objectForKey:@"has_tag"]];
    self.createrID = [self getStrValue:[dict objectForKey:@"creator"]];
    self.createdTime =  [DateUtil getDisplayTime:[self getDateValue:[dict objectForKey:@"created"]]];
    self.canPublish = [self getBoolValue:[dict objectForKey:@"client_publish"]];
    self.canEnter = [self getBoolValue:[dict objectForKey:@"has_power_into"]];
    self.publishFeedPlaceHolderText = [self getStrValue:[dict objectForKey:@"place_holder"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.channelIntroduction = [self getStrValue:dict[@"channel_present"]];
    
    return YES;
}

@end
