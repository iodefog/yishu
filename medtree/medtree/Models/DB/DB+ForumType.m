//
//  DB+ForumType.m
//  medtree
//
//  Created by 边大朋 on 15-5-14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+ForumType.h"
#import "ForumDTO.h"
#import "JSONKit.h"

@implementation DB (ForumType)

- (void)createTable_TypeForum
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    forumid TEXT, \
    creattime timestamp, \
    updatetime timestamp, \
    userid TEXT,\
    category TEXT, \
    info TEXT, \
    ishelped INTETER,\
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"forum_type" arguments:sql];
}

- (void)insertTypeForum:(ForumDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.forumID];
        [array addObject:dto.created];
        [array addObject:dto.updated];
        [array addObject:dto.user_id];
        [array addObject:dto.category];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithInteger:dto.is_helped]];
        [array addObject:[NSNumber numberWithInteger:dto.zone]];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO forum_type (forumid, creattime, updatetime, userid, category, info, ishelped, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum_type insert error");
    }];
}

- (void)updateTypeForum:(ForumDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.category];
        [array addObject:dto.created];
        [array addObject:dto.updated];
        [array addObject:dto.user_id];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:[NSNumber numberWithInteger:dto.is_helped]];
        [array addObject:[NSNumber numberWithInteger:dto.zone]];
        [array addObject:dto.forumID];
        
        NSString *sql = @"UPDATE forum_type SET category=? creattime=?, updatetime=?, userid=?, info=?, isHelped=? ,reverse1 =? WHERE forumid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum_type update error");
    }];
}

- (void)selectTypeForumWithID:(NSString *)forumID result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:forumID];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum_type WHERE forumid=?"];
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

//根据圈子分类和帮助分类来取
- (void)selectTypeForumWithZoneAndCategory:(NSNumber *)zone category:(NSString *)category result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:zone];
        [args addObject:category];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum_type WHERE reverse1=? AND category=? ORDER BY creattime DESC"];
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

- (NSArray *)selectTypeForumIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT forumid FROM forum_type ORDER BY creattime DESC";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"forumid"]];
    }
    [rs close];
    return data;
}
@end
