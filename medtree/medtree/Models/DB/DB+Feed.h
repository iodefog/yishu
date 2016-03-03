//
//  DB+Feed.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class FeedDTO;

@interface DB (Feed)

- (void)createTable_Feed;
- (void)insertFeed:(FeedDTO *)dto;
- (void)updateFeed:(FeedDTO *)dto;
- (void)deleteFeed:(FeedDTO *)dto;
- (void)deleteAllFeed;
- (NSArray *)selectFeedIDs;
- (void)selectAllFeeds:(ArrayBlock)result;

@end
