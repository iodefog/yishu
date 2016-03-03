//
//  DB.m
//  zhihu
//
//  Created by lyuan on 14-3-5.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"
#import "DB+Public.h"

@implementation DB

+ (DB *)shareWithName:(NSString *)name
{
    DB *instance = [DB shareInstance];
    instance->dbName = name;
    [instance loadDBFile];
    
    return instance;
}

+ (DB *)shareInstance
{
    static DB *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DB alloc] init];
        //
        [instance doExtraWork];
        instance->dbName = @"normal.db";
    });
    return instance;
}

+ (void)loadDefaultDB
{
    [DB shareInstance]->dbName = @"normal.db";
    [[DB shareInstance] loadDBFile];
}

- (void)loadDBFile
{
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbfile = [documentsDirectory stringByAppendingPathComponent:self->dbName];
    NSLog(@"loadDB %@", dbfile);
    //
    [self finalize];//先关闭
    [self loadDB: dbfile];//再打开
     */
    
    NSString *fileName = @"UserDB";
    //旧版本数据库路径
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDocumentsDirectory = [cachesPaths objectAtIndex:0];
    NSString *cachesDbfile = [cachesDocumentsDirectory stringByAppendingPathComponent:self->dbName];
    NSLog(@"loadDB %@", cachesDbfile);
    //新版本数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbfile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@",dbfile,self->dbName];
    
    //判断数据库是否存在
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isCachesExist = [fm fileExistsAtPath:cachesDbfile]; //旧数据库文件是否存在
    BOOL isExist = [fm fileExistsAtPath:dbPath]; //新数据库文件是否存在
    BOOL isHaveDBfile = [fm fileExistsAtPath:dbfile]; //新数据库文件所在文件夹是否存在
    //
    [self finalize];//先关闭
    //
    if (isExist) {
        [self loadDB: dbPath];//打开数据库
    } else {
        NSError *error;
        if (isHaveDBfile) {
            if (isCachesExist) {//判断是否为旧版本
                BOOL cp = [fm moveItemAtPath:cachesDbfile toPath:dbPath error:nil];//数据库迁移
                if (cp) {//判断是否迁移成功
                    [self loadDB: dbPath];//打开数据库
                }
            } else {
                [self loadDB: dbPath];//打开数据库
            }
        } else {
            BOOL isDir = [fm createDirectoryAtPath:dbfile withIntermediateDirectories:YES attributes:nil error:&error];//创建数据库所在文件
            if (isDir) {//判断文件间是否创建成功
                if (isCachesExist) {//判断是否为旧版本
                    BOOL cp = [fm moveItemAtPath:cachesDbfile toPath:dbPath error:nil];//数据库迁移
                    if (cp) {//判断是否迁移成功
                        [self loadDB: dbPath];//打开数据库
                    }
                } else {
                    [self loadDB: dbPath];//打开数据库
                }
            }
        }
    }
}

- (void)checkAddedTables
{
    if (![self isExistTable:@"user"]) {
        [self createTable_User];
    }
    if (![self isExistTable:@"relation"]) {
        [self createTable_Relation];
    }
    if (![self isExistTable:@"session"]) {
        [self createTable_Session];
    }
    if (![self isExistTable:@"message_im"]) {
        [self createTable_Message];
    }
    if (![self isExistTable:@"event"]) {
        [self createTable_Event];
    }
    if (![self isExistTable:@"feed"]) {
        [self createTable_Feed];
    }
    if (![self isExistTable:@"event_feed"]) {
        [self createTable_EventFeed];
    }
    if (![self isExistTable:@"common"]) {
        [self createTable_Common];
    }
    if (![self isExistTable:@"new_relation"]) {
        [self createTable_NewRelation];
    }
    if (![self isExistTable:@"mark_relation"]) {
        [self createTable_MarkRelation];
    }
    if (![self isExistTable:@"new_count"]) {
        [self createTable_NewCount];
    }
    if (![self isExistTable:@"user_mood"]) {
        [self createTable_User_Mood];
    }
    if (![self isExistTable:@"user_action"]) {
        [self createTable_User_Action];
    }
    if (![self isExistTable:@"article_info"]) {
        [self createTable_Article];
    }
    if (![self isExistTable:@"topic_info"]) {
        [self createTable_Topic];
    }
    if (![self isExistTable:@"forum"]) {
        [self createTable_Forum];
    }
    if (![self isExistTable:@"forum_anonymous"]) {
        [self createTable_ForumAnonymous];
    }
    if (![self isExistTable:@"forum_message"]) {
        [self createTable_ForumMessage];
    }
    if (![self isExistTable:@"all_relation"]) {
        [self createTable_AllRelation];
    }
    if (![self isExistTable:@"forum_type"]) {
        [self createTable_TypeForum];
    }
    if (![self isExistTable:@"post"]) {
        [self createTable_Post];
    }
    if (![self isExistTable:@"global"]) {
        [self createGlobalTable];
    }
}

- (void)doExtraWork
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *pathArray = [[NSArray alloc] initWithObjects:@"pic", nil];
    
    for (int i = 0; i < pathArray.count; i++) {
        NSString *dirPath = [documentsDirectory stringByAppendingPathComponent:[pathArray objectAtIndex:i]];
        [self createDir:dirPath];
    }
}

- (void)createDir:(NSString *)dirPath
{
	NSFileManager *fileManage = [NSFileManager defaultManager];
	BOOL isDir;
	BOOL isExist = [fileManage fileExistsAtPath:dirPath isDirectory:&isDir];
	if (isExist == NO || isDir == NO) {
		NSError *error;
		isDir = [fileManage createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
		NSLog(@"Create dir %@ %@", dirPath, isDir == YES ? @"OK":@"Fail");
	}
}

- (void)clearTable:(NSString *)table
{
    [self clearTable:table result:^(BOOL tf, NSInteger idx, NSInteger total) {
        if (tf == NO) {
            NSLog(@"clearTable %@ error", table);
        }
    }];
}

@end
