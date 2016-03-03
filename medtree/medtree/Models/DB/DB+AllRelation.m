//
//  DB+AllRelation.m
//  medtree
//
//  Created by 边大朋 on 15-5-12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+AllRelation.h"
#import "JSONKit.h"
#import "UserDTO.h"
#import "PeopleDTO.h"

@implementation DB (AllRelation)

- (void)createTable_AllRelation
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    type TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"all_relation" arguments:sql];
}

- (void)insertAllRelation:(PeopleDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.peopleID];
        [array addObject:[NSString stringWithFormat:@"%@", @(type)]];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO all_relation (userid, type, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"All Relation insert error");
    }];
}

- (void)updateAllRelation:(PeopleDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
//        [array addObject:[NSString stringWithFormat:@"%d", type]];
//        [array addObject:dto.peopleID];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.peopleID];
        
        NSString *sql = @"UPDATE all_relation SET info=? WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relation update error");
    }];
}

- (void)deleteAllRelation:(PeopleDTO *)dto type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.peopleID];
        [array addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"DELETE FROM all_relation WHERE userid=? AND type=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relation delete error");
    }];
}

- (void)deleteAllRelations:(ArrayBlock)result type:(NSInteger)type
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"DELETE FROM all_relation WHERE type=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Relations delete error");
        
        result(nil);
    }];
}

- (NSArray *)selectAllRelationIDs:(NSInteger)type
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[NSNumber numberWithInteger:type]];
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    
    NSString *sql = @"SELECT userid FROM all_relation WHERE type=?";
    FMResultSet *rs = [database executeQuery:sql withArgumentsInArray:array];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"userid"]];
    }
    [rs close];
    return data;
}

- (void)selectAllAllRelations:(ArrayBlock)result type:(NSInteger)type
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:[NSNumber numberWithInteger:type]];
        
        NSString *sql = @"SELECT info FROM all_relation WHERE type=?";
        
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:args];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                PeopleDTO *dto = [[PeopleDTO alloc] init:info];
                [data addObject:dto];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end

