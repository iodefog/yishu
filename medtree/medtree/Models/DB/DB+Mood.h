//
//  DB+Mood.h
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB.h"

@class MoodDTO;

@interface DB (Mood)

- (void)createTable_User_Mood;
- (void)insertUserMood:(MoodDTO *)dto;
- (void)updateUserMood:(MoodDTO *)dto;
- (void)updateUserMoodWithTime:(MoodDTO *)dto;
- (void)deleteUserMood:(MoodDTO *)dto;
- (void)deleteUserMoodWithTime:(MoodDTO *)dto;
- (void)selectMoodResult:(ArrayBlock)result;
- (void)selectMoodWithID:(ArrayBlock)result dto:(MoodDTO *)dto;
- (void)selectMoodWithTime:(ArrayBlock)result time:(NSDate *)time;
- (void)selectMoodWithNotPost:(ArrayBlock)result;

@end
