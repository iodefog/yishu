//
//  DB+MarkRelation.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+MarkRelation.h"
#import "JSONKit.h"
#import "UserDTO.h"
#import "MessageDTO.h"

@implementation DB (MarkRelation)

- (void)createTable_MarkRelation
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    type INTETER, \
    status INTETER, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"mark_relation" arguments:sql];
}

- (void)insertMarkRelation:(UserDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        [array addObject:[NSNumber numberWithInteger:dto.relation]];
        [array addObject:[NSNumber numberWithInteger:MessageUnRead]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO mark_relation (userid, type, status, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"mark_relation insert error");
    }];
}

- (void)deleteMarkRelation:(UserDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        
        NSString *sql = @"DELETE FROM mark_relation WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"mark_relation delete error");
    }];
}

- (void)deleteAllMarkRelation
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"DELETE FROM mark_relation";
        
        BOOL isOK = [db executeUpdate:sql];
        if (!isOK) NSLog(@"all mark_relation delete error");
    }];
}

- (void)updateMarkRelation:(UserDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:dto.relation]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.userID];
        
        NSString *sql = @"UPDATE mark_relation SET type=?, info=? WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"mark_relation update error");
    }];
}

- (NSArray *)selectMarkRelationIDs
{
    NSMutableArray *data = [NSMutableArray array];
    //
    NSString *sql = @"SELECT userid FROM mark_relation";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"userid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllMarkRelations:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT type, info FROM mark_relation ORDER BY rowid DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSInteger type = [rs intForColumn:@"type"];
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                UserDTO *dto = [[UserDTO alloc] init];
                [dto parse2:info];
                dto.relation = type;
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
