//
//  DB+ForumAnonymous.m
//  medtree
//
//  Created by 陈升军 on 15/3/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+ForumAnonymous.h"
#import "JSONKit.h"

@implementation DB (ForumAnonymous)

- (void)createTable_ForumAnonymous
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    forumid TEXT, \
    info TEXT,\
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"forum_anonymous" arguments:sql];
}

- (void)insertForumAnonymous:(NSDictionary *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[dto objectForKey:@"forumid"]];
        [array addObject:[dto JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO forum_anonymous (forumid, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum_anonymous insert error");
    }];
}

- (void)updateForumAnonymous:(NSDictionary *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[dto JSONString]];
        [array addObject:[dto objectForKey:@"forumid"]];
        
        NSString *sql = @"UPDATE forum_anonymous SET info=? WHERE forumid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum_anonymous update error");
    }];
}

- (void)selectForumAnonymousWithID:(NSString *)forumID result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:forumID];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum_anonymous WHERE forumid=?"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                [data addObject:info];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
