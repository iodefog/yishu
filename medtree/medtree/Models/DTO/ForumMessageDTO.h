//
//  ForumMessageDTO.h
//  medtree
//
//  Created by 陈升军 on 15/3/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class UserDTO;

@interface ForumMessageDTO : DTOBase


@property (nonatomic, strong) NSString      *ref_id;
@property (nonatomic, strong) NSString      *from_user;
@property (nonatomic, strong) NSString      *message;
@property (nonatomic, strong) NSString      *ref_title;

@property (nonatomic, assign) NSInteger     ref_type;

@property (nonatomic, strong) NSDate        *timestamp;

@property (nonatomic, strong) UserDTO       *user;

@end
