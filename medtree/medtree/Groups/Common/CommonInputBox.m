//
//  CommonInputBox.m
//  medtree
//
//  Created by 边大朋 on 15-4-9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CommonInputBox.h"
#import "MedGlobal.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "TextViewEx.h"

@interface CommonInputBox ()<UITextViewDelegate>
{
    
}
@end

@implementation CommonInputBox

- (void)createUI
{
    self.maxLength = 300;
    
    self.backgroundColor = [ColorUtil getColor:@"F7F7F7" alpha:1];

    sendBox = [[TextViewEx alloc] initWithFrame:CGRectZero];
    sendBox.backgroundColor = [ColorUtil getColor:@"FFFFFF" alpha:1];
    sendBox.autocapitalizationType = UITextAutocapitalizationTypeNone;
   // [sendBox setReturnKeyType:UIReturnKeySend];
    sendBox.textAlignment = NSTextAlignmentLeft;
    sendBox.font = [MedGlobal getMiddleFont];
    sendBox.scrollEnabled = NO;
    sendBox.layer.cornerRadius = 6;
    sendBox.layer.masksToBounds = YES;
    sendBox.returnKeyType = UIReturnKeySend;
    sendBox.layer.borderColor = [ColorUtil getColor:@"DBDCDF" alpha:1].CGColor;
    sendBox.layer.borderWidth = 1;
    [sendBox setTextColor:[ColorUtil getColor:@"DCDCDC" alpha:1]];
    sendBox.delegate = self;
    
    [self addSubview: sendBox];
    
    
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.backgroundColor = [ColorUtil getColor:@"FAFAFA" alpha:1];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.layer.cornerRadius = 6;
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.borderWidth = 1;
    sendBtn.layer.borderColor = [ColorUtil getColor:@"DBDCDF" alpha:1].CGColor;
    sendBtn.enabled = NO;
    [self addSubview:sendBtn];
    
    [self initConfig];
}

-(UITextView *)getSendBox
{
    return sendBox;
}

- (void)clickAction
{
    if (sendBox.text.length > 0 && [sendBox.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0) {
        [self resignResponder];
        [self.parent sendData];
    }
    else
    {
        if (self.voidTextSend)
        {
            self.voidTextSend();
        }
    }
}

- (void)initConfig
{
    boxHeight = 40;//输入框高
    
    btnWith = 60;//发送按钮宽
    btnHeight = boxHeight;//发送按钮高
    
    space = 15; //输入框或按钮与边界间隔
    midSpace = 10;//控件之间间隔
    
    sendBoxCurrentHeight = 19;
    sendBoxW = 100;

}

- (void)becomeResponder
{
    [sendBox becomeFirstResponder];
    
    if (self.textBecomeFirstResponder)
    {
        self.textBecomeFirstResponder();
    }
}

- (void)resignResponder
{
    sendBoxCurrentHeight = 19;
    [self checkHeight];
    [sendBox resignFirstResponder];
    
}

- (void)clearText
{
    sendBox.text = @"";
    [sendBox setPlaceholder:@" "];
    [sendBox drawRect:sendBox.frame];
    sendBoxCurrentHeight = 19;
    [self checkHeight];
    [self layoutSubviews];
    
}

- (void)setPlaceHolder:(NSString *)text
{
    [sendBox setPlaceholder:text];
     [sendBox drawRect:sendBox.frame];
}

- (void)setData:(NSString *)text
{
    if (text.length > 0) {
        [sendBox setPlaceholder:[NSString stringWithFormat:@"回复 %@:", text]];
        [sendBox drawRect:sendBox.frame];
        [self checkHeight];
    } else {
        [sendBox setPlaceholder:@" "];
        [sendBox drawRect:sendBox.frame];
    }

    sendBox.scrollEnabled = YES;
}

- (NSString *)getData
{
    return sendBox.text;
}

- (CGFloat)getInputHeight
{
    CGFloat height = 31 + sendBoxCurrentHeight;
    return height;
}


- (void)checkHeight
{
    CGFloat height = 0;
    if ([MedGlobal getSysVer] >= 7) {
        CGFloat width = self.frame.size.width-sendBoxW;
        height = [FontUtil getTextHeight:sendBox.text font:sendBox.font width:width];
    } else {
        height = sendBox.contentSize.height;
    }
    
    CGFloat newHeight = height > 20*3 ? 20*3 : height;
    CGFloat heightIncrease = newHeight - sendBoxCurrentHeight;
    if (heightIncrease != 0) {
        sendBoxCurrentHeight = newHeight == 0 ? 19 : newHeight;
        if ([self.parent respondsToSelector:@selector(resize:)]) {
            [self.parent performSelector:@selector(resize:) withObject:nil];
        }
    }
}

- (void)layoutSubviews
{
    
    CGSize size = self.frame.size;
    sendBox.frame = CGRectMake(space, 5, size.width-space*2-midSpace-btnWith , [self getInputHeight] - 10);
    sendBtn.frame = CGRectMake(CGRectGetMaxX(sendBox.frame)+10, 5, btnWith, btnHeight);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor lightGrayColor] setStroke];
   // CGContextSetRGBStrokeColor(context, 0.8, 0.4, 0.2, 1);
    CGContextMoveToPoint(context, 0, 0);
    CGContextSetLineWidth(context, 0.5);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
}

#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self clickAction];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger number = [textView.text length];
    
    sendBtn.enabled = number > 0 ? YES : NO;
      
    
    NSRange range = NSMakeRange(number - 1, 1);
    [textView scrollRangeToVisible:range];
    if (number > self.maxLength)
    {
        textView.text = [textView.text substringToIndex:self.maxLength];
        if ([self.parent respondsToSelector:@selector(overMaxLength)])
        {
            [self.parent overMaxLength];
        }
        if (self.overMaxLengthWarming)
        {
            self.overMaxLengthWarming();
        }
    }
    sendBox.scrollEnabled = YES;
    [self checkHeight];
    sendBox.textColor = [UIColor blackColor];
}

@end
