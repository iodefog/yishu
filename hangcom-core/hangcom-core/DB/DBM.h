//
//  DBM.h
//  TestAFNetworking
//
//  Created by lyuan on 13-4-2.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

typedef void(^DBExecuteBlock)(BOOL tf, NSInteger idx, NSInteger total);
typedef void(^DBCountBlock)(NSInteger count);
typedef void(^DBQueryBlock)(id info);

@interface MDB : NSObject
{
    // queue for update/insert/delete/drop
    FMDatabaseQueue *writeQueue;
    // queue for select
    FMDatabaseQueue *readQueue;
    // id for createTable
    FMDatabase *database;
}

- (void)loadDB:(NSString *)dbName;
- (BOOL)isExistTable:(NSString *)table;
- (void)createTable:(NSString *)table arguments:(NSString *)arguments;

- (void)getTableItemCount:(NSString *)tableName result:(DBCountBlock)result;
- (void)deleteTable:(NSString *)tableName result:(DBExecuteBlock)result;
- (void)clearTable:(NSString *)tableName result:(DBExecuteBlock)result;

@end
