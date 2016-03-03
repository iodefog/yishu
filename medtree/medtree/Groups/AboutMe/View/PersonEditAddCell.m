//
//  PersonEditAddCell.m
//  medtree
//
//  Created by 无忧 on 14-9-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditAddCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"

@implementation PersonEditAddCell

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
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.text = @"个人动态";
    [self addSubview: titleLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    headerLine.hidden = !isFirstCell;
    footerLine.hidden = isLastCell;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    titleLab.frame = CGRectMake(10, 0, size.width-10, size.height);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    titleLab.text = (NSString *)dto;
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = tf ? 0.5 : 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self clickHeader];
}

- (void)clickHeader
{
    [self.parent clickCell:nil index:index];
}

@end
