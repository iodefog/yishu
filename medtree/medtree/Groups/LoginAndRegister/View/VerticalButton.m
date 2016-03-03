//
//  VerticalButton.m
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//


#import "VerticalButton.h"

#import "ColorUtil.h"
#import "MedGlobal.h"

#define ButtonImageWH 88

@implementation VerticalButton

+ (instancetype)button
{
    return [VerticalButton buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[ColorUtil getColor:@"5e5e5e" alpha:1.0] forState:UIControlStateNormal];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [MedGlobal getLittleFont];
        self.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageY = 0;
    CGFloat imageWH = ButtonImageWH;
    CGFloat imageX = (contentRect.size.width - imageWH) * 0.5;
    return CGRectMake(imageX, imageY, imageWH, imageWH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleH = contentRect.size.height - ButtonImageWH;
    CGFloat titleY = ButtonImageWH;
    CGFloat titleW = contentRect.size.width;
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

@end
