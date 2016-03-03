//
//  PostDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

typedef NS_ENUM(NSUInteger, PostRefType) {
    PostRefTypeUnknown   = 0,
    PostRefTypeDiscuss,
    PostRefTypeArticle,
    PostRefTypeFriendFeed,
    PostRefTypeEvent,
    PostRefTypeHomeEvent,
    PostRefTypePosition
};

@class UserDTO;
@interface PostDTO : DTOBase

@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) NSDate *updateTime;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UserDTO *userDTO;
@property (nonatomic, assign) PostRefType type;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *channelName;

@end
