//
//  NewFeedCommentCell.h
//  medtree
//
//  Created by 边大朋 on 15-4-7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseCell.h"

typedef NS_ENUM(NSInteger, FeedCommentCellActionType) {
    FeedCommentCellActionTypeReply = 100,
    FeedCommentCellActionTypeReplyTo,
    FeedCommentCellActionTypeReport,
    FeedCommentCellActionTypeDelete,
    FeedCommentCellActionTypeTap
};

@interface NewFeedCommentCell : BaseCell

@end
