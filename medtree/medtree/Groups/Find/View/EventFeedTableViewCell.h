//
//  EventFeedTableViewCell.h
//  medtree
//
//  Created by tangshimi on 8/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseCell.h"

typedef NS_ENUM(NSInteger, EventFeedTableViewCellActionType) {
    EventFeedTableViewCellActionTypeHeadView,
    EventFeedTableViewCellActionTypeCommentView,
    EventFeedTableViewCellActionTypeDelete,
    EventFeedTableViewCellActionTypeReport
};

@interface EventFeedTableViewCell : BaseCell

@end
