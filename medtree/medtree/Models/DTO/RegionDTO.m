//
//  RegionDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "RegionDTO.h"

@implementation RegionDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.first_degree_count = [self getIntValue:[dict objectForKey:@"first_degree_count"]];
    self.second_degree_count = [self getIntValue:[dict objectForKey:@"second_degree_count"]];
    
    return YES;
}

@end
