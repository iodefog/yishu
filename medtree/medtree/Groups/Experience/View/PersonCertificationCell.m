//
//  PersonCertificationCell.m
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonCertificationCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "CommonHelper.h"
#import "FontUtil.h"
#import "CertificationDTO.h"
#import "CertificationStatusType.h"
#import "UserType.h"

@implementation PersonCertificationCell

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
    footerLine.hidden = YES;
    // 昵称
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.numberOfLines = 0;
    [self.contentView addSubview:titleLab];
    
    // 时间
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [ColorUtil getColor:@"f2a30b" alpha:1];
    detailLab.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    titleLab.frame = CGRectMake(10, 0, [FontUtil getLabelWidth:titleLab labelFont:titleLab.font.pointSize], size.height);
    detailLab.frame = CGRectMake(10+[FontUtil getLabelWidth:titleLab labelFont:titleLab.font.pointSize], 0, [FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize], size.height);
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
}

- (void)setInfo:(CertificationDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    titleLab.text = [UserType getLabel:dto.userType];
    if (dto.status == 0) {
        detailLab.textColor = [ColorUtil getColor:@"f2a30b" alpha:1];
    } else if (dto.status == 1) {
        detailLab.textColor = [ColorUtil getColor:@"22cc0b" alpha:1];
    } else {
        detailLab.textColor = [ColorUtil getColor:@"c87a7a" alpha:1];
    }
    detailLab.text = [NSString stringWithFormat:@" (%@)",[CertificationStatusType getLabel:dto.status]];
    [self layoutSubviews];
}

- (void)showNext
{
    nextImage.hidden = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (nextImage.hidden) {
        return;
    }
    [super touchesEnded:touches withEvent:event];
}

- (void)clickCell
{
    [self.parent clickCell:nil index:index];
}

- (void)showBgView:(BOOL)tf
{
    if (isDisable == NO) {
        bgView.alpha = tf ? 0.5 : 0;
    }
}

@end
