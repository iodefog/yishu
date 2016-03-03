//
//  FeedLikeDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@class FeedDTO;

@interface FeedLikeDTO : DTOBase

@property (nonatomic, strong) NSString      *like_id;
@property (nonatomic, strong) NSString      *target_id;
@property (nonatomic, strong) NSString      *user_avatar;
@property (nonatomic, strong) NSString      *user_id;
@property (nonatomic, strong) NSString      *user_name;
@property (nonatomic, assign) NSInteger     target_type;
@property (nonatomic, strong) NSDate        *like_time;
@property (nonatomic, strong) FeedDTO       *feed;

@end
