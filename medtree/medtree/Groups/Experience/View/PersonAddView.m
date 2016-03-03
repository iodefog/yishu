//
//  PersonAddView.m
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonAddView.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"

@implementation PersonAddView

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
    // 昵称
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.contentMode = UIViewContentModeScaleToFill;
    [self showBgView:NO];
    bgView.image = [ImageCenter getBundleImage:@"img_trans_cover.png"];
    [self addSubview:bgView];
    
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
    titleLab.font = [MedGlobal getLittleFont];
    titleLab.numberOfLines = 0;
    [self addSubview: titleLab];
    
    addImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    addImage.image = [ImageCenter getBundleImage:@"person_ic_addition.png"];
    addImage.userInteractionEnabled = YES;
    [self addSubview:addImage];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    addImage.frame = CGRectMake(0, (size.height-16)/2, 16, 16);
    titleLab.frame = CGRectMake(20, (size.height-20)/2, size.width-30, 20);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
}

- (void)setInfo:(NSString *)text indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag
{
    index = indexPath;
    tagNum = tag;
    titleLab.text = text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self showBgView:YES];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self showBgView:NO];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self showBgView:NO];
    [self clickCell];
}

- (void)clickCell
{
    NSLog(@"qwqeqw");
    [self.parent clickiViewIndexPath:index tag:tagNum];
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = tf ? 0.5 : 0;
}

@end
