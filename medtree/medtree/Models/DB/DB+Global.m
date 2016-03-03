//
//  DB+Global.m
//  medtree
//
//  Created by tangshimi on 5/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DB+Global.h"
#import "JSONKIT.h"

@implementation DB (Global)

- (void)createGlobalTable
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    url TEXT, \
    json TEXT";
    [self createTable:@"global" arguments:sql];
}

- (id)readCacheWithURL:(NSString *)url
{
    if (url.length <= 0) {
        return nil;
    }
    
   __block NSDictionary *jsonDic;
    [readQueue inDatabase:^(FMDatabase *db) {
        NSArray *array = @[url];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT json FROM global WHERE url = ?"];
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            jsonDic = [[rs stringForColumn:@"json"] objectFromJSONString];
        }
    
        [rs close];
    }];
    return jsonDic;
}

- (void)cacheWithURL:(NSString *)url data:(id)json
{
    if (url.length <= 0) {
        return;
    }
    
    if ([self readCacheWithURL:url]) {
        if (![[self readCacheWithURL:url] isEqual:json] ) {
            [self updateCacheWithURL:url data:json];
        }
    } else {
        [self insertCacheWithURL:url data:json];
    }
}

- (void)updateCacheWithURL:(NSString *)url data:(id)json
{
    if (url.length <= 0) {
        return;
    }
    
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *array = @[[json JSONString], url];
        
        NSString *sql = @"UPDATE global SET json = ? WHERE url = ?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) {
            NSLog(@"global update error");
        }
    }];
}

- (void)insertCacheWithURL:(NSString *)url data:(id)json
{
    if (url.length <= 0) {
        return;
    }
    
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSArray *array = @[url, [json JSONString]];
        
        NSString *sql = @"INSERT INTO global (url, json) VALUES (?, ?)";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) {
            NSLog(@"global insert error");
        }
    }];
}

@end
