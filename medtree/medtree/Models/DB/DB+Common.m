//
//  DB+Common.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+Common.h"
#import "JSONKit.h"
#import "DTOBase.h"

@implementation DB (Common)

- (void)createTable_Common
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    key TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"common" arguments:sql];
}

- (void)insertCommon:(DTOBase *)dto key:(NSString *)key
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:key];
        //
        NSString *info = @"";
        if ([dto isKindOfClass:[DTOBase class]]) {
            info = [[dto JSON] JSONString];
        } else {
            info = (NSString *)dto;
        }
        [array addObject:info];
        //
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO common (key, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Common insert error");
    }];
}

- (void)updateCommon:(DTOBase *)dto key:(NSString *)key
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        //
        NSString *info = @"";
        if ([dto isKindOfClass:[DTOBase class]]) {
            info = [[dto JSON] JSONString];
        } else {
            info = (NSString *)dto;
        }
        [array addObject:info];
        //
        [array addObject:key];
        
        NSString *sql = @"UPDATE common SET info=? WHERE key=?";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"Common update error");
    }];
}

- (void)selectCommon:(NSString *)key result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:key];
        
        NSString *sql = @"SELECT info FROM common WHERE key=?";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                [data addObject:info];
            } else {
                [data addObject:[rs stringForColumn:@"info"]];
            }
        }
        [rs close];
        result(data);
    }];
}

- (void)deleteCommon:(NSString *)key
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:key];
        
        NSString *sql = @"DELETE FROM common WHERE key=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"common delete error");
    }];
}

@end
