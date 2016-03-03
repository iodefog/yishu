//
//  ForumDTO.h
//  medtree
//
//  Created by 陈升军 on 15/3/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class UserDTO;

enum {
    ForumDTO_Type_Title          = 0,
    ForumDTO_Type_Detail         = 1
} ForumDTO_Type;

@interface ForumDTO : DTOBase

@property (nonatomic, strong) NSString  *user_id;
@property (nonatomic, strong) NSString  *forumID;
@property (nonatomic, strong) NSString  *category;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *content;
@property (nonatomic, strong) NSString  *bonus_assignment_summary;
@property (nonatomic, strong) NSString  *user_name;
@property (nonatomic, strong) NSString  *relation_summary;
@property (nonatomic, strong) NSString  *category_icon;
@property (nonatomic, strong) NSString  *category_image;

@property (nonatomic, assign) NSInteger user_count;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, assign) NSInteger bounty;
@property (nonatomic, assign) NSInteger bonus_sys;
@property (nonatomic, assign) NSInteger zone;

@property (nonatomic, assign) BOOL      is_liked;
@property (nonatomic, assign) BOOL      is_helped;
@property (nonatomic, assign) BOOL      is_anonymous;

@property (nonatomic, strong) NSDate  *created;
@property (nonatomic, strong) NSDate  *updated;

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, strong) NSDictionary *bonus_assignment;

@property (nonatomic, assign) NSInteger forumtype;

@end
