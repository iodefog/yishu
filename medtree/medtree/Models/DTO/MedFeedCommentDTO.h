//
//  MedFeedCommentDTO.h
//  medtree
//
//  Created by tangshimi on 9/16/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"
@class UserDTO;

@interface MedFeedCommentDTO : DTOBase

@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, copy) NSString *creatorID;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, strong) UserDTO *creatorDTO;
@property (nonatomic, copy) NSString *replyFeedID;
@property (nonatomic, copy) NSString *replyUserID;
@property (nonatomic, copy) NSString *replyUserName;
@property (nonatomic, strong) UserDTO *replyUserDTO;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, strong) NSDate *time;
/**
 *  是否显示尖角
 */
@property (nonatomic, assign) BOOL showSharpCorner;

@end
