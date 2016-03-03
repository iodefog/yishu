//
//  SessionDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"
#import "MessageDTO.h"

@class UserDTO;

@interface SessionDTO : DTOBase

@property (nonatomic, strong) NSString      *sessionID;
/** 对方的id */
@property (nonatomic, strong) NSString      *remoteUserID;
@property (nonatomic, strong) UserDTO       *target;
@property (nonatomic, strong) MessageDTO    *content;
@property (nonatomic, strong) NSDate        *updateTime;
@property (nonatomic, assign) NSInteger     unreadCount;
@property (nonatomic, assign) SessionType   sessionType;

// ----------------------------

/** 0为普通Session，1为“帮帮我”分组 */
@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, strong) NSDictionary  *ext;

@end
