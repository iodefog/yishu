//
//  DB+Post.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB+Post.h"
#import "PostDTO.h"
#import <JSONKit.h>

@implementation DB (Post)

- (void)createTable_Post
{
    NSString *sql =
    @"postid TEXT PRIMARY KEY, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"post" arguments:sql];
}

- (void)insertPosts:(NSArray *)posts
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSDictionary *dict in posts) {
            PostDTO *dto = [[PostDTO alloc] init:dict];
            NSArray *param = @[[[dto JSON] JSONString], dto.postID];
            NSString *sql = @"INSERT INTO post (info, postid) VALUES (?,?)";
            BOOL isOK = [db executeUpdate:sql withArgumentsInArray:param];
            if (!isOK) {
                NSString *updateSql = @"UPDATE post SET info=? WHERE postid=?";
                [db executeUpdate:updateSql withArgumentsInArray:param];
            }
        }
    }];
}

- (void)selectPost:(NSString *)postID success:(SuccessBlock)success
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSArray *param = @[postID];
        PostDTO *dto = nil;
        NSString *sql = @"SELECT info FROM post WHERE postid=?";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:param];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            if (info) {
                dto = [[PostDTO alloc] init:info];
            }
        }
        success(dto);
    }];
}

@end
