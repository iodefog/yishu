//
//  ResumeDTO.m
//  medtree
//
//  Created by 边大朋 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "ResumeDTO.h"
#import "ExperienceDTO.h"
#import <DateUtil.h>

@implementation ResumeDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.resumeId = [self getStrValue:dict[@"id"]];
    self.userId = [self getStrValue:dict[@"user_id"]];
    self.avater = [self getStrValue:dict[@"photo"]];
    self.name = [self getStrValue:dict[@"real_name"]];
    self.resumeName = [self getStrValue:dict[@"resume_name"]];
    self.gender = (Gender_Types)[self getIntValue:dict[@"gender"]];
    self.birthProvince = [self getStrValue:dict[@"birth_province"]];
    NSString *birth = [self getStrValue:dict[@"birthday"]];
    self.birthday = [DateUtil convertTime:birth];
    self.mobile = [self getStrValue:dict[@"mobile"]];
    self.liveProvince = [self getStrValue:dict[@"live_province"]];
    self.workExperience = (WorkExperienceType)[self getIntValue:dict[@"work_experience"]];
    self.privacy = [self getBoolValue:dict[@"privacy"]];
    self.hobby = [self getStrValue:dict[@"interest"]];
    self.introduction = [self getStrValue:dict[@"self_introduction"]];
    self.honor = [self getStrValue:dict[@"honor"]];
    self.workList = [self getArrayValue:dict[@"work"]];
    self.eduList = [self getArrayValue:dict[@"education"]];
    
    return YES;
}

- (NSString *)workExperienceStr
{
    switch (self.workExperience) {
        case WorkExperienceTypeOverOne:
            return @"1年以内";
        case WorkExperienceTypeOverTwo:
            return @"1～3年";
        case WorkExperienceTypeOverThree:
            return @"3～5年";
        case WorkExperienceTypeOverFive:
            return @"5～10年";
        case WorkExperienceTypeOverTen:
            return @"10年以上";
        default:
            return @"待完善";
            break;
    }
}

- (NSArray *)workList
{
    if (!_workList) {
        _workList = [[NSArray alloc] init];
    }
    return _workList;
}

- (NSArray *)eduList
{
    if (!_eduList) {
        _eduList = [[NSArray alloc] init];
    }
    return _eduList;
}

@end
