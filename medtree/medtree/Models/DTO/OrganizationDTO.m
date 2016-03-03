//
//  OrganizationDTO.m
//  medtree
//
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "OrganizationDTO.h"

@implementation OrganizationDTO

- (BOOL)parse:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.key = [self getStrValue:[dict objectForKey:@"key"]];
    self.value = [self getStrValue:[dict objectForKey:@"value"]];
    self.value2 = [self getStrValue:[dict objectForKey:@"value2"]];
    self.value2 = [self getStrValue:[dict objectForKey:@"value3"]];
    self.time = [self getStrValue:[dict objectForKey:@"time"]];
    self.startDate = [self getStrValue:[dict objectForKey:@"startDate"]];
    self.endDate = [self getStrValue:[dict objectForKey:@"endDate"]];
    self.cellType = [self getIntValue:[dict objectForKey:@"cellType"]];
    self.orig_type = [self getIntValue:[dict objectForKey:@"orig_type"]];
    self.isOn =[[dict objectForKey:@"isOn"] boolValue];
    self.isCommonFriend =[[dict objectForKey:@"isCommonFriend"] boolValue];
    self.is_certificated = [[dict objectForKey:@"is_certificated"] boolValue];
    self.experienceId = [self getStrValue:[dict objectForKey:@"id"]];
    return tf;
}

@end
