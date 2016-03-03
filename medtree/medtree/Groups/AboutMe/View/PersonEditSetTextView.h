//
//  PersonEditSetTextView.h
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@interface PersonEditSetTextView : BaseView <UITextViewDelegate>
{
    UIView          *bgView;
    UILabel         *titleLab;
    UITextView      *text;
    NSString        *textStr;
    UIImageView     *headerLine;
    UIImageView     *footLine;
}

@property (nonatomic, strong) NSString *textViewInfo;

@property (nonatomic, assign) id parent;

- (void)setBgTitle:(NSString *)title;
- (void)setTextViewResignFirstResponder;
- (void)setTextViewBecomeFirstResponder;
- (void)setTextViewTextInfo:(NSString *)textInfo;
- (void)setInfo:(NSString *)textInfo placeHolder:(NSString *)place;

@end
