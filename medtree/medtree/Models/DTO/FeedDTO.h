//
//  FeedDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@class UserDTO;

@interface FeedDTO : DTOBase

/** 用户ID */
@property (nonatomic, strong) NSString      *userID;
@property (nonatomic, strong) UserDTO       *target;
/** 图片列表 */
@property (nonatomic, strong) NSArray       *images;
/** 动态关注数 */
@property (nonatomic, strong) NSDictionary  *friends_activity;
/** 动态id */
@property (nonatomic, strong) NSString      *feed_id;
/** 动态内容 */
@property (nonatomic, strong) NSString      *feed_content;
/** 动态时间 */
@property (nonatomic, strong) NSDate        *feed_time;
/** 标签数组 */
@property (nonatomic, strong) NSArray       *tag;
/** 评论数 */
@property (nonatomic, assign) NSInteger     comment_count;
/** 喜欢数 */
@property (nonatomic, assign) NSInteger     like_count;
@property (nonatomic, assign) BOOL          is_liked;
@property (nonatomic, assign) BOOL          is_combined;
@property (nonatomic, assign) BOOL          is_hidetags;
/** 评论列表 */
@property (nonatomic, strong) NSMutableArray       *comments;
/** 喜欢人数字符串 */
@property (nonatomic, strong) NSString      *likes_str;

@property (nonatomic, strong) NSMutableDictionary *reference;

@property (nonatomic, assign) BOOL searchFeed;

@end
