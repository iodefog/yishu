//
//  DB+Event.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Event.h"
#import "JSONKit.h"
#import "EventDTO.h"

@implementation DB (Event)

- (void)createTable_Event
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    eventid TEXT, \
    time timestamp, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"event" arguments:sql];
}

- (void)insertEvent:(EventDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.sysid];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO event (eventid, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Event insert error");
    }];
}

- (void)updateEvent:(EventDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.sysid];
        
        NSString *sql = @"UPDATE event SET info=? WHERE eventid=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Event update error");
    }];
}

- (void)deleteAllEvent
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM event";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all event delete error");
    }];
}

- (void)deleteEvent:(EventDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.sysid];
        
        NSString *sql = @"DELETE FROM event WHERE eventid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Event delete error");
    }];
}

- (NSArray *)selectEventIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT eventid FROM event ORDER BY time DESC";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"eventid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllEvents:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT info FROM event ORDER BY time DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                EventDTO *dto = [[EventDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
