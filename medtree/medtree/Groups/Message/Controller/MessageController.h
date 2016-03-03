//
//  MessageController.h
//  medtree
//
//  Created by sam on 8/14/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "TableController.h"
#import "ImagePicker.h"

@class MessageDTO;
@class UserDTO;
@protocol MessageControllerDelegate <NSObject>

- (void)backFromMessage;

@end

@interface MessageController : TableController

@property (nonatomic, strong) UserDTO *target;
@property (nonatomic, weak) id<MessageControllerDelegate> delegate;

- (void)setInputMessage:(NSString *)text;

- (BOOL)isMatchSession:(NSString *)sid;

@end