//
//  DB+Event.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class EventDTO;

@interface DB (Event)

- (void)createTable_Event;
- (void)insertEvent:(EventDTO *)dto;
- (void)updateEvent:(EventDTO *)dto;
- (void)deleteAllEvent;
- (void)deleteEvent:(EventDTO *)dto;
- (NSArray *)selectEventIDs;
- (void)selectAllEvents:(ArrayBlock)result;

@end
