//
//  NotifyMessageDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"
#import "PostDTO.h"

typedef NS_ENUM(NSInteger, MessageReplyType) {
    MessageReplyTypeUnknown = 0,
    MessageReplyTypeReply   = 1,
    MessageReplyTypeLike    = 2,
    MessageReplyTypeInvite  = 3,
};

@class UserDTO;
@interface NotifyMessageDTO : DTOBase

@property (nonatomic, strong) NSString *fromUserID;
@property (nonatomic, strong) UserDTO *fromUser;     //
@property (nonatomic, strong) NSString *toUserID;
@property (nonatomic, strong) UserDTO *toUser;      //
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *refID;
@property (nonatomic, assign) MessageReplyType replyType;
@property (nonatomic, assign) PostRefType refType;
@property (nonatomic, strong, readonly) NSString *refStr;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) PostDTO *post;    //

@end
