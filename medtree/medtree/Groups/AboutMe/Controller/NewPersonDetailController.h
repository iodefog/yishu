//
//  NewPersonDetailController.h
//  medtree
//
//  Created by 边大朋 on 15-4-3.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"

@class UserDTO;
@class NotificationDTO;

@interface NewPersonDetailController : TableController

@property (nonatomic, strong) UserDTO *userDTO;
@property (nonatomic, copy) NSString *userId;;
@property (nonatomic, strong) NotificationDTO *notificationDTO;
@property (nonatomic, assign) BOOL fromMessageController;
@property (nonatomic, assign) id delegate;

- (void)setTable;

@end
