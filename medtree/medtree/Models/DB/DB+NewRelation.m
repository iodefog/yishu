//
//  DB+NewRelation.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+NewRelation.h"
#import "JSONKit.h"
#import "UserDTO.h"
#import "MessageDTO.h"
#import "NotificationDTO.h"
#import "DateUtil.h"

@implementation DB (NewRelation)

- (void)createTable_NewRelation
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    type INTETER, \
    status INTETER, \
    info TEXT, \
    time timestamp, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"new_relation" arguments:sql];
}

- (void)insertNewRelation:(NotificationDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        [array addObject:[NSNumber numberWithInteger:dto.status]];
        [array addObject:[NSNumber numberWithInteger:dto.unread]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.time];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        NSLog(@"insertNewRelation------new_relation_DB______------------%@---------",[[dto JSON] JSONString]);
        NSString *sql = @"INSERT INTO new_relation (userid, type, status, info, time, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"new_relation insert error");
    }];
}

- (void)deleteNewRelation:(NotificationDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        
        NSString *sql = @"DELETE FROM new_relation WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"new_relation delete error");
    }];
}

- (void)deleteAllNewRelation
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM new_relation";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all new_relation delete error");
    }];
}

- (void)updateNewRelation:(NotificationDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:dto.status]];
        [array addObject:[NSNumber numberWithInteger:dto.unread]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.time];
        [array addObject:dto.userID];
        NSLog(@"updateNewRelation------new_relation_DB______------------%@---------",[[dto JSON] JSONString]);
        NSString *sql = @"UPDATE new_relation SET type=?, status=?, info=?, time=? WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"new_relation update error");
    }];
}

- (NSArray *)selectNewRelationIDs
{
    NSMutableArray *data = [NSMutableArray array];
    //
    NSString *sql = @"SELECT userid FROM new_relation";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"userid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllNewRelations:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT type, info, time FROM new_relation ORDER BY time DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSInteger type = [[rs stringForColumn:@"type"] integerValue];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSDate *time = [DateUtil convertTimeFromNumber:[NSNumber numberWithLongLong:[[rs stringForColumn:@"time"] longLongValue]]];;
            if (info) {
                NotificationDTO *dto = [[NotificationDTO alloc] init:info];
                dto.status = type;
                dto.time = time;
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)markAllNotificationAsRead
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:MessageRead]];
        [array addObject:[NSNumber numberWithInteger:MessageUnRead]];
        
        NSString *sql = @"UPDATE new_relation SET status=? WHERE status=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"new_relation update error");
    }];
}

- (void)getAllNotificationUnreadCounts:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [NSMutableArray array];
        //
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:[NSNumber numberWithInteger:MessageUnRead]];
        
        NSString *sql = @"SELECT COUNT(*) AS count FROM new_relation WHERE status=?";
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            [data addObject:[NSNumber numberWithInteger:count]];
        }
        [rs close];
        //
        result(data);
    }];
}

@end
