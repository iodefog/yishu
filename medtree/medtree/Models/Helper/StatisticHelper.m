//
//  StatisticHelper.m
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "StatisticHelper.h"
#import "StatisticManager.h"
#import "ActionDTO.h"
#import "MessageDTO.h"
#import "MoodManager.h"
#import "MedGlobal.h"
#import "MessageManager.h"
#import "AccountHelper.h"
#import "IMUtil.h"
#import "UserDTO.h"
#import "DateUtil.h"

@implementation StatisticHelper

+ (id)shareInstance
{
    static StatisticHelper *helper = nil;
    if (helper == nil) {
        helper = [[StatisticHelper alloc] init];
    }
    return helper;
}

+ (void)startTimer
{
    StatisticHelper *instance = [StatisticHelper shareInstance];
    [instance startTimer];
}

- (void)startTimer
{
    if ([[AccountHelper getAccount] userID].length == 0) {
        return;
    }
    
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

+ (void)closeTimer
{
    StatisticHelper *instane = [StatisticHelper shareInstance];
    [instane closeTimer];
}

- (void)closeTimer
{
    if ([timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerFired:(NSTimer *)timerFired
{
    /*
    [StatisticManager getStatistic:nil success:^(id JSON) {
        NSArray *array = (NSArray *)JSON;
        if (array.count > 0) {
            dispatch_async([MedGlobal getNetQueue], ^{
                [StatisticManager sendStatistic:@{@"data": array} success:^(id JSON) {
                    
                } failure:^(NSError *error, id JSON) {
                    
                }];
            });
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    [StatisticHelper getCertificationTimeStamp:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ServiceManager getData:@{@"method": [NSNumber numberWithInteger:MethodType_Certification], @"timestamp":JSON?JSON:[NSNumber numberWithInt:0]} success:^(id JSON) {
                if ([[JSON objectForKey:@"success"] boolValue]) {
                    if ([[JSON objectForKey:@"code"] boolValue]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [AccountHelper getUserInfo];
                            [StatisticHelper setCertificationTimeStampInfo:@{@"CertificationTimeStamp":[DateUtil convertNumberFromTime1000:[NSDate date]]} key:@"CertificationTimeStamp"];
                            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
                        });
                    }
                }
            } failure:^(NSError *error, id JSON) {
                
            }];
        });
    } key:@"CertificationTimeStamp"];

    [MoodManager uploadMoodDate];
     */
}

+ (void)getCertificationTimeStamp:(SuccessBlock)success key:(NSString *)key
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success ([dataDict objectForKey:key]);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

+ (void)setCertificationTimeStampInfo:(NSDictionary *)dict key:(NSString *)key
{
    DTOBase *dto = [[DTOBase alloc] init:dict];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":key,@"info":dto} success:^(id JSON) {
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)checkUnRead
{
    [self timerFired:nil];
}

+ (void)addAction:(Statistic_Action)action attr:(NSString *)attr
{
    [StatisticManager addAction:[ActionDTO genAction:action attr:attr]];
}

@end
