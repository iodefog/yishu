//
//  JobApplyDTO.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "JobApplyDTO.h"

@implementation JobApplyDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.applyID = [self getStrValue:dict[@"id"]];
    self.organization = [self getStrValue:dict[@"enterprise_name"]];
    self.avater = [self getStrValue:dict[@"logo"]];
    self.city = [self getStrValue:dict[@"city"]];
    self.positionId = [self getStrValue:dict[@"position_id"]];
    self.jobTitle = [self getStrValue:dict[@"position_name"]];
    self.salary = [self getSalary:[self getIntValue:dict[@"salary"]]];
    self.applyResult = (ApplyResult)[self getIntValue:dict[@"status"]];
    self.checked = [self getBoolValue:dict[@"checked"]];
    NSTimeInterval time = [self getDoubleValue:dict[@"timestamp"]];
    self.update = [NSDate dateWithTimeIntervalSince1970:time];
    
    self.jobUpdate = [NSDate dateWithTimeIntervalSince1970:[self getDoubleValue:dict[@"update_time"]]];
    self.degree = (DegreeTypes)[self getIntValue:dict[@"education"]];
    self.orginType = (UnitNatureTypes)[self getIntValue:dict[@"type"]];
    self.orginScale = (UnitSizeTypes)[self getIntValue:dict[@"scale"]];
    self.orginLevel = (UnitLevelTypes)[self getIntValue:dict[@"level"]];
    self.welfare = [self getStrValue:dict[@"welfare"]];
    return YES;
}

- (NSString *)getSalary:(NSInteger)type
{
    if (type == 1) {
        return @"2k以上";
    } else if (type == 2) {
        return @"4k以上";
    } else if (type == 3) {
        return @"6k以上";
    } else if (type == 4) {
        return @"10k以上";
    } else if (type == 5) {
        return @"20k以上";
    } else {
        return @"面议";
    }
}

@end
