//
//  EventFeedCommentAndLikePopView.h
//  medtree
//
//  Created by tangshimi on 8/6/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EventFeedCommentAndLikePopView;

typedef NS_ENUM(NSInteger, EventFeedCommentAndLikePopViewSelectedType) {
    EventFeedCommentAndLikePopViewCommentSelectedType,
    EventFeedCommentAndLikePopViewLikeSelectedType
};


@protocol EventFeedCommentAndLikePopViewDelegate <NSObject>

- (void)eventFeedCommentAndLikePopView:(EventFeedCommentAndLikePopView *)popView
                       didSelectedType:(EventFeedCommentAndLikePopViewSelectedType)type;

@end

@interface EventFeedCommentAndLikePopView : UIView

@property (nonatomic, weak) id<EventFeedCommentAndLikePopViewDelegate> delegate;
@property (nonatomic, assign) BOOL like;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)inView;

@end
