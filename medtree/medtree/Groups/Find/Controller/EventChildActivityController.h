//
//  EventChildActivityController.h
//  medtree
//
//  Created by 边大朋 on 15-4-13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"

@class EventDTO;

@interface EventChildActivityController : TableController

@property (nonatomic, weak) EventDTO *eventDTO;

@end
