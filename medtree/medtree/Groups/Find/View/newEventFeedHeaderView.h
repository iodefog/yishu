//
//  newEventFeedHeaderView.h
//  medtree
//
//  Created by tangshimi on 5/28/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"
#import "EventDTO.h"

@protocol NewEventFeedHeaderViewDelegate <NSObject>

- (void)eventFeedHeaderViewClickSearchBar;

- (void)eventFeedHeaderViewJionSubActivity;

- (void)eventFeedHeaderViewSeeAbouActivityDetail;

@end

@interface newEventFeedHeaderView : BaseView

@property (nonatomic, strong) EventDTO *eventDTO;

@property (assign, nonatomic) BOOL isOnlyShowSearchBar;

@property (nonatomic, weak) id<NewEventFeedHeaderViewDelegate> delegate;

@end
