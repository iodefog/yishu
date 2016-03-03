//
//  PersonEditSetTextView.m
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditSetTextView.h"
#import "MedGlobal.h"
#import "ImageCenter.h"

@implementation PersonEditSetTextView

@synthesize textViewInfo;

- (void)createUI
{
    [super createUI];
    
    bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.text = @"";
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.textColor = [UIColor lightGrayColor];
    [self addSubview:titleLab];
    
    text = [[UITextView alloc] initWithFrame:CGRectZero];
    text.editable = YES;
    text.delegate = self;
    text.textColor = [UIColor blackColor];
    text.backgroundColor = [UIColor clearColor];
    text.font = [MedGlobal getMiddleFont];
    [text becomeFirstResponder];
    [self addSubview:text];
    
    headerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:headerLine];
    
    footLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    footLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    [self addSubview:footLine];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    headerLine.frame = CGRectMake(0, 10, size.width, 1);
    footLine.frame = CGRectMake(0, size.height-1, size.width, 1);
    text.frame = CGRectMake(10, 10, size.width-10, size.height-10);
    bgView.frame = CGRectMake(0, 10, size.width, size.height-10);
    titleLab.frame = CGRectMake(14, 17, size.width-10, 20);
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([self.parent respondsToSelector:@selector(checkCover)]) {
        [[self parent ]checkCover];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView1
{
    if (text.text.length > 0) {
        titleLab.hidden = YES;
    } else {
        titleLab.hidden = NO;
    }
    
    if (text.text.length < 501) {
        textStr = text.text;
    }
    if (text.text.length > 500) {
        text.text = textStr;
    }
    textViewInfo = text.text;
    [self checkIsEmpty];
}

- (void)checkIsEmpty
{
    if ([self.parent respondsToSelector:@selector(checkIsEmpty)]) {
        [[self parent ]checkIsEmpty];
    }
}

- (void)checkCover
{
    if ([self.parent respondsToSelector:@selector(checkCover)]) {
        [[self parent ]checkCover];
    }
}

- (void)setTextViewBecomeFirstResponder
{
    [text becomeFirstResponder];
}

- (void)setTextViewResignFirstResponder
{
    [text resignFirstResponder];
}

- (void)setBgTitle:(NSString *)title
{
    titleLab.text = title;
}

- (void)setTextViewTextInfo:(NSString *)textInfo
{
    text.text = textInfo;
    textViewInfo = textInfo;
    if (textInfo.length > 0) {
        titleLab.hidden = YES;
    } else {
        titleLab.hidden = NO;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(rect.origin.y - textView.frame.size.height + rect.size.height, 0);
    if (textView.contentOffset.y < caretY && rect.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

- (void)setInfo:(NSString *)textInfo placeHolder:(NSString *)place
{
    if (place.length > 0) {
        textViewInfo = textInfo;
        titleLab.hidden = NO;
        [self setBgTitle:place];
    } else {
        text.text = textInfo;
        textViewInfo = textInfo;
        titleLab.hidden = YES;
    }
}

@end
