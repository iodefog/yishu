//
//  TopicDTO.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface TopicDTO : DTOBase

@property (nonatomic, strong) NSDate                *create_time;
@property (nonatomic, strong) NSString              *desc;
@property (nonatomic, strong) NSDate                *end_time;
@property (nonatomic, strong) NSDate                *start_time;
@property (nonatomic, assign) NSInteger             event_type;
@property (nonatomic, strong) NSString              *topicID;
@property (nonatomic, assign) NSInteger             is_end;
@property (nonatomic, strong) NSString              *summary;
@property (nonatomic, strong) NSString              *large_image_id;
@property (nonatomic, strong) NSMutableArray        *links;
@property (nonatomic, strong) NSString              *small_image_id;
@property (nonatomic, strong) NSString              *tag;
@property (nonatomic, strong) NSString              *title;
@property (nonatomic, strong) NSString              *url;
@property (nonatomic, assign) BOOL                  is_liked;
@property (nonatomic, assign) NSInteger             like_count;
@property (nonatomic, assign) NSInteger             post_count;
@property (nonatomic, strong) NSString              *creater;
@property (nonatomic, strong) NSString              *creater_name;
@property (nonatomic, strong) NSString              *avatar;
@property (nonatomic, strong) NSString              *share_url;

@end
