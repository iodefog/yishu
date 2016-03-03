//
//  DB+Mood.m
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB+Mood.h"
#import "ActionDTO.h"
#import "JSONKit.h"

@implementation DB (UserAction)

- (void)createTable_User_Action
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    action TEXT, \
    data TEXT, \
    start_time timestamp, \
    elapsed_time timestamp, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"user_action" arguments:sql];
}

- (void)insertAction:(ActionDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.action];
        [array addObject:dto.data == nil ? @"" : dto.data];
        [array addObject:dto.start_time];
//        [array addObject:dto.elapsed_time];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO user_action (action, data, start_time, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_action insert error");
    }];
}

- (void)deleteActionBefore:(NSDate *)time
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:time];
        
        NSString *sql = @"DELETE FROM user_action WHERE start_time <= ?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user_action delete error");
    }];
}

- (void)selectActions:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT rowid, action, data, start_time FROM user_action ORDER BY start_time LIMIT 0, 50";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:nil];
        while ([rs next]) {
            ActionDTO *dto = [[ActionDTO alloc] init];
            dto.action = [rs stringForColumn:@"action"];
            dto.data = [rs stringForColumn:@"data"];
            dto.start_time = [rs dateForColumn:@"start_time"];
            [data addObject:dto];
        }
        [rs close];
        //
        result(data);
    }];
}

@end
