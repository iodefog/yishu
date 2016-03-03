//
//  MoodDTO.m
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MoodDTO.h"
#import "DateUtil.h"

@implementation MoodDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.user_id = [NSString stringWithFormat:@"%0.0f", [[dict objectForKey:@"user_id"] doubleValue]];
    self.user_avatar = [self getStrValue:[dict objectForKey:@"user_avatar"]];
    self.user_name = [self getStrValue:[dict objectForKey:@"user_name"]];
    self.mood_id = [NSString stringWithFormat:@"%0.0f", [[dict objectForKey:@"mood_id"] doubleValue]];
    self.emotion = [self getIntValue:[dict objectForKey:@"emotion"]];
    self.weather = [self getIntValue:[dict objectForKey:@"weather"]];
    self.isPost = [self getIntValue:[dict objectForKey:@"isPost"]];
    NSString *time = [DateUtil convertToDay:[DateUtil convertTime:[dict objectForKey:@"mood_time"]]];
    self.mood_time = [DateUtil convertTime:[NSString stringWithFormat:@"%@ 00:00:00",time]];
    self.surgery_count = [self getIntValue:[dict objectForKey:@"surgery_count"]];
    self.patient_count = [self getIntValue:[dict objectForKey:@"patient_count"]];
    self.mood_content = [self getStrValue:[dict objectForKey:@"content"]];
    //
    {
        if (self.images == nil) {
            self.images = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
            NSArray *array = [dict objectForKey:@"images"];
            [self.images addObjectsFromArray:array];
        }
    }
    //
    {
        if (self.actions == nil) {
            self.actions = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"actions"] != [NSNull null] && [dict objectForKey:@"actions"] != nil) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"actions"]];
            if (array.count > 1) {
                //排序
                for (int i = 0; i < array.count-1; i++) {
                    for (int j = 0; j < array.count-1-i; j++) {
                        if ([[array objectAtIndex:j] integerValue] > [[array objectAtIndex:j+1] integerValue]) {
                            NSNumber *tmp = [array objectAtIndex:j];
                            [array replaceObjectAtIndex:j withObject:[array objectAtIndex:j+1]];
                            [array replaceObjectAtIndex:j+1 withObject:tmp];
                        }
                    }
                }
            }
            [self.actions addObjectsFromArray:array];
        }
    }
    
    return YES;
}

@end

@implementation MoodThemeDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.mood_time = [DateUtil convertTime:[dict objectForKey:@"mood_time"]];
    self.surgery_count = [self getIntValue:[dict objectForKey:@"surgery_count"]];
    self.patient_count = [self getIntValue:[dict objectForKey:@"patient_count"]];
    //
    {
        if (self.actions == nil) {
            self.actions = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"actions"] != [NSNull null] && [dict objectForKey:@"actions"] != nil) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dict objectForKey:@"actions"]];
            if (array.count > 1) {
                //排序
                for (int i = 0; i < array.count-1; i++) {
                    for (int j = 0; j < array.count-1-i; j++) {
                        if ([[array objectAtIndex:j] integerValue] < [[array objectAtIndex:j+1] integerValue]) {
                            NSNumber *tmp = [array objectAtIndex:j];
                            [array replaceObjectAtIndex:j withObject:[array objectAtIndex:j+1]];
                            [array replaceObjectAtIndex:j+1 withObject:tmp];
                        }
                    }
                }
            }
            [self.actions addObjectsFromArray:array];
        }
    }
    return YES;
}

@end

@implementation MoodContentDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.mood_time = [DateUtil convertTime:[dict objectForKey:@"mood_time"]];
    self.mood_content = [self getStrValue:[dict objectForKey:@"content"]];
    //
    {
        if (self.images == nil) {
            self.images = [[NSMutableArray alloc] init];
        }
        if ((NSObject *)[dict objectForKey:@"images"] != [NSNull null] && [dict objectForKey:@"images"] != nil) {
            NSArray *array = [dict objectForKey:@"images"];
            [self.images addObjectsFromArray:array];
        }
    }
    return YES;
}

@end

@implementation MoodImageDTO

- (BOOL)parse:(NSDictionary *)dict
{
    self.mood_time = [DateUtil convertTime:[dict objectForKey:@"mood_time"]];
    self.photoID = [self getStrValue:[dict objectForKey:@"photoID"]];
    return YES;
}

@end
