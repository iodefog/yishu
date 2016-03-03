//
//  DB+Mood.m
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB+Mood.h"
#import "MoodDTO.h"
#import "JSONKit.h"

@implementation DB (Mood)

- (void)createTable_User_Mood
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    mood_time TEXT, \
    mood_id TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"user_mood" arguments:sql];
}

- (void)insertUserMood:(MoodDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.user_id];
        [array addObject:dto.mood_time];
        [array addObject:dto.mood_id];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithBool:dto.isPost]];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO user_mood (userid, mood_time, mood_id, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_mood insert error");
    }];
}

- (void)updateUserMood:(MoodDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithBool:dto.isPost]];
        [array addObject:dto.mood_id];
        [array addObject:dto.mood_time];
        
        NSString *sql = @"UPDATE user_mood SET info=?,reverse1=?,mood_id=? WHERE mood_time=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_mood update error");
    }];
}

- (void)updateUserMoodWithTime:(MoodDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.mood_time];
        [array addObject:[NSNumber numberWithBool:dto.isPost]];
        [array addObject:dto.mood_time];
        
        NSString *sql = @"UPDATE user_mood SET info=?,mood_time=?,reverse1=? WHERE mood_time=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_mood update error");
    }];
}

- (void)deleteUserMood:(MoodDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.mood_id];
        
        NSString *sql = @"DELETE FROM user_mood WHERE mood_id=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_mood delete error");
    }];
}

- (void)deleteUserMoodWithTime:(MoodDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.mood_time];
        
        NSString *sql = @"DELETE FROM user_mood WHERE mood_time=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_mood delete error");
    }];
}

- (MoodDTO *)convertMoodDTO:(FMResultSet *)rs
{
    NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
    //
    MoodDTO *dto = [[MoodDTO alloc] init:info];
    return dto;
}

- (void)selectMoodResult:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT rowid, userid, mood_time, info FROM user_mood ORDER BY mood_time DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertMoodDTO:rs]];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectMoodWithID:(ArrayBlock)result dto:(MoodDTO *)dto
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.mood_id];
        //
        NSString *sql = @"SELECT rowid, userid, mood_time, info FROM user_mood WHERE mood_id=? ORDER BY mood_time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertMoodDTO:rs]];
                break;
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectMoodWithTime:(ArrayBlock)result time:(NSDate *)time
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:time];
        //
        NSString *sql = @"SELECT rowid, userid, mood_time, info FROM user_mood WHERE mood_time=? ORDER BY mood_time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertMoodDTO:rs]];
                break;
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectMoodWithNotPost:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithBool:NO]];
        //
        NSString *sql = @"SELECT rowid, userid, mood_time, info FROM user_mood WHERE reverse1=? ORDER BY mood_time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertMoodDTO:rs]];
                break;
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
