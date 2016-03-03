//
//  NotificationDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@class UserDTO;

@interface NotificationDTO : DTOBase

@property (nonatomic, strong) NSString      *userID;
@property (nonatomic, strong) UserDTO       *target;
@property (nonatomic, strong) NSString      *message;
@property (nonatomic, strong) NSString      *ticket;
@property (nonatomic, strong) NSString      *parent_ticket;
@property (nonatomic, assign) NSInteger     status;
@property (nonatomic, assign) NSInteger     unread;
@property (nonatomic, assign) BOOL          processed;
@property (nonatomic, strong) NSDate        *time;
//@property (nonatomic, assign) NSInteger     type;

@end
