//
//  LoginBtn.m
//  medtree
//
//  Created by 孙晨辉 on 15/4/15.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "LoginBtn.h"
#import "ColorUtil.h"
#import "ImageCenter.h"

#define CHTitleButtonImageW 30

@implementation LoginBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenDisabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:19];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        self.backgroundColor = [UIColor blackColor];
        [self setBackgroundColor:[UIColor clearColor]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageW = CHTitleButtonImageW;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleW = contentRect.size.width - CHTitleButtonImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

@end
