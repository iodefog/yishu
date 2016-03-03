//
//  UserDTO.m
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDTO.h"
#import "PairDTO.h"
#import "DateUtil.h"
#import "ExperienceDTO.h"

@implementation UserDTO

- (BOOL)parse:(NSDictionary *)dict
{
    NSDictionary *result = [dict objectForKey:@"result"];
    if (result != nil) {
        return [self parse3:result];
    } else {
        return [self parse3:dict];
    }
}

- (BOOL)parse3:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.isMaster = [self getBoolValue:[dict objectForKey:@"is_master"]];
    self.account_id = [self getStrValue:[dict objectForKey:@"account_id"]];
    self.sideline = [self getStrValue:dict[@"sideline"]];
    self.achievement = [self getStrValue:dict[@"achievement"]];
    self.is_card_complete = [self getBoolValue:dict[@"is_card_complete"]];
    self.userID = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"id"] longLongValue]];
    self.anonymous_id = [NSString stringWithFormat:@"%lld", [[dict objectForKey:@"anonymous_id"] longLongValue]];
    self.chatID = [self getStrValue:[dict objectForKey:@"chat_id"]];
    self.name = [self getStrValue:[dict objectForKey:@"realname"]];
    self.anonymous_name = [self getStrValue:[dict objectForKey:@"anonymous_name"]];
    self.gender = [self getIntValue:[dict objectForKey:@"gender"]];
    self.age = [self getStrValue:[dict objectForKey:@"age"]];
    self.desc = [self getStrValue:[dict objectForKey:@"signature"]];
    self.photoID = [self getStrValue:[dict objectForKey:@"avatar"]];
    self.relation = [self getIntValue:[dict objectForKey:@"relation"]];
    self.status = [self getIntValue:[dict objectForKey:@"status"]];
    self.user_status = [self getIntValue:[dict objectForKey:@"user_status"]];
    self.last_active = [self getStrValue:[dict objectForKey:@"last_active"]];
    self.distance = [self getStrValue:[dict objectForKey:@"distance"]];
    self.constellation = [self getStrValue:[dict objectForKey:@"constellation"]];
    self.interest = [self getStrValue:[dict objectForKey:@"interest"]];
    self.regtime = [self getStrValue:[dict objectForKey:@"regtime"]];
    self.title = [self getStrValue:[dict objectForKey:@"title"]];
    self.birthday = [self getStrValue:[dict objectForKey:@"birthday"]];
    self.birthYear = [[self.birthday componentsSeparatedByString:@"."].firstObject integerValue];
    self.isFriend = [[dict objectForKey:@"is_friend"] boolValue];
    self.is_certificated = [[dict objectForKey:@"is_certificated"] boolValue];
    self.certificate_info = [self getStrValue:[dict objectForKey:@"certificate_info"]];
    self.department_id = [self getStrValue:[dict objectForKey:@"department_id"]];
    self.organization_id = [self getStrValue:[dict objectForKey:@"organization_id"]];
    self.department_name = [self getStrValue:[dict objectForKey:@"department_name"]];
    self.organization_name = [self getStrValue:[dict objectForKey:@"organization_name"]];
    self.distance_km = [self getDoubleValue:[dict objectForKey:@"distance_km"]];
    self.user_type = (User_Types)[self getIntValue:[dict objectForKey:@"user_type"]];
    self.certificate_user_type = [self getIntValue:[dict objectForKey:@"certificate_user_type"]];
    self.isVerify = [[dict objectForKey:@"isVerify"] boolValue];
    self.friend_requests_not_allowed = [self getIntValue:[dict objectForKey:@"friend_requests_not_allowed"]];
    self.common_friends_count = [self getIntValue:[dict objectForKey:@"common_friends_count"]];
    self.common_friends_summary = [self getStrValue:[dict objectForKey:@"common_friends_summary"]];
    self.relation_summary = [self getStrValue:[dict objectForKey:@"relation_summary"]];
    
    //v4.1 add
    self.phone = [self getStrValue:[dict objectForKey:@"phone"]];
    self.selfIntroduction = [self getStrValue:[dict objectForKey:@"selfIntroduction"]];
    self.honour = [self getStrValue:[dict objectForKey:@"honour"]];
    self.birthplace = [self getStrValue:[dict objectForKey:@"birthplace"]];
    self.residential = [self getStrValue:[dict objectForKey:@"residential"]];
    self.workExperience = [self getStrValue:[dict objectForKey:@"workExperience"]];
    self.resumeCount = [self getBoolValue:[dict objectForKey:@"resume_count"]];
    
    if ((NSObject *)self.regtime != [NSNull null] && self.regtime.length > 10) {
        self.regtime = [self.regtime substringToIndex:7];
        self.regtime = [self.regtime stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    
    if ((NSObject *)self.birthday != [NSNull null] && self.birthday.length > 10) {
        self.birthday = [self.birthday substringToIndex:10];
        self.birthday = [self.birthday stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    }
    //
    {
        if (self.certificationArray == nil) {
            self.certificationArray = [[NSMutableArray alloc] init];
        }
        if ([dict objectForKey:@"certification"]) {
            NSArray *array = [dict objectForKey:@"certification"];
            [self.certificationArray addObjectsFromArray:array];
        }
    }
    //
    {
        if (self.preferences == nil) {
            self.preferences = [[NSMutableArray alloc] init];
        }
        if ([dict objectForKey:@"preferences"]) {
            NSArray *array = [dict objectForKey:@"preferences"];
            [self.preferences addObjectsFromArray:array];
        }
    }
    //
    {
        if (self.educationArray == nil) {
            self.educationArray = [[NSMutableArray alloc] init];
        }
        if ([dict objectForKey:@"education"]) {
            NSArray *array = [dict objectForKey:@"education"];
            [self.educationArray addObjectsFromArray:array];
        }
    }
    //
    {
        if (self.experienceArray == nil) {
            self.experienceArray = [[NSMutableArray alloc] init];
        }
        if ([dict objectForKey:@"experience"]) {
            NSArray *array = [dict objectForKey:@"experience"];
            [self.experienceArray addObjectsFromArray:array];
        }
    }
    //
    {
        if (self.data == nil) {
            self.data = [[NSMutableArray alloc] init];
        }
        NSArray *array = [dict objectForKey:@"data"];
        for (int i=0; i<array.count; i++) {
            SectionDTO *dto = [[SectionDTO alloc] init:[array objectAtIndex:i]];
            [self.data addObject:dto];
        }
    }
    //
    {
        if (self.network == nil) {
            self.network = [[NSMutableArray alloc] init];
        }
        NSArray *array = [dict objectForKey:@"network"];
        for (int i=0; i<array.count; i++) {
            PairDTO *dto = [[PairDTO alloc] init:[array objectAtIndex:i]];
            [self.network addObject:dto];
        }
    }
    //
    self.images = [dict objectForKey:@"images"];
    //
    {
        if (self.phones == nil) {
            self.phones = [[NSMutableArray alloc] init];
        }
    }
    //普通标签
    {
        if (self.user_tags == nil) {
            self.user_tags = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"user_tags"] != [NSNull null] && [dict objectForKey:@"user_tags"] != nil) {
            NSArray *array = [dict objectForKey:@"user_tags"];
            [self.user_tags addObjectsFromArray:array];
        }
    }
    //学术标签
    {
        if (self.academic_tags == nil) {
            self.academic_tags = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"academic_tags"] != [NSNull null] && [dict objectForKey:@"academic_tags"] != nil) {
            NSArray *array = [dict objectForKey:@"academic_tags"];
            [self.academic_tags addObjectsFromArray:array];
        }
    }
    
    if (rawInfo == nil) {
        rawInfo = [[NSMutableDictionary alloc] init];
    }
    [rawInfo removeAllObjects];
    [rawInfo addEntriesFromDictionary:dict];
    return tf;
}

- (BOOL)parse2:(NSDictionary *)dict
{
    BOOL tf = YES;
    //
    self.name = [self getStrValue:[dict objectForKey:@"name"]];
    self.userID = [NSString stringWithFormat:@"%@", @([self getIntValue:[dict objectForKey:@"id"]])];
    self.relation = [self getIntValue:[dict objectForKey:@"relation"]];
    {
        if (self.phones == nil) {
            self.phones = [[NSMutableArray alloc] init];
        }
        NSArray *phones = [dict objectForKey:@"phones"];
        if (phones == nil) {
            phones = [dict objectForKey:@"phones_encrypted"];
            self.isEncrypted = YES;
        }
        [self.phones addObjectsFromArray:phones];
    }

    NSArray *matchUsers = [dict objectForKey:@"matched_users"];
    for (int i=0; i<matchUsers.count; i++) {
        NSDictionary *user = [matchUsers objectAtIndex:i];
        BOOL isFriend = [[user objectForKey:@"is_friend"] boolValue];
        if (isFriend) {
            self.isFriend = isFriend;
            break;
        }
        self.userID = [NSString stringWithFormat:@"%@", @([[user objectForKey:@"id"] integerValue])];
    }
    if (self.userID == nil) {
        self.userID = @"";
    }
    if (rawInfo == nil) {
        rawInfo = [[NSMutableDictionary alloc] init];
    }
    [rawInfo removeAllObjects];
    [rawInfo addEntriesFromDictionary:dict];
    //
    return tf;
}

- (BOOL)isAnonymous
{
    return (self.userID.longLongValue > 9000000000);
}

@end
