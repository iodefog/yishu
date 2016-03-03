//
//  DB+Feed.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Feed.h"
#import "JSONKit.h"
#import "FeedDTO.h"

@implementation DB (Feed)

- (void)createTable_Feed
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    feedid TEXT, \
    time timestamp, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"feed" arguments:sql];
}

- (void)insertFeed:(FeedDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.feed_id];
        [array addObject:(dto.feed_time ? dto.feed_time : @"")];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO feed (feedid, time, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed insert error");
    }];
}

- (void)updateFeed:(FeedDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:(dto.feed_time ? dto.feed_time : @"")];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.feed_id];
        
        NSString *sql = @"UPDATE feed SET time, info=? WHERE feedid=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed update error");
    }];
}

- (void)deleteFeed:(FeedDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.feed_id];
        
        NSString *sql = @"DELETE FROM feed WHERE feedid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"feed delete error");
    }];
}

- (void)deleteAllFeed
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM feed";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all feed delete error");
    }];
}

- (NSArray *)selectFeedIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT feedid FROM Feed ORDER BY time DESC";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"feedid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllFeeds:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT info FROM feed ORDER BY time DESC";
        FMResultSet *rs = [db executeQuery:sql];
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

@end
