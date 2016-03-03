//
//  DepartmentNameDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-19.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DepartmentNameDTO.h"

@implementation DepartmentNameDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.departmentID = [self getStrValue:[dict objectForKey:@"id"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.org_id = [self getStrValue:[dict objectForKey:@"org_id"]];
    self.level = [self getIntValue:[dict objectForKey:@"level"]];
    
    self.parent_id = [self getStrValue:[dict objectForKey:@"parent_id"]];
    self.hasChild = [self getBoolValue:dict[@"has_child"]];
    return YES;
}

@end
