//
//  NewSettingCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-20.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewSettingCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "BadgeView.h"
#import "PairDTO.h"

@implementation NewSettingCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.font = [MedGlobal getLargeFont];
    [self.contentView addSubview:keyLabel];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.numberOfLines = 0;
    valueLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview:valueLabel];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"setting_img_arrow.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
    
    badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
    [self addSubview:badgeView];
    headerLine.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;

    keyLabel.frame = CGRectMake(15, size.height/2-70/2, size.width-15*2, 70);
    nextImage.frame = CGRectMake(size.width-25, (size.height-10)/2, 10, 15);
    badgeView.frame = CGRectMake(size.width-40, (size.height-10)/2, 10, 15);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    keyLabel.text = dto.label;
    index = indexPath;
    [badgeView setIsShowRoundView:dto.isShowRoundView];
    if ([dto.label isEqualToString:@"退出登录"]) {
        keyLabel.textColor = [UIColor redColor];
        keyLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        keyLabel.textColor = [UIColor darkGrayColor];
        keyLabel.textAlignment = NSTextAlignmentLeft;
    }
    nextImage.hidden = dto.accessType != 1;
    footerLine.hidden = dto.cellType == 1 ? YES : NO;
}

+ (CGFloat)getCellHeight:(PairDTO *)dto width:(CGFloat)width
{
    return 70;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end


