//
//  DB+ForumAnonymous.h
//  medtree
//
//  Created by 陈升军 on 15/3/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@interface DB (ForumAnonymous)

- (void)createTable_ForumAnonymous;
- (void)insertForumAnonymous:(NSDictionary *)dto;
- (void)updateForumAnonymous:(NSDictionary *)dto;
- (void)selectForumAnonymousWithID:(NSString *)forumID result:(ArrayBlock)result;

@end
