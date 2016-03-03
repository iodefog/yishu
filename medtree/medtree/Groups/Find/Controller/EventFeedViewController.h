//
//  EventFeedViewController.h
//  medtree
//
//  Created by tangshimi on 8/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

@class EventDTO;

@interface EventFeedViewController : MedBaseTableViewController

@property (nonatomic, strong) EventDTO *eventDTO;
@property (nonatomic, copy) NSString *eventID;

@end
