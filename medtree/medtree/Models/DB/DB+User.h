//
//  DB+User.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class UserDTO;

@interface DB (User)

- (void)createTable_User;
- (void)insertUser:(UserDTO *)dto;
- (void)insertUsers:(NSArray *)users;
- (void)updateUser:(UserDTO *)dto;
- (NSArray *)selectUserIDs;
- (void)selectUser:(NSString *)key value:(NSString *)value result:(ArrayBlock)result;

@end
