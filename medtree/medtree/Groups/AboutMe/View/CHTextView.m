//
//  CHTextView.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/10.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "CHTextView.h"

#define JYMargin 15
#define JYTopMargin 12

@interface CHTextView () <UITextViewDelegate>
{
    UITextView      *textView;
    UILabel         *placeHolderLabel;
    UILabel         *headerLine;
    UILabel         *footerLine;
}

@end

@implementation CHTextView

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] init];
    textView.font = [MedGlobal getMiddleFont];
    textView.delegate = self;
    [self addSubview:textView];
    
    placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.backgroundColor = [UIColor clearColor];
    placeHolderLabel.textColor = [ColorUtil getColor:@"acacac" alpha:1.0];
    placeHolderLabel.font = [MedGlobal getLittleFont];
    placeHolderLabel.numberOfLines = 0;
    [textView addSubview:placeHolderLabel];
    //2.监听textView文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    headerLine = [[UILabel alloc] init];
    headerLine.backgroundColor = [ColorUtil getColor:@"e4e4e4" alpha:1.0];
    [self addSubview:headerLine];
    
    footerLine = [[UILabel alloc] init];
    footerLine.backgroundColor = [ColorUtil getColor:@"e4e4e4" alpha:1.0];
    [self addSubview:footerLine];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    headerLine.frame = CGRectMake(0, 0, size.width, 0.5);
    textView.frame = CGRectMake(JYMargin, JYTopMargin, size.width - JYMargin * 2, size.height - JYTopMargin * 2);
    footerLine.frame = CGRectMake(0, size.height - 0.5, size.width, 0.5);
}

#pragma mark - setter & getter
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = [placeHolder copy];
    placeHolderLabel.text = placeHolder;
    if (placeHolder.length && textView.text.length == 0) {
        placeHolderLabel.hidden = NO;
        
        CGFloat placeHolderX = 5;
        CGFloat placeHolderY = 7;
        CGFloat maxW = self.frame.size.width - 2 * placeHolderX;
        CGFloat mawH = self.frame.size.height - 2 * placeHolderY;
        CGSize placeHolderSize = [placeHolder boundingRectWithSize:CGSizeMake(maxW, mawH) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:placeHolderLabel.font} context:nil].size;
        
        placeHolderLabel.frame = CGRectMake(placeHolderX, placeHolderY, placeHolderSize.width, placeHolderSize.height);
    }
    else {
        placeHolderLabel.hidden = YES;
    }
}

- (void)setText:(NSString *)text
{
    textView.text = text;
    if (text.length > 0) {
        placeHolderLabel.hidden = YES;
    }
}

- (NSString *)text
{
    return textView.text;
}

#pragma mark - noti
- (void)textDidChange
{
    placeHolderLabel.hidden = textView.text.length;
}

#pragma mark - public
- (void)becomeFirstRespond
{
    [textView becomeFirstResponder];
}

/**
 *  此代码未解决iOS7以后的大坑而生！！！！
 */
- (void)textViewDidChangeSelection:(UITextView *)text
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(rect.origin.y - textView.frame.size.height + rect.size.height, 0);
    if (textView.contentOffset.y < caretY && rect.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

@end
