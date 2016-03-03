//
//  DB+Message.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Message.h"
#import "JSONKit.h"
#import "MessageDTO.h"

@implementation DB (Message)

- (void)createTable_Message
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    status INTETER, \
    sessionid TEXT, \
    messageid TEXT, \
    info TEXT, \
    createTime timestamp, \
    updateTime timestamp, \
    remoteid INTEGER, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"message_im" arguments:sql];
}

- (void)insertMessage:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:dto.status]];
        [array addObject:dto.sessionID];
        [array addObject:dto.messageID];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.createTime];
        [array addObject:dto.updateTime];
        [array addObject:dto.remoteToID ? dto.remoteToID : @""];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@(dto.remoteID)];
        NSString *sql = @"";
        if (dto.remoteID == 0) {
            sql = @"INSERT INTO message_im (status, sessionid, messageid, info, createTime, updateTime, reverse1, reverse2, reverse3, remoteid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
            if (!isOK) NSLog(@"Message insert error");
        } else {
            [array addObject:dto.sessionID];
            NSArray *args = @[dto.sessionID, @(dto.remoteID)];
            NSString *select = @"SELECT remoteid FROM message_im WHERE sessionid = ? AND remoteid = ?";
            FMResultSet *rs = [db executeQuery:select withArgumentsInArray:args];
            if (![rs next]) {
                sql = @"INSERT INTO message_im (status, sessionid, messageid, info, createTime, updateTime, reverse1, reverse2, reverse3, remoteid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
                if (!isOK) NSLog(@"Message insert error");
            }
            [rs close];
        }
    }];
}

/** 更新数据状态 */
- (void)updateMessageStatus:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.updateTime];
        [array addObject:@(dto.status)];
        [array addObject:@(dto.remoteID)];  // 每个对话唯一并按顺序排序
        [array addObject:dto.messageID];
        [array addObject:dto.sessionID];
        
        NSString *sql = @"UPDATE message_im SET updateTime=?, status=?, remoteid=? WHERE messageid=? AND sessionid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message update error");
    }];
}

- (void)updateMessage:(MessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.updateTime];
        [array addObject:@(dto.status)];
        [array addObject:@(dto.remoteID)];  // 每个对话唯一并按顺序排序
        [array addObject:dto.messageID];
        [array addObject:dto.sessionID];
        [array addObject:dto.toID];
        
        NSString *sql = @"UPDATE message_im SET info=?, updateTime=?, status=?, remoteid=? WHERE messageid=? AND sessionid=? AND reverse1=?";

        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message update error");
    }];
}

#pragma mark - pull new lastest 消息存储
- (void)insertLastestMessages:(NSArray *)messages success:(SuccessBlock)success
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL insertSuccess = NO;
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"msg_id" ascending:YES];
        NSArray *data = [messages sortedArrayUsingDescriptors:@[sort]];
        for (NSDictionary *dict in data) {
            MessageDTO *dto = [[MessageDTO alloc] init:dict];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:[NSNumber numberWithInteger:dto.status]];
            [array addObject:dto.sessionID];
            [array addObject:dto.messageID];
            [array addObject:[[dto JSON] JSONString]];
            [array addObject:[NSDate date]];
            [array addObject:dto.updateTime];
            [array addObject:dto.remoteToID ? dto.remoteToID : @""];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@(dto.remoteID)];
            NSArray *args = @[dto.sessionID, dto.messageID];
            NSString *select = @"SELECT remoteid FROM message_im WHERE sessionid = ? AND messageid = ?";
            NSLog(@"messageid -1----- %@", dto.messageID);
            FMResultSet *rs = [db executeQuery:select withArgumentsInArray:args];
            if (![rs next]) {
                NSString *sql = @"INSERT INTO message_im (status, sessionid, messageid, info, createTime, updateTime, reverse1, reverse2, reverse3, remoteid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
                NSLog(@"2 ---------- 1");
                if (!isOK) {
                    NSLog(@"Message insert error");
                } else {
                    insertSuccess = YES;
                }
            } else {
                NSString *sql = @"UPDATE message_im SET status = ?, remoteid = ? WHERE sessionid = ? AND messageid = ?";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:@[@(dto.status), @(dto.remoteID), dto.sessionID, dto.messageID]];
                NSLog(@"2 ---------- 2");
                if (!isOK) {
                    NSLog(@"Message insert error");
                }
            }
            [rs close];
        }
        if (insertSuccess) {
            if (success) {
                success(nil);
            }
        }
    }];
}

#pragma mark - pull old lastest 消息存储
- (void)insertOldMessages:(NSArray *)messages deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSDictionary *dict in messages) {
            MessageDTO *dto = [[MessageDTO alloc] init:dict];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:[NSNumber numberWithInteger:dto.status]];
            [array addObject:dto.sessionID];
            [array addObject:dto.messageID];
            [array addObject:[[dto JSON] JSONString]];
            NSDate *createTime = [dto.updateTime dateByAddingTimeInterval:deltaTime];
            [array addObject:createTime];
            [array addObject:dto.updateTime];
            [array addObject:dto.remoteToID ? dto.remoteToID : @""];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@(dto.remoteID)];
            NSArray *args = @[dto.sessionID, dto.messageID];
            NSString *select = @"SELECT remoteid FROM message_im WHERE sessionid = ? AND messageid = ?";
            NSLog(@"messageid -2----- %@", dto.messageID);
            FMResultSet *rs = [db executeQuery:select withArgumentsInArray:args];
            if (![rs next]) {
                NSString *sql = @"INSERT INTO message_im (status, sessionid, messageid, info, createTime, updateTime, reverse1, reverse2, reverse3, remoteid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
                NSLog(@"2 ---------- 1");
                if (!isOK) {
                    NSLog(@"Message insert error");
                }
            } else {
                NSString *sql = @"UPDATE message_im SET status = ?, remoteid = ? WHERE sessionid = ? AND messageid = ?";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:@[@(dto.status), @(dto.remoteID), dto.sessionID, dto.messageID]];
                NSLog(@"2 ---------- 2");
                if (!isOK) {
                    NSLog(@"Message insert error");
                }
            }
            [rs close];
        }
        success(nil);
    }];
}

#pragma mark - pull point lastest 消息存储
- (void)insertPointMessages:(NSArray *)messages deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSDictionary *dict in messages) {
            MessageDTO *dto = [[MessageDTO alloc] init:dict];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:[NSNumber numberWithInteger:dto.status]];
            [array addObject:dto.sessionID];
            [array addObject:dto.messageID];
            [array addObject:[[dto JSON] JSONString]];
            NSDate *createTime = [dto.updateTime dateByAddingTimeInterval:deltaTime/1000];
            [array addObject:createTime];
            [array addObject:dto.updateTime];
            [array addObject:dto.remoteToID ? dto.remoteToID : @""];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@(dto.remoteID)];
            [array addObject:dto.sessionID];
            NSArray *args = @[dto.sessionID, @(dto.remoteID)];
            NSString *select = @"SELECT remoteid FROM message_im WHERE sessionid = ? AND remoteid = ?";
            FMResultSet *rs = [db executeQuery:select withArgumentsInArray:args];
            if (![rs next]) {
                NSString *sql = @"INSERT INTO message_im (status, sessionid, messageid, info, createTime, updateTime, reverse1, reverse2, reverse3, remoteid) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
                if (!isOK) NSLog(@"Message insert error");
            }
            [rs close];
        }
        if (success) {
            success(nil);
        }
    }];
}

#pragma mark - 删除会话
- (void)deleteMessages:(NSString *)sessionID
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:sessionID];
        
        NSString *sql = @"DELETE FROM message_im WHERE sessionid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message delete error");
    }];
}

#pragma mark - 第一次获取数据 -
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:sessionID];
        
        NSString *sql = @"SELECT * FROM (SELECT * FROM message_im WHERE sessionid=? ORDER BY createTime DESC LIMIT 0,10) AS t1 ORDER BY t1.createTime ASC, t1.remoteid ASC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSString *messageid = [rs stringForColumn:@"messageid"];
            NSInteger status = [rs intForColumn:@"status"];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSInteger remoteid = [rs longForColumn:@"remoteid"];
            NSDate *updateTime = [rs dateForColumn:@"updateTime"];
            NSDate *createTime = [rs dateForColumn:@"createTime"];
            if (info) {
                MessageDTO *dto = [[MessageDTO alloc] init:info];
                dto.messageID = messageid;
                dto.status = (MessageStatus)status;
                dto.remoteID = remoteid;
                dto.updateTime = updateTime;
                dto.createTime = createTime;
                [data addObject:dto];
            }
        }
        [rs close];
        
        result(data);
    }];
}

#pragma mark - 分页获取消息列表 -
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:sessionID];
        [args addObject:createTime];
        NSString *sql = @"SELECT * FROM (SELECT * FROM message_im WHERE sessionid=? AND createTime<? ORDER BY createTime DESC limit 6) AS t1 ORDER BY t1.createTime ASC, t1.remoteid ASC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSString *messageid = [rs stringForColumn:@"messageid"];
            NSInteger status = [rs intForColumn:@"status"];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSInteger remoteid = [rs longForColumn:@"remoteid"];
            NSDate *updateTime = [rs dateForColumn:@"updateTime"];
            NSDate *createTime = [rs dateForColumn:@"createTime"];
            if (info) {
                MessageDTO *dto = [[MessageDTO alloc] init:info];
                dto.messageID = messageid;
                dto.status = (MessageStatus)status;
                dto.remoteID = remoteid;
                dto.updateTime = updateTime;
                dto.createTime = createTime;
                [data addObject:dto];
            }
        }
        [rs close];
        
        result(data);
    }];
}

#pragma mark - 上拉加载历史
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime remoteID:(NSNumber *)remoteID
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSArray *param = @[sessionID, @0];
        NSString *selectSql = @"SELECT count(*) FROM message_im WHERE sessionid=? AND remoteid != ?";
        FMResultSet *selectRs = [db executeQuery:selectSql withArgumentsInArray:param];
        if ([selectRs next]) {
            NSInteger total = [selectRs intForColumnIndex:0];
            [selectRs close];
            if (total < remoteID.integerValue) { // pull old
                result(data);
            } else { // 本地显示
                NSMutableArray *args = [[NSMutableArray alloc] init];
                [args addObject:sessionID];
                [args addObject:createTime];
                NSString *sql = @"SELECT * FROM (SELECT * FROM message_im WHERE sessionid=? AND createTime<? ORDER BY createTime DESC limit 6) AS t1 ORDER BY t1.createTime ASC, t1.remoteid ASC";
                FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
                while ([rs next]) {
                    NSString *messageid = [rs stringForColumn:@"messageid"];
                    NSInteger status = [rs intForColumn:@"status"];
                    NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
                    NSInteger remoteid = [rs longForColumn:@"remoteid"];
                    NSDate *updateTime = [rs dateForColumn:@"updateTime"];
                    NSDate *createTime = [rs dateForColumn:@"createTime"];
                    if (info) {
                        MessageDTO *dto = [[MessageDTO alloc] init:info];
                        dto.messageID = messageid;
                        dto.status = (MessageStatus)status;
                        dto.remoteID = remoteid;
                        dto.updateTime = updateTime;
                        dto.createTime = createTime;
                        [data addObject:dto];
                    }
                }
                [rs close];
                result(data);
            }
        }
    }];
}

#pragma mark - 获取当前会话根据pull old 通知获取的最新消息 -
- (void)selectNewMessage:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:sessionID];
        [args addObject:createTime];
        [args addObject:@""];
        NSString *sql = @"SELECT * FROM message_im WHERE sessionid=? AND createTime>? AND reverse1=? ORDER BY createTime ASC,remoteid ASC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSString *messageid = [rs stringForColumn:@"messageid"];
            NSInteger status = [rs intForColumn:@"status"];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSInteger remoteid = [rs longForColumn:@"remoteid"];
            NSDate *updateTime = [rs dateForColumn:@"updateTime"];
            NSDate *createTime = [rs dateForColumn:@"createTime"];
            if (info) {
                MessageDTO *dto = [[MessageDTO alloc] init:info];
                dto.messageID = messageid;
                dto.status = (MessageStatus)status;
                dto.remoteID = remoteid;
                dto.updateTime = updateTime;
                dto.createTime = createTime;
                [data addObject:dto];
            }
        }
        [rs close];
        
        result(data);
    }];
}

#pragma mark - 获取该session会话的对方最大remoteid
- (void)selectLastestRemoteid:(SuccessBlock)success session:(NSString *)sessionID
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSArray *param = @[sessionID, @""];
        NSInteger remoteid = 0;
        NSString *sql = @"SELECT remoteid FROM message_im WHERE sessionid=? AND reverse1=? ORDER BY createTime DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:param];
        if ([rs next]) {
            remoteid = [rs intForColumn:@"remoteid"];
        }
        [rs close];
        success(@(remoteid));
    }];
}

// 设置未发送的消息为发送不成功的消息
- (void)markAllPendingAsError
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:MessageFail]];
        [array addObject:[NSNumber numberWithInteger:MessagePending]];
        
        NSString *sql = @"UPDATE message_im SET status=? WHERE status=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message update error");
    }];
}

// 标记该组消息都为已读
- (void)markMessageAsRead:(NSString *)sessionID
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:MessageRead]];
        [array addObject:sessionID];
        [array addObject:[NSNumber numberWithInteger:MessageUnRead]];
        
        NSString *sql = @"UPDATE message_im SET status=? WHERE sessionid=? AND status=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message update error");
    }];
}

- (void)markMessageStatus:(NSString *)messageID status:(NSInteger)status
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:status]];
        [array addObject:messageID];
        
        NSString *sql = @"UPDATE message_im SET status=? WHERE messageid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Message update error");
    }];
}

/** 获取未读数 */
- (void)getMessageUnreadCounts:(DictionaryBlock)result sessions:(NSArray *)sessions
{
    [readQueue inDatabase:^(FMDatabase *db) {

        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        //
        NSMutableArray *args = [NSMutableArray arrayWithArray:sessions];
        [args addObject:[NSNumber numberWithInteger:MessageUnRead]];
        
        NSMutableString *sql = [NSMutableString string];
        [sql appendFormat:@"SELECT sessionid, COUNT(*) AS count FROM message_im WHERE ("];
        for (int i=0; i<sessions.count; i++) {
            [sql appendFormat:@" sessionid=?"];
            if (i < sessions.count-1) {
                [sql appendFormat:@" OR"];
            }
        }
        [sql appendString:[NSString stringWithFormat:@") AND status=?"]];
         
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSString *sessionid = [rs stringForColumn:@"sessionid"];
            NSInteger count = [rs intForColumn:@"count"];
            if (sessionid != nil) {
                [data setObject:[NSNumber numberWithInteger:count] forKey:sessionid];
            }
        }
        [rs close];
        //
        result(data);
        
    }];
}

/** 获取所有未读数，没有用到 */
- (void)getAllMessageUnreadCounts:(DictionaryBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        //
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:[NSNumber numberWithInteger:MessageUnRead]];
        
        NSMutableString *sql = [NSMutableString string];
        [sql appendFormat:@"SELECT COUNT(*) AS count FROM message_im WHERE status=?"];
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            [data setObject:[NSNumber numberWithInteger:count] forKey:@"message"];
        }
        [rs close];
        //
        result(data);
    }];
}

/** 获取当前会话最大remoteId */
- (void)getLastRemoteId:(ArrayBlock)result bySession:(NSString *)sessionId
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [NSMutableArray array];
        //
        NSMutableArray *args = [NSMutableArray array];
        [args addObject:sessionId];
        
        NSString *sql = @"SELECT max(remoteid) FROM message_im WHERE sessionid=?";
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSInteger remoteid = [rs longForColumnIndex:0];
            [data addObject:@(remoteid)];
        }
        [rs close];
        //
        result(data);
    }];
}

@end
