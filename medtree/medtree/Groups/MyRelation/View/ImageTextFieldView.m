//
//  ImageTextFieldView.m
//  medtree
//
//  Created by 无忧 on 14-9-12.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ImageTextFieldView.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "ColorUtil.h"

@implementation ImageTextFieldView

@synthesize commonField;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)showBGImage:(BOOL)show
{
    bgImage.hidden = !show;
    headLine.hidden = show;
    footLine.hidden = show;
    self.commonField.backgroundColor = show?[UIColor whiteColor]:[ColorUtil getBackgroundColor];
}

- (void)createUI
{
    isHiddenLine = NO;
    
    bgImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"bg_login_input.png"]];
    bgImage.userInteractionEnabled = YES;
    [self addSubview:bgImage];
    
    iconImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"img_username.png"]];
    iconImage.userInteractionEnabled = YES;
    [self addSubview:iconImage];
    
    lineImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"img_login_line.png"]];
    lineImage.userInteractionEnabled = YES;
    lineImage.hidden = YES;
    [self addSubview:lineImage];
    
    commonField = [[UITextField alloc] initWithFrame:CGRectZero];
    commonField.font = [MedGlobal getLittleFont];
    commonField.delegate = self;
    commonField.borderStyle = UITextBorderStyleNone;
    commonField.returnKeyType = UIReturnKeyGo;
    [self addSubview:commonField];
    
    headLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    headLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    headLine.hidden = YES;
    [self addSubview:headLine];
    
    footLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    footLine.image = [ImageCenter getBundleImage:@"img_line.png"];
    footLine.hidden = YES;
    [self addSubview:footLine];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgImage.frame = CGRectMake(0, 0, size.width, size.height);
    iconImage.frame = CGRectMake(0, 0, 48, size.height);
    lineImage.frame = CGRectMake(0, 0, 2, size.height);
    commonField.frame = CGRectMake(48+10, 0, size.width-48-20, size.height);
    headLine.frame = CGRectMake(0, 0, size.width, 1);
    footLine.frame = CGRectMake(0, size.height-1, size.width, 1);
}

- (void)setViewTag:(NSInteger)tag
{
    tagNum = tag;
}

- (void)setReturnKeyType:(UIReturnKeyType)type
{
    commonField.returnKeyType = type;
}

- (void)setLineHidden
{
    isHiddenLine = YES;
    lineImage.hidden = YES;
}

- (void)setIconImage:(NSString *)imageName placeholder:(NSString *)placeholder
{
    iconImage.image = [ImageCenter getBundleImage:imageName];
    commonField.placeholder = placeholder;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.parent textFieldBecomeFirstResponderWithTag:tagNum];
    lineImage.hidden = isHiddenLine;
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    lineImage.hidden = YES;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.parent textFieldOverWithTag:tagNum];
    return YES;
}

@end
