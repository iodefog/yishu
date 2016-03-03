//
//  DB+Relation.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class UserDTO;

typedef enum {
    RelationType_All        = 100,
    RelationType_Friend     = 101
} Relation_Type;

@interface DB (Relation)

- (void)createTable_Relation;
- (void)insertRelation:(UserDTO *)dto type:(NSInteger)type;
- (void)updateRelation:(UserDTO *)dto type:(NSInteger)type;
- (void)deleteRelation:(UserDTO *)dto type:(NSInteger)type;
- (void)deleteRelations:(ArrayBlock)result type:(NSInteger)type;
- (NSArray *)selectRelationIDs:(NSInteger)type;
- (void)selectAllRelations:(ArrayBlock)result type:(NSInteger)type;

@end
