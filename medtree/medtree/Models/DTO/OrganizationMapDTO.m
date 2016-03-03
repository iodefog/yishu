//
//  OrganizationMapDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "OrganizationMapDTO.h"

@implementation OrganizationMapDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.organizationID = [self getStrValue:[dict objectForKey:@"id"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.region = [self getStrValue:[dict objectForKey:@"region"]];
    
//    NSDictionary *statsDict = [dict objectForKey:@"stats"];
//    self.first_degree_count = [self getIntValue:[statsDict objectForKey:@"first_degree_count"]];
//    self.second_degree_count = [self getIntValue:[statsDict objectForKey:@"second_degree_count"]];
    self.total_count = [self getIntValue:[dict objectForKey:@"count"]];
    
    NSDictionary *locationDict = [dict objectForKey:@"location"];
    self.latitude = [self getDoubleValue:[locationDict objectForKey:@"latitude"]];
    self.longitude = [self getDoubleValue:[locationDict objectForKey:@"longitude"]];
    
    self.org_type = [self getIntValue:[dict objectForKey:@"org_type"]];
    self.image = [self getStrValue:[dict objectForKey:@"image"]];
    return YES;
}

@end
