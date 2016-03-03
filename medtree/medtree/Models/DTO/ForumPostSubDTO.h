//
//  ForumPostSubDTO.h
//  medtree
//
//  Created by 陈升军 on 15/4/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class UserDTO;

@interface ForumPostSubDTO : DTOBase

@property (nonatomic, strong) NSString      *postID;
@property (nonatomic, strong) NSString      *reply_to_post_id;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *user_name;
@property (nonatomic, strong) NSString      *reply_to_user_id;
@property (nonatomic, strong) NSString      *reply_to_user_name;
@property (nonatomic, strong) NSString      *content;

@property (nonatomic, strong) NSDate        *created;

@property (nonatomic, strong) UserDTO       *target;
@property (nonatomic, strong) UserDTO       *to_user;

@property (nonatomic, assign) NSInteger     cellType;

@property (nonatomic, assign) BOOL          is_anonymous;

@end
