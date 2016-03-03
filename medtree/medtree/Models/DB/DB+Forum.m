//
//  DB+Forum.m
//  medtree
//
//  Created by 陈升军 on 15/3/17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+Forum.h"
#import "JSONKit.h"
#import "ForumDTO.h"

@implementation DB (Forum)

- (void)createTable_Forum
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    forumid TEXT, \
    creattime timestamp, \
    updatetime timestamp, \
    userid TEXT,\
    info TEXT, \
    ishelped INTETER,\
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"forum" arguments:sql];
}

- (void)insertForum:(ForumDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.forumID];
        [array addObject:dto.created];
        [array addObject:dto.updated];
        [array addObject:dto.user_id];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithInteger:dto.is_helped]];
        [array addObject:[NSNumber numberWithInteger:dto.zone]];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO forum (forumid, creattime, updatetime, userid, info, ishelped, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum insert error");
    }];
}

- (void)updateForum:(ForumDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.created];
        [array addObject:dto.updated];
        [array addObject:dto.user_id];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithInteger:dto.is_helped]];
        [array addObject:[NSNumber numberWithInteger:dto.zone]];
        [array addObject:dto.forumID];
        
        NSString *sql = @"UPDATE forum SET creattime=?, updatetime=?, userid=?, info=?, isHelped=? ,reverse1 =? WHERE forumid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum update error");
    }];
}

- (void)selectForumWithID:(NSString *)forumID result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:forumID];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum WHERE forumid=?"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                ForumDTO *dto = [[ForumDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectAllForumResult:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum ORDER BY creattime DESC"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                ForumDTO *dto = [[ForumDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectForum:(NSString *)key value:(id)value result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:value];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum WHERE %@=? ORDER BY creattime DESC", key];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                ForumDTO *dto = [[ForumDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selectForumWithZone:(NSInteger)zone result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:[NSNumber numberWithInteger:zone]];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum WHERE reverse1=? ORDER BY creattime DESC"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                ForumDTO *dto = [[ForumDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (NSArray *)selectForumIds
{

    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT forumid FROM forum ORDER BY creattime DESC";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"forumid"]];
    }
    [rs close];
    return data;
}

@end
