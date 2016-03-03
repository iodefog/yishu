//
//  DepartmentDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-9.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DepartmentDTO.h"

@implementation DepartmentDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.departmentID = [self getStrValue:[dict objectForKey:@"id"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.org_id = [self getStrValue:[dict objectForKey:@"org_id"]];
    self.count = [self getIntValue:[dict objectForKey:@"count"]];
//    self.second_degree_count = [self getIntValue:[dict objectForKey:@"second_degree_count"]];
    
    return YES;
}

@end
