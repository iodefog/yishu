//
//  PeopleDTO.m
//  medtree
//
//  Created by 无忧 on 14-9-9.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PeopleDTO.h"

@implementation PeopleDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.peopleID = [self getStrValue:[NSString stringWithFormat:@"%d",[[dict objectForKey:@"id"] intValue]]];
    self.degree = [self getIntValue:[dict objectForKey:@"degree"]];
    if ((NSObject *)[dict objectForKey:@"connection"] == [NSNull null]) {
        self.connection = [NSArray array];
    } else {
        self.connection = [NSArray arrayWithArray:[dict objectForKey:@"connection"]];
    }
    if ((NSObject *)[dict objectForKey:@"referrer"] == [NSNull null]) {
        self.connection = [NSArray array];
    } else {
        self.referrer = [NSArray arrayWithArray:[dict objectForKey:@"referrer"]];
    }
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.chatID = [self getStrValue:[dict objectForKey:@"chat_id"]];
    self.name = [self getStrValue:[dict objectForKey:@"realname"]];
    self.gender = [self getIntValue:[dict objectForKey:@"gender"]];
    self.age = [self getStrValue:[dict objectForKey:@"age"]];
    self.desc = [self getStrValue:[dict objectForKey:@"signature"]];
    self.photoID = [self getStrValue:[dict objectForKey:@"avatar"]];
    self.relation = [self getIntValue:[dict objectForKey:@"relation"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.last_active = [self getStrValue:[dict objectForKey:@"last_active"]];
    self.distance = [self getStrValue:[dict objectForKey:@"distance"]];
    self.constellation = [self getStrValue:[dict objectForKey:@"constellation"]];
    self.interest = [self getStrValue:[dict objectForKey:@"interest"]];
    self.regtime = [self getStrValue:[dict objectForKey:@"regtime"]];
    self.birthday = [self getStrValue:[dict objectForKey:@"birthday"]];
    self.isFriend = [[dict objectForKey:@"is_friend"] boolValue];
    self.is_certificated = [[dict objectForKey:@"is_certificated"] boolValue];
    self.certificate_info = [self getStrValue:[dict objectForKey:@"certificate_info"]];
    self.department_id = [self getStrValue:[dict objectForKey:@"department_id"]];
    self.organization_id = [self getStrValue:[dict objectForKey:@"organization_id"]];
    self.department_name = [self getStrValue:[dict objectForKey:@"department_name"]];
    self.organization_name = [self getStrValue:[dict objectForKey:@"organization_name"]];
    self.distance_km = [self getDoubleValue:[dict objectForKey:@"distance_km"]];
    self.user_type = [self getIntValue:[dict objectForKey:@"user_type"]];
    self.certificate_user_type = [self getIntValue:[dict objectForKey:@"certificate_user_type"]];
    
    return YES;
}

@end

