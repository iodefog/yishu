//
//  EventFeedCommentInputBox.h
//  medtree
//
//  Created by tangshimi on 8/6/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"
@class EventFeedCommentInputView;

@protocol EventFeedCommentInputViewDelegate <NSObject>

- (void)eventFeedCommentInputView:(EventFeedCommentInputView *)inputView didClickSend:(NSString *)text;

@end

@interface EventFeedCommentInputView : BaseView

@property (nonatomic, weak) id<EventFeedCommentInputViewDelegate> delegate;
@property (nonatomic, copy) NSString *placeholder;

- (void)showInView:(UIView *)inView;

@end
