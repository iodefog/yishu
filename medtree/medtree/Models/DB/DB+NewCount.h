//
//  DB+NewCount.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class NewCountDTO;

@interface DB (NewCount)

- (void)createTable_NewCount;
- (void)insertNewCount:(NewCountDTO *)dto;
- (void)updateNewCount:(NewCountDTO *)dto;
- (void)clearNotifyCount:(NSString *)key;
- (NSArray *)selectNewCountIDs;
- (NSInteger)getAllNotifyCount;
- (void)selectAllNewCounts:(ArrayBlock)result;
- (void)getNewCountByKey:(NSString *)key success:(SuccessBlock)success;

@end
