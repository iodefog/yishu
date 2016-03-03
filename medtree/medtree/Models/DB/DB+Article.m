//
//  DB+Article.m
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB+Article.h"
#import "ArticleDTO.h"
#import "JSONKit.h"

@implementation DB (Article)

- (void)createTable_Article
{
    NSString *sql =
    @"rowid INTEGER PRIMARY KEY, \
    articleID TEXT, \
    create_time TEXT, \
    info TEXT, \
    reverse1 TEXT, \
    reverse2 TEXT, \
    reverse3 TEXT";
    [self createTable:@"article_info" arguments:sql];
}

- (void)insertArticle:(ArticleDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:dto.articleID];
        [array addObject:dto.create_time];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:@""];
        [array addObject:@""];
        [array addObject:@""];
        
        NSString *sql = @"INSERT INTO article_info (articleID, create_time, info, reverse1, reverse2, reverse3) VALUES (?, ?, ?, ?, ?, ?)";
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"article_info insert error");
    }];
}

- (ArticleDTO *)convertArticleDTO:(FMResultSet *)rs
{
    NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
    //
    ArticleDTO *dto = [[ArticleDTO alloc] init:info];
    return dto;
}

- (void)selectArticleDTOResult:(ArrayBlock)result
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        //
        NSString *sql = @"SELECT info FROM article_info ORDER BY create_time DESC";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertArticleDTO:rs]];
            }
        }
        [rs close];
        //
        result(data);
    }];
}

- (void)updateArticle:(ArticleDTO *)dto
{
    [writeQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:[[dto JSON] JSONString]];
        [array addObject:dto.create_time];
        [array addObject:dto.articleID];
        
        NSString *sql = @"UPDATE article_info SET info=?,create_time=? WHERE articleID=?";
        
        BOOL isOK = [db executeUpdate:sql withArgumentsInArray:array];
        if (!isOK) NSLog(@"article_info update error");
    }];
}

- (void)selecArticleWithArticleID:(ArrayBlock)result articleID:(NSString *)articleID
{
    [readQueue inDatabase:^(FMDatabase *db) {
        NSMutableArray *data = [[NSMutableArray alloc] init];
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:articleID];
        //
        NSString *sql = @"SELECT info FROM article_info WHERE articleID=? ORDER BY create_time DESC";
        FMResultSet *rs = [db executeQuery:sql withArgumentsInArray:array];
        while ([rs next]) {
            NSDictionary *info = [[rs stringForColumn:@"info"] objectFromJSONString];
            NSLog(@"%@",info);
            if (info) {
                [data addObject:[self convertArticleDTO:rs]];
                break;
            }
        }
        [rs close];
        //
        result(data);
    }];
}

@end
