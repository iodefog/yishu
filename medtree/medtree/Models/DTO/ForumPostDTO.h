//
//  ForumPostDTO.h
//  medtree
//
//  Created by 陈升军 on 15/3/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class UserDTO;

@interface ForumPostDTO : DTOBase

@property (nonatomic, strong) NSString      *postID;
@property (nonatomic, strong) NSString      *reply_to_post_id;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *reply_to_user_id;
@property (nonatomic, strong) NSString      *reply_to_user_name;
@property (nonatomic, strong) NSString      *content;
@property (nonatomic, strong) NSString      *user_name;

@property (nonatomic, strong) NSDate        *created;

@property (nonatomic, strong) UserDTO       *target;
@property (nonatomic, strong) UserDTO       *to_user;

@property (nonatomic, assign) BOOL          is_anonymous;

@property (nonatomic, strong) NSMutableArray *comments;

/** 喜欢数 */
@property (nonatomic, assign) NSInteger     like_count;
@property (nonatomic, assign) BOOL          is_liked;
@property (nonatomic, assign) BOOL          is_combined;
@property (nonatomic, assign) BOOL          is_hidetags;

/** 喜欢人数字符串 */
@property (nonatomic, strong) NSString      *likes_str;

@end
