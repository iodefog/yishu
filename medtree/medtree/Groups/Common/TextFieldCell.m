//
//  TextFieldCell.m
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TextFieldCell.h"
#import "Pair2DTO.h"
#import "ColorUtil.h"
#import "MedGlobal.h"

@implementation TextFieldCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    // 昵称
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    titleLab.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: titleLab];
    
    textBGView = [[UIView alloc] init];
    textBGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:textBGView];
    
    textField = [[UITextField alloc] init];
    textField.backgroundColor = [UIColor clearColor];
    textField.textColor = [UIColor blackColor];
    textField.font = [UIFont systemFontOfSize:18];
    textField.text = @"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:textField];
    textField.delegate = self;
    [self.contentView addSubview:textField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    titleLab.frame = CGRectMake(15, 0, size.width, 20);
    headerLine.frame = CGRectMake(0, size.height-44, size.width, 1);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
    textField.frame = CGRectMake(15, size.height-44, size.width-30, 44);
    textBGView.frame = CGRectMake(0, size.height-44, size.width, 44);
}

- (void)textFiledEditChanged:(NSNotification *)obj
{
    ((Pair2DTO *)idto).label = text;
    [self.parent clickCell:idto index:index];
}

- (BOOL)textField:(UITextField *)textFieldT shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""] && range.length > 0) {
        return YES;
    } else {
        if (textFieldT.text.length - range.length + string.length > 14) {
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)setInfo:(Pair2DTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    titleLab.text = dto.title;
    text = dto.label;
    textField.text = dto.label;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44+20+10;
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
