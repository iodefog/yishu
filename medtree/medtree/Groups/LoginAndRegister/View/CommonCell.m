//
//  CommonCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/4/15.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CommonCell.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "MedGlobal.h"

#define CHMarginS 15
#define CHLabelFont [UIFont systemFontOfSize:14]
#define CHTextFieldFont [UIFont systemFontOfSize:14]

@interface CommonCell () <UITextFieldDelegate>
{
    /** 分割线 */
    UILabel *dividLine1;    // 头
    UILabel *dividLine2;    // 中
    UILabel *dividLine3;    // 尾
    
    /** 箭头 */
    UIImageView *nextImg;
    
    /** 主文本 */
    UILabel *titleLabel;
    /** 编辑文本 */
    UITextField *textField;
}

@end

@implementation CommonCell

+ (instancetype)commoncell
{
    CommonCell *cell = [[CommonCell alloc] init];
    return cell;
}

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    
    self.maxLength = 20;
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.font = CHLabelFont;
    [self addSubview:titleLabel];
    
    textField = [[UITextField alloc] init];
    textField.font = CHTextFieldFont;
    textField.delegate = self;
    [textField addTarget:self action:@selector(checkTextLength) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:textField];
    
    dividLine1 = [[UILabel alloc] init];
    dividLine1.hidden = YES;
    dividLine1.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [self addSubview:dividLine1];
    dividLine2 = [[UILabel alloc] init];
    dividLine2.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [self addSubview:dividLine2];
    dividLine3 = [[UILabel alloc] init];
    dividLine3.hidden = YES;
    dividLine3.backgroundColor = [ColorUtil getColor:@"d6d6d6" alpha:1];
    [self addSubview:dividLine3];
    
    nextImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImg.userInteractionEnabled = YES;
    nextImg.hidden = YES;
    nextImg.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImg];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    dividLine1.frame = CGRectMake(0, 0, width, 0.5);
    CGFloat dividLineW = width - CHMarginS * 2;
    CGFloat dividLineY = height - 0.5;
    dividLine2.frame = CGRectMake(CHMarginS, dividLineY, dividLineW, 0.5);
    dividLine3.frame = CGRectMake(0, dividLineY, width, 0.5);
    
    CGFloat titleX = CHMarginS;
    CGFloat titleY = CHMarginS;
    CGSize titleSize = [titleLabel.text sizeWithAttributes:@{NSFontAttributeName:CHLabelFont}];
    CGFloat titleW = titleSize.width;
    CGFloat titleH = titleSize.height;
    if (textField.text.length == 0 && textField.placeholder.length == 0) {
        titleLabel.frame = CGRectMake(titleX, 0, width - CHMarginS * 2, height);
        titleLabel.font = [MedGlobal getLargeFont];
    } else {
        titleLabel.font = CHLabelFont;
        titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    }
    CGFloat textFieldX = CHMarginS;
    CGFloat textFieldY = 0;
    CGFloat textFieldW = width - CHMarginS * 2;
    CGFloat textFieldH = height;
    if (titleLabel.text.length == 0) {
        textFieldY = CHMarginS;
        textFieldH = height - CHMarginS * 2;
    } else {
        CGFloat titleLabelMaxY = CGRectGetMaxY(titleLabel.frame);
        textFieldY = titleLabelMaxY;
        textFieldH = height - titleLabelMaxY;
    }
    textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
    
    nextImg.frame = CGRectMake(width - 15, (height - 10) / 2, 5, 10);
}

#pragma mark - getter & setter
- (void)setShowFootLine:(BOOL)showFootLine
{
    dividLine3.hidden = _showFootLine;
}

- (void)setShowHeadLine:(BOOL)showHeadLine
{
    dividLine1.hidden = _showHeadLine;
}

- (void)setShowMedLine:(BOOL)showMedLine
{
    dividLine2.hidden = !_showMedLine;
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType
{
    textField.returnKeyType = returnKeyType;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    textField.keyboardType = keyboardType;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    textField.secureTextEntry = secureTextEntry;
}

- (void)setTextFieldInteractionEnabled:(BOOL)textFieldInteractionEnabled
{
    textField.userInteractionEnabled = textFieldInteractionEnabled;
}

- (void)setMaxLength:(NSInteger)maxLength
{
    _maxLength = maxLength;
}

- (void)setShowNextImg:(BOOL)showNextImg
{
    nextImg.hidden = !showNextImg;
}

#pragma mark 文本处理
- (void)setText:(NSString *)text
{
    textField.text = [text copy];
    [self setNeedsLayout];
}

- (NSString *)text
{
    return textField.text;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    textField.placeholder = [placeHolder copy];
}

- (void)setTitle:(NSString *)title
{
    titleLabel.text = [title copy];
}

#pragma mark - public
- (BOOL)isFirstResponder
{
    return [textField isFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    if ([textField canBecomeFirstResponder]) {
        [textField becomeFirstResponder];
    }
    return [super becomeFirstResponder];
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if ([self.delegate respondsToSelector:@selector(clickCell:)]) {
        [self.delegate clickCell:self];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(textFieldBecomeFirstRespond:)]) {
        [self.delegate textFieldBecomeFirstRespond:self];
    }
    if (self.textFieldBecomeFirstRespond) {
        self.textFieldBecomeFirstRespond();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(returnKeyClicked)]) {
        [self.delegate returnKeyClicked];
    }
    if (self.returnKeyClicked) {
        self.returnKeyClicked();
    }
    
    return YES;
}

#pragma mark - action
- (void)checkTextLength
{
    if (textField.text.length > self.maxLength) {
        dispatch_async(dispatch_get_main_queue(), ^{
            textField.text = [textField.text substringToIndex:self.maxLength];
        });
    }
}

@end
