//
//  ActionDTO.m
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ActionDTO.h"
#import "DateUtil.h"

@implementation ActionDTO

+ (ActionDTO *)genAction:(NSInteger)action attr:(NSString *)attr
{
    ActionDTO *dto = [[ActionDTO alloc] init];
    dto.action = [NSString stringWithFormat:@"%@", @(action)];
    dto.data = attr == nil ? @"" : attr;
    dto.start_time = [NSDate new];
    return dto;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{action:%@ data:%@ start_time:%@", self.action, self.data, self.start_time];
}

@end
