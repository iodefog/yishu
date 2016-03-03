//
//  StatisticManager.m
//  medtree
//
//  Created by 陈升军 on 14/12/17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "StatisticManager.h"
#import "ActionDTO.h"
#import "MessageDTO.h"
#import "DB+Public.h"
#import "DateUtil.h"
#import "IServices+Public.h"

#import "IMUtil.h"

@implementation StatisticManager

+ (void)getStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[DB shareInstance] selectActions:^(NSArray *array) {
        success(array);
    }];
}

+ (void)sendStatistic:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSArray *data = [param objectForKey:@"data"];
    if (data.count > 0) {
        NSDate *lastTime = nil;
        NSMutableArray *datas = [NSMutableArray array];
        for (int i=0; i<data.count; i++) {
            ActionDTO *dto = [data objectAtIndex:i];
            NSMutableString *line = [NSMutableString string];
            //
            [line appendFormat:@"%@,", dto.action];
            [line appendFormat:@"%.0f,", [[DateUtil convertNumberFromTime:dto.start_time] doubleValue]];
            [line appendFormat:@"%.0f,", [[DateUtil convertNumberFromTime:dto.elapsed_time] doubleValue]];
            [line appendFormat:@"%@", dto.data];
            //
            [datas addObject:line];
            if (i == data.count-1) {
                lastTime = dto.start_time;
            }
        }
        
        [IServices sendStatistic:@{@"data": datas} success:^(id JSON) {
            [[DB shareInstance] deleteActionBefore:lastTime];
        } failure:^(NSError *error, id JSON) {
            
        }];
        
    }
    success(nil);
}

+ (void)addAction:(ActionDTO *)dto
{
    [[DB shareInstance] insertAction:dto];
}

@end
