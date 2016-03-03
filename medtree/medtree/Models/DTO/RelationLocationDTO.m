//
//  RelationLocationDTO.m
//  medtree
//
//  Created by tangshimi on 6/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationLocationDTO.h"

@implementation RelationLocationDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.address = [self getStrValue:[dict objectForKey:@"address"]];
    self.alias = [self getStrValue:[dict objectForKey:@"alias"]];
    self.city = [self getStrValue:[dict objectForKey:@"city"]];
    self.created = [self getStrValue:[dict objectForKey:@"created"]];
    self.creater = [self getStrValue:[dict objectForKey:@"creater"]];
    self.id = [self getStrValue:[dict objectForKey:@"id"]];
    self.latitude = [self getDoubleValue:[dict objectForKey:@"latitude"]];
    self.longitude = [self getDoubleValue:[dict objectForKey:@"longitude"]];
    self.medical_institution = [self getIntValue:[dict objectForKey:@"medical_institution"]];
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.org_grade = [self getIntValue:[dict objectForKey:@"org_grade"]];
    self.pinyin = [self getStrValue:[dict objectForKey:@"pinyin"]];
    self.province = [self getStrValue:[dict objectForKey:@"province"]];
    self.region = [self getStrValue:[dict objectForKey:@"region"]];
    self.source = [self getIntValue:[dict objectForKey:@"source"]];
    self.type = [self getIntValue:[dict objectForKey:@"type"]];
    self.updated = [self getStrValue:[dict objectForKey:@"updated"]];
    self.visible = [self getIntValue:[dict objectForKey:@"visible"]];
    
    return YES;
}

@end
