//
//  DB+Mood.h
//  medtree
//
//  Created by 陈升军 on 14/12/16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DB.h"

@class ActionDTO;

@interface DB (UserAction)

- (void)createTable_User_Action;
- (void)insertAction:(ActionDTO *)dto;
- (void)deleteActionBefore:(NSDate *)time;
- (void)selectActions:(ArrayBlock)result;

@end
