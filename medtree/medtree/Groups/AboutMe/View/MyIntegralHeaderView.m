//
//  MyIntegralHeaderView.m
//  medtree
//
//  Created by 陈升军 on 15/4/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MyIntegralHeaderView.h"
#import "SignDTO.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"


@implementation MyIntegralHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [MedGlobal getLittleFont];
    titleLab.text = @"我的剩余积分";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = [UIColor darkGrayColor];
    [self addSubview:titleLab];
    
    integralLab = [[UILabel alloc] init];
    integralLab.text = @"0";
    integralLab.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:40];
    integralLab.textAlignment = NSTextAlignmentCenter;
    integralLab.textColor = [ColorUtil getColor:@"365c8a" alpha:1];
    integralLab.backgroundColor = [UIColor clearColor];
    [self addSubview:integralLab];
    
    coverImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"my_integral_cover.png"]];
    [self addSubview:coverImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    titleLab.frame = CGRectMake(0, 20, size.width, 20);
    integralLab.frame = CGRectMake(0, (size.height-60)/2, size.width, 60);
    coverImage.frame = CGRectMake((size.width-108)/2, size.height-30, 108, 21);
}

- (void)setInfo:(NSInteger)info
{
    integralLab.text = [NSString stringWithFormat:@"%@", @(info)];
}

@end
