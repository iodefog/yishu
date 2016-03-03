//
//  DB+ForumMessage.m
//  medtree
//
//  Created by 陈升军 on 15/3/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+ForumMessage.h"
#import "ForumMessageDTO.h"
#import "JSONKit.h"

@implementation DB (ForumMessage)

- (void)createTable_ForumMessage
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    forumid TEXT, \
    creattime timestamp, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"forum_message" arguments:sql];
}

- (void)insertForumMessage:(ForumMessageDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSString stringWithFormat:@"%@%@",dto.ref_id, dto.timestamp]];
        [array addObject:dto.timestamp];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO forum_message (forumid, creattime, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"forum_message insert error");
    }];
}

- (void)selectAllForumMessageResult:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM forum_message ORDER BY creattime DESC"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                ForumMessageDTO *dto = [[ForumMessageDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
