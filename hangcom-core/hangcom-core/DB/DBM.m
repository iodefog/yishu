//
//  DBM.m
//  TestAFNetworking
//
//  Created by lyuan on 13-4-2.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import "DBM.h"
#import "FMDatabaseAdditions.h"

@implementation MDB

- (void)loadDB:(NSString *)dbName
{
    database = [FMDatabase databaseWithPath:dbName];
    if ([database open]) {
        [self checkAddedTables];
    }
    //
    readQueue = [FMDatabaseQueue databaseQueueWithPath:dbName];
    writeQueue = [FMDatabaseQueue databaseQueueWithPath:dbName];
}

- (void)finalize
{
    [database close];
}

- (BOOL)isExistTable:(NSString *)table
{
    return [database tableExists:table];
}

- (void)createTable:(NSString *)table arguments:(NSString *)arguments
{
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", table, arguments];
    if (![database executeUpdate:sqlstr]) {
        NSLog(@"Create db table error!");
    }
}

- (void)checkAddedTables
{
    
}

- (void)getTableItemCount:(NSString *)tableName result:(DBCountBlock)result
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    [readQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [database executeQuery:sqlstr];
        while ([rs next]) {
            NSInteger count = [rs intForColumn:@"count"];
            result(count);
            break;
        }
    }];
}

- (void)deleteTable:(NSString *)tableName result:(DBExecuteBlock)result
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    [writeQueue inDatabase:^(FMDatabase *db) {
        BOOL isOK = [db executeUpdate:sql];
        if (result) {
            result(isOK, 0, 1);
        }
    }];
}

- (void)clearTable:(NSString *)tableName result:(DBExecuteBlock)result
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    [writeQueue inDatabase:^(FMDatabase *db) {
        BOOL isOK = [db executeUpdate:sql];
        if (result) {
            result(isOK, 0, 1);
        }
    }];
}

@end
