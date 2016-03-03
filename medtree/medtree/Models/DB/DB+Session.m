//
//  DB+Session.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Session.h"
#import "JSONKit.h"
#import "MessageDTO.h"
#import "SessionDTO.h"
#import "MessageTypeProxy.h"

@implementation DB (Session)

- (void)createTable_Session
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    sessionid TEXT, \
    userid TEXT, \
    info TEXT, \
    updatetime timestamp, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"session" arguments:sql];
}

- (void)insertSession:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.sessionID];
        [array addObject:[MessageTypeProxy getTargetID:dto.toUserID with:dto.fromUserID]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.updateTime];
        [array addObject:@(dto.remoteID)];
        [array addObject:@""];
        [array addObject:@""];
        
        NSLog(@"session ---- userid --------------------- %@", array[1]);
        NSString *sql = @"INSERT INTO session (sessionid, userid, info, updatetime, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"session insert error");
    }];
}

// sync unread 调用
- (void)insertUnreadSession:(SessionDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.sessionID];
        [array addObject:dto.remoteUserID];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.updateTime];
        [array addObject:@(dto.content.remoteID)];
        [array addObject:@(dto.unreadCount)];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO session (sessionid, userid, info, updatetime, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"session insert error");
    }];
}

// pull old 、send msg
- (void)updateSession:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSArray *array = @[dto.sessionID];
        NSString *updateSQL = @"select updatetime from session where sessionid = ?";
        FMResultSet *rs = [db executeQuery:updateSQL withArgumentsInArray:array];
        NSDate *updatetime = [NSDate date];
        while ([rs next]) {
            updatetime = [rs dateForColumnIndex:0];
        }
        [rs close];
        
        if (updatetime.timeIntervalSince1970 < dto.updateTime.timeIntervalSince1970 || dto.remoteID == 0) {
            NSMutableArray *arrayM = [NSMutableArray array];
            [arrayM addObject:[[dto JSON] JSONString]];
            [arrayM addObject:dto.updateTime];
            [arrayM addObject:@(dto.remoteID)];
            [arrayM addObject:dto.sessionID];
            
            NSString *sql = @"UPDATE session SET info=?, updatetime=?, reverse1=?  WHERE sessionid=?";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:arrayM];
            if (!isOK) NSLog(@"session update error");
        }
    }];
}

// sync unread 调用
- (void)updateUnreadSession:(SessionDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSArray *array = @[dto.sessionID];
        NSString *updateSQL = @"select reverse1 from session where sessionid = ?";
        FMResultSet *rs = [db executeQuery:updateSQL withArgumentsInArray:array];
        NSInteger remoteID = 0;
        while ([rs next]) {
            remoteID = [[rs stringForColumnIndex:0] integerValue];
        }
        [rs close];
        
        if (remoteID < dto.content.remoteID) {
            NSMutableArray *arrayM = [NSMutableArray array];
            [arrayM addObject:[[dto JSON] JSONString]];
            [arrayM addObject:dto.updateTime];
            [arrayM addObject:@(dto.content.remoteID)];
            [arrayM addObject:@(dto.unreadCount)];
            [arrayM addObject:dto.sessionID];
            
            NSString *sql = @"UPDATE session SET info=?, updatetime=?, reverse1=?, reverse2=? WHERE sessionid=?";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:arrayM];
            if (!isOK) NSLog(@"session update error");
        }
    }];
}

// 更新发送后的消息的remoteId
- (void)updateSessionRemoteId:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *arrayM = [NSMutableArray array];
        [arrayM addObject:dto.updateTime];
        [arrayM addObject:@(dto.remoteID)];
        [arrayM addObject:dto.sessionID];
        [arrayM addObject:@0];
        
        NSString *sql = @"UPDATE session SET updatetime=?, reverse1=? WHERE sessionid=? AND reverse1=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:arrayM];
        if (!isOK) NSLog(@"session update error");
    }];
}

// 清除未读消息数
- (void)clearUnreadCount:(NSString *)sessionID
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *array = @[sessionID];
        NSString *updateSQL = @"select info from session where sessionid = ?";
        FMResultSet *rs = [db executeQuery:updateSQL withArgumentsInArray:array];
        NSDictionary *info = nil;
        while ([rs next]) {
           info  = [[rs stringForColumn:@"info"] objectFromJSONString];
        }
        [rs close];
        if (info) {
            [info setValue:@0 forKey:@"count"];
            NSMutableArray *arrayM = [NSMutableArray array];
            [arrayM addObject:[info JSONString]];
            [arrayM addObject:@0];
            [arrayM addObject:sessionID];
            NSString *sql = @"UPDATE session SET info=?, reverse2=? WHERE sessionid=?";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:arrayM];
            if (!isOK) NSLog(@"session update error");
        }
    }];
}

- (void)deleteSession:(SessionDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.sessionID];
        
        NSString *sql = @"DELETE FROM session WHERE sessionid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"session delete error");
    }];
}

- (NSArray *)selectSessionIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT sessionid FROM session";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"sessionid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllSessions:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT sessionid, userid, info, updatetime FROM session ORDER BY updatetime DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *sessionid = [rs stringForColumn:@"sessionid"];
            NSString *userid = [rs stringForColumn:@"userid"];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSDate *updateTime = [rs dateForColumn:@"updatetime"];
            if (info) {
                SessionDTO *dto = [[SessionDTO alloc] init:info];
                if (dto.remoteUserID.length == 0) {
                    dto.remoteUserID = userid;
                    dto.sessionID = sessionid;
                }
                
                if (dto.updateTime.timeIntervalSince1970 == 0) {
                    dto.updateTime = updateTime;
                }

                if (dto.remoteUserID.length > 1) {
                    [data addObject:dto];
                }
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (NSInteger)getAllUnreadCount
{
    NSString *sql = @"SELECT SUM(reverse2) FROM session";
    FMResultSet *rs = [database executeQuery:sql];
    NSInteger count = 0;
    if ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    return count;
}

@end
