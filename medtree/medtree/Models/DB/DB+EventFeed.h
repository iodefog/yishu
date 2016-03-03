//
//  DBEventFeed.h
//  medtree
//
//  Created by 边大朋 on 15-5-11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DB.h"
@class FeedDTO;

@interface DB (EventFeed)

- (void)createTable_EventFeed;
- (void)insertEventFeed:(FeedDTO *)dto eventId:(NSString *)eventId;
- (void)updateEventFeed:(FeedDTO *)dto;
- (void)deleteEventFeed:(FeedDTO *)dto;
- (void)deleteAllEventFeed;
- (NSArray *)selectEventFeedIDs;
//- (void)selectAllEventFeeds:(ArrayBlock)result;
- (void)selectAllEventFeedsWithId:(NSString *)eventId block:(ArrayBlock)result;

@end
