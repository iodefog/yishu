//
//  DBEventFeed.m
//  medtree
//
//  Created by 边大朋 on 15-5-11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+EventFeed.h"
#import "FeedDTO.h"
#import "JSONKIT.h"

@implementation DB (EventFeed)
- (void)createTable_EventFeed
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    feedid TEXT, \
    time timestamp, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"event_feed" arguments:sql];
}

- (void)insertEventFeed:(FeedDTO *)dto eventId:(NSString *)eventId
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.feed_id];
        [array addObject:(dto.feed_time ? dto.feed_time : @"")];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:eventId];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO event_feed (feedid, time, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed insert error");
    }];
}

- (void)updateEventFeed:(FeedDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.feed_time];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.feed_id];
        
        NSString *sql = @"UPDATE event_feed SET time, info=? WHERE feedid=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed update error");
    }];
}

- (void)deleteEventFeed:(FeedDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.feed_id];
        
        NSString *sql = @"DELETE FROM event_feed WHERE feedid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed delete error");
    }];
}

- (void)deleteEventAllFeed
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM event_feed";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all feed delete error");
    }];
}

- (NSArray *)selectEventFeedIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT feedid FROM event_feed ORDER BY time DESC";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"feedid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllEventFeedsWithId:(NSString *)eventId block:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:eventId];
    
        NSString *sql = @"SELECT info FROM event_feed WHERE reverse1 = ? ORDER BY time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                FeedDTO *dto = [[FeedDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)deleteAllEventFeed
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM event_feed";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all event feed delete error");
    }];
}


@end
