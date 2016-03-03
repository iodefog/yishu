//
//  DB+Topic.m
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB+Topic.h"
#import "TopicDTO.h"
#import "JSONKit.h"

@implementation DB (Topic)

- (void)createTable_Topic
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    topicID TEXT, \
    create_time TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"topic_info" arguments:sql];
}

- (void)insertTopic:(TopicDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.topicID];
        [array addObject:dto.create_time];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO topic_info (topicID, create_time, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"topic_info insert error");
    }];
}

- (TopicDTO *)convertTopicDTO:(FMResultSet *)rs
{
    NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
    //
    TopicDTO *dto = [[TopicDTO alloc] init:info];
    return dto;
}

- (void)selectTopicDTOResult:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT info FROM topic_info ORDER BY create_time DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertTopicDTO:rs]];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)selecTopicWithTopicID:(ArrayBlock)result topicID:(NSString *)topicID
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:topicID];
        //
        NSString *sql = @"SELECT info FROM topic_info WHERE topicID=? ORDER BY create_time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertTopicDTO:rs]];
                break;
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)updateTopic:(TopicDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.create_time];
        [array addObject:dto.topicID];
        
        NSString *sql = @"UPDATE topic_info SET info=?,create_time=? WHERE topicID=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"topic_info update error");
    }];
}

@end
