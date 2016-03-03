//
//  DB+User.m
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB+User.h"
#import "JSONKit.h"
#import "UserDTO.h"

@implementation DB (User)

- (void)createTable_User
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    userid TEXT, \
    chatid TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
	[self createTable:@"user" arguments:sql];
}

- (void)insertUser:(UserDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.userID];
        [array addObject:dto.chatID];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO user (userid, chatid, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"user insert error");
    }];
}

- (void)insertUsers:(NSArray *)users
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSDictionary *dict in users) {
            UserDTO *dto = [[UserDTO alloc] init:dict];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:dto.userID];
            [array addObject:dto.chatID];
            [array addObject:[[dto JSON] JSONString]];
            [array addObject:@""];
            [array addObject:@""];
            [array addObject:@""];
            
            NSString *sql = @"INSERT INTO user (userid, chatid, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
            if (!isOK) NSLog(@"users insert error");
        }
    }];
}

- (void)updateUser:(UserDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.chatID];
        [array addObject:dto.userID];
        
        NSString *sql = @"UPDATE user SET info=?, chatid=? WHERE userid=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"User update error");
    }];
}

- (NSArray *)selectUserIDs
{
    NSMutableArray *data = [NSMutableArray array];
    NSString *sql = @"SELECT userid FROM User";
    FMResultSet *rs = [database executeQuery:sql];
    while ([rs next]) {
        [data addObject:[rs stringForColumn:@"userid"]];
    }
    [rs close];
    return data;
}

- (void)selectUser:(NSString *)key value:(NSString *)value result:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSMutableArray *args = [[NSMutableArray alloc] init];
        [args addObject:value];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT info FROM user WHERE %@=?", key];
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
