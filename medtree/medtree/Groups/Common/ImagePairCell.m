//
//  ImagePairCell.m
//  medtree
//
//  Created by 无忧 on 14-8-29.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "ImagePairCell.h"
#import "MedGlobal.h"
#import "PairDTO.h"
#import "ImageCenter.h"
#import "BadgeView.h"
#import "ImagePairView.h"

@implementation ImagePairCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    imageTextView = [[ImagePairView alloc] initWithFrame:CGRectZero];
    [self addSubview:imageTextView];
    
    badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
    [self addSubview:badgeView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self resize:size];
    [self bringSubviewToFront:headerLine];
    [self bringSubviewToFront:footerLine];
    imageTextView.frame = CGRectMake(0, 0, size.width, size.height);
    badgeView.frame = CGRectMake(size.width-40, (size.height-16)/2, 16, 16);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake((showLastLine || isLastCell) ? 0 : 44, size.height-1, size.width, 1);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;

    showLastLine = dto.isLastCell;
    [imageTextView setInfo:dto indexPath:indexPath];
    [badgeView setBadge:dto.badge];
    [badgeView setIsShowRoundView:dto.isShowRoundView];
    self.accessoryType = dto.accessType;

    index = indexPath;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

@end
