//
//  DB+NewCount.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+NewCount.h"
#import "JSONKit.h"
#import "UserDTO.h"
#import "MessageDTO.h"
#import "NewCountDTO.h"
#import "DateUtil.h"

@implementation DB (NewCount)

- (void)createTable_NewCount
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    key TEXT, \
    info TEXT, \
    type INTETER, \
    status INTETER, \
    time timestamp, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"new_count" arguments:sql];
}

- (void)insertNewCount:(NewCountDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = @"SELECT status FROM new_count WHERE key=?";
        FMResultSet *rs = [db executeQuery:selectSql withArgumentsInArray:@[dto.key]];
        NSInteger count = 0;
        if ([rs next]) {
            count = [rs intForColumn:@"status"];
        }
        [rs close];
        if (count < dto.unread) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:dto.key];
            [array addObject:[[dto JSON] JSONString]];
            [array addObject:[NSNumber numberWithInteger:dto.type]];
            [array addObject:[NSNumber numberWithInteger:dto.unread]];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@""];
            
            NSString *sql = @"INSERT INTO new_count (key, info, type, status, time, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
            if (!isOK) NSLog(@"new_count insert error");
        }
    }];
}

- (void)deleteNewCountDTO:(NewCountDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.key];
        
        NSString *sql = @"DELETE FROM new_count WHERE key=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"new_count delete error");
    }];
}

- (void)updateNewCount:(NewCountDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *selectSql = @"SELECT status FROM new_count WHERE key=?";
        FMResultSet *rs = [db executeQuery:selectSql withArgumentsInArray:@[dto.key]];
        NSInteger count = 0;
        if ([rs next]) {
            count = [rs intForColumn:@"status"];
        }
        [rs close];
        if (count < dto.unread) {
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:[NSNumber numberWithInteger:dto.type]];
            [array addObject:[NSNumber numberWithInteger:dto.unread]];
            [array addObject:[[dto JSON] JSONString]];
            [array addObject:@""];
            [array addObject:dto.key];
            
            NSString *sql = @"UPDATE new_count SET type=?, status=?, info=?, time=? WHERE key=?";
            
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
            if (!isOK) NSLog(@"new_count update error");
        }
        
    }];
}

- (void)clearNotifyCount:(NSString *)key
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"UPDATE new_count SET status=? WHERE key=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:@[@0, key]];
        if (!isOK) NSLog(@"clearNotifyCount update error");
    }];
}

- (NSArray *)selectNewCountIDs
{
    NSMutableArray *data = [NSMutableArray array];
    //
    NSString *sql = @"SELECT key FROM new_count";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"key"]];
    }
    [rs close];
    return data;
}

- (void)selectAllNewCounts:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT info, status FROM new_count";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSInteger unread = [rs intForColumn:@"status"];
            if (info.count > 0) {
                NewCountDTO *dto = [[NewCountDTO alloc] init:info];
                dto.unread = unread;
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (NSInteger)getAllNotifyCount
{
    NSString *sql = @"SELECT SUM(status) FROM new_count";
    FMResultSet *rs = [database executeQuery:sql];
    NSInteger count = 0;
    if ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    return count;
}

- (void)getNewCountByKey:(NSString *)key success:(SuccessBlock)success
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT info, status FROM new_count WHERE key = ?";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:@[key]];
        NewCountDTO *dto = nil;
        if ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSInteger unread = [rs intForColumn:@"status"];
            dto = [[NewCountDTO alloc] init:info];
            dto.unread = unread;
        }
        [rs close];
        success(dto);
    }];
}

@end
