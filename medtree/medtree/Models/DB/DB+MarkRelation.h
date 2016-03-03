//
//  DB+MarkRelation.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class UserDTO;

typedef enum {
    MarkRelationType_Friend     = 1,
    MarkRelationType_Classmate  = 10,
    MarkRelationType_Colleague  = 20,
    MarkRelationType_All        = 300,
} MarkRelation_Type;

@interface DB (MarkRelation)

- (void)createTable_MarkRelation;
- (void)insertMarkRelation:(UserDTO *)dto;
- (void)deleteMarkRelation:(UserDTO *)dto;
- (void)deleteAllMarkRelation;
- (void)updateMarkRelation:(UserDTO *)dto;
- (NSArray *)selectMarkRelationIDs;
- (void)selectAllMarkRelations:(ArrayBlock)result;

@end
