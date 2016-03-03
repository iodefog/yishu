//
//  DB+Relation.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Relation.h"
#import "JSONKit.h"
#import "UserDTO.h"

@implementation DB (Relation)

- (void)createTable_Relation
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    type TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"relation" arguments:sql];
}

- (void)insertRelation:(UserDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        [array addObject:[NSString stringWithFormat:@"%@", @(type)]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO relation (userid, type, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relation insert error");
    }];
}

- (void)updateRelation:(UserDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSString stringWithFormat:@"%@", @(type)]];
        [array addObject:dto.userID];
        
        NSString *sql = @"UPDATE relation SET type=? WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relation update error");
    }];
}

- (void)deleteRelation:(UserDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        [array addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"DELETE FROM relation WHERE userid=? AND type=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relation delete error");
    }];
}

- (void)deleteRelations:(ArrayBlock)result type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"DELETE FROM relation WHERE type=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relations delete error");

        result(nil);
    }];
}

- (NSArray *)selectRelationIDs:(NSInteger)type
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSNumber numberWithInteger:type]];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *sql = @"SELECT userid FROM relation WHERE type=?";
    FMResultSet *rs = [database executeQuery:sql withArgumentsInArray:array];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"userid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllRelations:(ArrayBlock)result type:(NSInteger)type
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"SELECT user.info FROM user, relation WHERE user.userid=relation.userid AND type=?";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                UserDTO *dto = [[UserDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
