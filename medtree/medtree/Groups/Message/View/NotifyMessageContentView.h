//
//  NotifyMessageContentView.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/17.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@class PostDTO;
@class UserDTO;
@protocol NotifyMessageContentViewDelegate <NSObject>

- (void)clickHead:(UserDTO *)dto;
- (void)clickPost:(PostDTO *)dto;

@end

@interface NotifyMessageContentView : BaseView

@property (nonatomic, strong) PostDTO *post;
@property (nonatomic, assign) id<NotifyMessageContentViewDelegate> delegate;

+ (CGFloat)getHeight;

@end
