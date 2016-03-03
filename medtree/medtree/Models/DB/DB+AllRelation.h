//
//  DB+AllRelation.h
//  medtree
//
//  Created by 边大朋 on 15-5-12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@class PeopleDTO;

typedef enum {

    RelationType_Colleague          = 102,//同事
    RelationType_FriendFriend       = 103,//好友的好友
    RelationType_SameOccupation     = 104,//同行
    RelationType_Classmate          = 105,//校友
    
} AllRelation_Type;

@interface DB (AllRelation)

- (void)createTable_AllRelation;
- (void)insertAllRelation:(PeopleDTO *)dto type:(NSInteger)type;
- (void)updateAllRelation:(PeopleDTO *)dto type:(NSInteger)type;
- (void)deleteAllRelation:(PeopleDTO *)dto type:(NSInteger)type;
- (void)deleteAllRelations:(ArrayBlock)result type:(NSInteger)type;
- (NSArray *)selectAllRelationIDs:(NSInteger)type;
- (void)selectAllAllRelations:(ArrayBlock)result type:(NSInteger)type;


@end
