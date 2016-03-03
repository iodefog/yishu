//
//  OrganizationNameDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-19.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "OrganizationNameDTO.h"

@implementation OrganizationNameDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.organizationID = [self getStrValue:[dict objectForKey:@"id"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.latitude = [self getDoubleValue:[dict objectForKey:@"latitude"]];
    self.longitude = [self getDoubleValue:[dict objectForKey:@"longitude"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];

    return YES;
}

@end
