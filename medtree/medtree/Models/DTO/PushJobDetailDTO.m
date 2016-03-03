//
//  PushJobDetailDTO.m
//  medtree
//
//  Created by 孙晨辉 on 15/12/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "PushJobDetailDTO.h"
#import <DateUtil.h>

@implementation PushJobDetailDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.jobId = [self getStrValue:dict[@"id"]];
    self.jobName = [self getStrValue:dict[@"name"]];
    self.enterpriseName = [self getStrValue:dict[@"enterprise_name"]];
    self.jobTitle = [self getStrValue:dict[@"title"]];
    self.url = [self getStrValue:dict[@"url"]];
    self.enterpriseLogo = [self getStrValue:dict[@"enterprise_logo"]];
    self.enterpriseType = (UnitNatureTypes)[self getIntValue:dict[@"enterprise_type"]];
    self.enterpriseSacle = (UnitSizeTypes)[self getIntValue:dict[@"enterprise_scale"]];
    self.enterpriseLevel = (UnitLevelTypes)[self getIntValue:dict[@"enterprise_level"]];
    self.salary = (SalaryTypes)[self getIntValue:dict[@"salary"]];
    self.degree = (DegreeTypes)[self getIntValue:dict[@"education"]];
    self.province = [self getStrValue:dict[@"province"]];
    NSTimeInterval time = [self getDoubleValue:dict[@"timestamp"]];
    self.timestamp = [DateUtil getDisplayTime:[NSDate dateWithTimeIntervalSince1970:time]];
    self.shareInfo = [self getStrValue:dict[@"welfare"]];
    
    return YES;
}

@end
