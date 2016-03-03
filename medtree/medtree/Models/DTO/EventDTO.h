//
//  EventDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

typedef NS_ENUM(NSInteger, EventType) {
    EventActivityType = 1,
    EventConferenceType = 11
};


@interface EventDTO : DTOBase

@property (nonatomic, strong) NSString  *sysid;
@property (nonatomic, assign) NSInteger event_type;
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *desc;
@property (nonatomic, strong) NSString  *small_image_id;
@property (nonatomic, strong) NSString  *large_image_id;
@property (nonatomic, strong) NSString  *tag;
@property (nonatomic, strong) NSString  *url;
@property (nonatomic, strong) NSDate    *start_time;
@property (nonatomic, strong) NSDate    *end_time;
@property (nonatomic, assign) NSInteger comment_count;
@property (nonatomic, assign) NSInteger like_count;
@property (nonatomic, assign) BOOL      is_end;
@property (nonatomic, strong) NSMutableArray    *links;
@property (nonatomic, assign) NSInteger offic_count;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, copy)   NSString *place;
@property (nonatomic, copy)   NSString *summary;

@end
