//
//  EventFeedCommentInputBox.m
//  medtree
//
//  Created by tangshimi on 8/6/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedCommentInputView.h"
#import "UIColor+Colors.h"
#import "SZTextView.h"

@interface EventFeedCommentInputView () <UITextViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SZTextView *inputTextView;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation EventFeedCommentInputView

- (void)createUI
{
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.inputTextView];
    [self.containerView addSubview:self.sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.inputTextView.text = @"";
    [self.inputTextView resignFirstResponder];
}

#pragma mark - 
#pragma mark - UITextViewDelegate -

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self sendButtonAction:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 
#pragma mark - response event -

- (void)sendButtonAction:(UIButton *)button
{
    if (self.inputTextView.text.length == 0|| [self.inputTextView.text isEqualToString:@""]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(eventFeedCommentInputView:didClickSend:)]) {
        [self.delegate eventFeedCommentInputView:self didClickSend:self.inputTextView.text];
    }
    
    self.inputTextView.text = @"";
    [self.inputTextView resignFirstResponder];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *infoDic = [notification userInfo];
    CGFloat height = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat animationTime = [infoDic[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        CGRect frame = self.containerView.frame;
        frame.origin.y = GetViewHeight(self) - height - GetViewHeight(self.containerView);

        self.containerView.frame = frame;
    }];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    NSDictionary *infoDic = [notification userInfo];
    CGFloat animationTime = [infoDic[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:animationTime animations:^{
        self.containerView.frame = CGRectMake(0, GetViewHeight(self), GetViewWidth(self), 40);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - public -

- (void)showInView:(UIView *)inView
{
    self.frame = inView.bounds;
    [inView addSubview:self];
    self.containerView.frame = CGRectMake(0, GetViewHeight(self), GetViewWidth(self), 44);
    self.sendButton.frame = CGRectMake(GetViewWidth(self) - 65, 5, 50, GetViewHeight(self.containerView) - 10);
    self.inputTextView.frame = CGRectMake(15, 5, GetViewWidth(self) - GetViewWidth(self.sendButton) - 10 - 30, GetViewHeight(self.sendButton));
    
    [self.inputTextView becomeFirstResponder];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = ({
            UIView *view = [[UIView alloc] init];
            view.userInteractionEnabled = YES;
            view.backgroundColor = [UIColor colorFromHexString:@"#F7F7F7"];

            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetViewWidth(view), 0.5)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
            [view addSubview:lineView];
            
            view;
        });
    }
    return _containerView;
}

- (SZTextView *)inputTextView
{
    if (!_inputTextView) {
        _inputTextView = ({
            SZTextView *textView = [[SZTextView alloc] initWithFrame:CGRectZero];
            textView.delegate = self;
            textView.font = [UIFont systemFontOfSize:16];
            textView.backgroundColor = [UIColor whiteColor];
            textView.layer.borderColor = [UIColor colorFromHexString:@"#DBDCDF"].CGColor;
            textView.layer.borderWidth = 1.0f;
            textView.layer.cornerRadius = 6.0f;
            textView.layer.masksToBounds = YES;
            textView.returnKeyType = UIReturnKeySend;
            textView;
        });
    }
    return _inputTextView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = ({
            UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
            buton.backgroundColor = [UIColor colorFromHexString:@"#FAFAFA"];
            buton.titleLabel.font = [UIFont systemFontOfSize:16];
            [buton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [buton setTitle:@"发送" forState:UIControlStateNormal];
            buton.layer.borderColor = [UIColor colorFromHexString:@"#DBDCDF"].CGColor;
            buton.layer.borderWidth = 1.0f;
            buton.layer.cornerRadius = 6.0f;
            buton.layer.masksToBounds = YES;
            [buton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            buton;
        });
    }
    return _sendButton;
}

- (void)setPlaceholder:(NSString *)placeholder
{    
    _placeholder = [placeholder copy];
    
    self.inputTextView.placeholder = placeholder;
}

@end
