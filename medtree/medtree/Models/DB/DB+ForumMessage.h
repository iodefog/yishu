//
//  DB+ForumMessage.h
//  medtree
//
//  Created by 陈升军 on 15/3/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"

@class ForumMessageDTO;

@interface DB (ForumMessage)

- (void)createTable_ForumMessage;
- (void)insertForumMessage:(ForumMessageDTO *)dto;
- (void)selectAllForumMessageResult:(ArrayBlock)result;

@end
