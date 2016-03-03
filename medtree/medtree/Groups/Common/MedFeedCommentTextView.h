//
//  CommentTextView.h
//  medtree
//
//  Created by tangshimi on 7/7/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedFeedCommentTextView;

typedef NS_ENUM(NSUInteger, MedFeedCommentTextViewSelectedType) {
    MedFeedCommentTextViewReplyPersonSelectedType,
    MedFeedCommentTextViewReplyToPersonSelectedType,
    MedFeedCommentTextViewURLSelectedType,
    MedFeedCommentTextViewOthersSelectedType
};

@protocol MedFeedCommentTextViewDelegate <NSObject>

- (void)commentTextView:(MedFeedCommentTextView *)textView selectedText:(NSString *)selectedText selectedType:(MedFeedCommentTextViewSelectedType)type;

@end


@interface MedFeedCommentTextView : UITextView

@property (copy, nonatomic) NSString *replyPersonName;
@property (copy, nonatomic) NSString *replyToPersonName;
@property (copy, nonatomic) NSString *commentText;
@property (weak, nonatomic) id <MedFeedCommentTextViewDelegate> commentTextViewDelegate;

- (void)setupTextView;

- (CGFloat)height;

@end
