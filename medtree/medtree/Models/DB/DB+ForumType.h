//
//  DB+ForumType.h
//  medtree
//
//  Created by 边大朋 on 15-5-14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@class ForumDTO;

@interface DB (ForumType)


- (void)createTable_TypeForum;
- (void)insertTypeForum:(ForumDTO *)dto;
- (void)updateTypeForum:(ForumDTO *)dto;
//- (void)selectAllTypeForumResult:(ArrayBlock)result;
- (void)selectTypeForumWithID:(NSString *)forumID result:(ArrayBlock)result;
//- (void)selectTypeForum:(NSString *)key value:(id)value result:(ArrayBlock)result;
//- (void)selectTypeForumWithZone:(NSInteger)zone result:(ArrayBlock)result;
- (void)selectTypeForumWithZoneAndCategory:(NSNumber *)zone category:(NSString *)category result:(ArrayBlock)result;

- (NSArray *)selectTypeForumIDs;

@end
