//
//  DB+Forum.h
//  medtree
//
//  Created by 陈升军 on 15/3/17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@class ForumDTO;

@interface DB (Forum)

- (void)createTable_Forum;
- (void)insertForum:(ForumDTO *)dto;
- (void)updateForum:(ForumDTO *)dto;
- (void)selectAllForumResult:(ArrayBlock)result;
- (void)selectForumWithID:(NSString *)forumID result:(ArrayBlock)result;
- (void)selectForum:(NSString *)key value:(id)value result:(ArrayBlock)result;
- (void)selectForumWithZone:(NSInteger)zone result:(ArrayBlock)result;
- (NSArray *)selectForumIds;

@end
