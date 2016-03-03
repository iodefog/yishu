//
//  RegisterOrganizationAddView.m
//  medtree
//
//  Created by 陈升军 on 15/4/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "RegisterOrganizationAddView.h"
#import "ImageCenter.h"
#import "MedGlobal.h"

@interface RegisterOrganizationAddView ()
{
    NSString *data;
}
@end
@implementation RegisterOrganizationAddView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    iconImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"toolBar_btn_add_person.png"]];
    iconImage.userInteractionEnabled = YES;
    [self addSubview:iconImage];
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.text = @"我要添加";
    titleLab.numberOfLines = 0;
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [MedGlobal getMiddleFont];
    [self addSubview: titleLab];
    
    lineImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"home_page_cell_line.png"]];
    [self addSubview:lineImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self addGestureRecognizer:tap];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    iconImage.frame = CGRectMake(15, 10, 40, 40);
    titleLab.frame = CGRectMake(15+40+5, 10, size.width-(15+40+5+15), size.height-20);
    lineImage.frame = CGRectMake(15, size.height-1, size.width-15*2, 1);
}

- (void)clickTap
{
    [self.parent searchViewClickAdd];
}

- (void)setData:(NSString *)text
{
    NSString *textStr = text.length > 0 ? @"我要添加:" : @"我要添加";
    titleLab.text = [NSString stringWithFormat:@"%@%@", textStr, text];
    data = text;
}

- (NSString *)getData
{
    return data;
}

@end
