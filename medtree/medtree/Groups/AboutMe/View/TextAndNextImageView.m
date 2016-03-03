//
//  TextAndNextImageView.m
//  medtree
//
//  Created by 无忧 on 14-11-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TextAndNextImageView.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "MedGlobal.h"

@implementation TextAndNextImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.contentMode = UIViewContentModeScaleToFill;
    [self showBgView:NO];
    bgView.image = [ImageCenter getBundleImage:@"img_trans_cover.png"];
    [self addSubview:bgView];
    
    // 图片
    lineImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    lineImage.image = [ImageCenter getBundleImage:@"img_feed_cutline.png"];
    [self addSubview:lineImage];
    
    // 昵称
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    //    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [MedGlobal getMiddleFont];
    [self addSubview: titleLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    lineImage.frame = CGRectMake(10+24, 0, size.width-(10+24), 1);
    titleLab.frame = CGRectMake(10+24+10, 0, size.width-(10+24+10), size.height);
    nextImage.frame = CGRectMake(size.width-15, 10+7, 5, 10);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self showBgView:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [UIView animateWithDuration:0.5 animations:^{
        [self showBgView:NO];
    }];
    [self clickCell];
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = tf ? 0.5 : 0;
}

- (void)setTitle:(NSString *)title tag:(NSInteger)tag
{
    titleLab.text = title;
    num = tag;
}

- (void)clickCell
{
    [self.parent clickTextAndNextImageView:num];
}

@end
