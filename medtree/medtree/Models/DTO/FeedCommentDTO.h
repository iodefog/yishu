//
//  FeedCommentDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@class FeedDTO;
@class UserDTO;

@interface FeedCommentDTO : DTOBase

@property (nonatomic, strong) NSString      *reply_to_feed_id;
@property (nonatomic, strong) NSString      *reply_to_user_id;
@property (nonatomic, strong) NSString      *reply_to_user_name;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *user_name;
@property (nonatomic, strong) UserDTO       *target;
@property (nonatomic, strong) UserDTO       *to_user;
@property (nonatomic, strong) NSString      *comment_id;
@property (nonatomic, strong) NSString      *comment_content;
@property (nonatomic, strong) NSDate        *comment_time;
@property (nonatomic, assign) NSInteger     like_count;
@property (nonatomic, assign) BOOL          is_liked;
@property (nonatomic, strong) FeedDTO       *feed;
@property (nonatomic, assign) NSInteger     cellType;

@property (nonatomic, copy) NSString *reply_to_item_id;

- (void)dictToDTO:(NSDictionary *)dictionary;

@end
