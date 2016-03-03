//
//  PairCell.m
//  medtree
//
//  Created by sam on 8/18/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "PairCell.h"
#import "PairDTO.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "BadgeView.h"

@implementation PairCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];

    self.backgroundColor = [UIColor whiteColor];
    
    keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview:keyLabel];

    valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.numberOfLines = 0;
    valueLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview:valueLabel];

    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    nextImage.userInteractionEnabled = YES;
    [self addSubview:nextImage];
    
    badgeView = [[BadgeView alloc] initWithFrame:CGRectZero];
    [self addSubview:badgeView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self resize:self.frame.size];
    if (((PairDTO *)idto).cellType == PairCell_Type_RIGHT_LEFT) {
        keyLabel.frame = CGRectMake(20, 12, 70, 20);
        valueLabel.frame = CGRectMake(100, 12, size.width-130, 20);
    } else if (((PairDTO *)idto).cellType == PairCell_Type_LEFT_RIGHT) {
        keyLabel.frame = CGRectMake(20, 12, size.width-100, 20);
        valueLabel.frame = CGRectMake(size.width-100, 12, 70, 20);
    } else if (((PairDTO *)idto).cellType == PairCell_Type_TOP_BOTTOM) {
        keyLabel.frame = CGRectMake(20, 5, size.width-40, 20);
        valueLabel.frame = CGRectMake(20, 28, size.width-40, 20);
    } else if (((PairDTO *)idto).cellType == PairCell_Type_CENTER) {
        keyLabel.frame = CGRectMake(20, 12, size.width-40, 20);
    } else {
        keyLabel.frame = CGRectMake(20, 12, size.width-40, 20);
    }
    nextImage.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(isLastCell ? 0 : 20, size.height-1, size.width, 1);
    badgeView.frame = CGRectMake(size.width-40, (size.height-16)/2, 16, 16);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    keyLabel.text = dto.label;
    valueLabel.text = dto.value;
    [badgeView setIsShowRoundView:dto.isShowRoundView];
    if (dto.cellType == PairCell_Type_RIGHT_LEFT) {
        keyLabel.textAlignment = NSTextAlignmentRight;
        valueLabel.textAlignment = NSTextAlignmentLeft;
    } else if (dto.cellType == PairCell_Type_LEFT_RIGHT) {
        keyLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textAlignment = NSTextAlignmentRight;
    } else if (dto.cellType == PairCell_Type_TOP_BOTTOM) {
        keyLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textAlignment = NSTextAlignmentLeft;
        valueLabel.textColor = [UIColor lightGrayColor];
    } else if (dto.cellType == PairCell_Type_CENTER) {
        keyLabel.textAlignment = NSTextAlignmentCenter;
    } else {
        keyLabel.textAlignment = NSTextAlignmentLeft;
    }
    if ([dto.label isEqualToString:@"退出登录"]) {
        keyLabel.textColor = [UIColor redColor];
    }
    [self layoutSubviews];
    nextImage.hidden = dto.accessType == UITableViewCellAccessoryNone;
    //
    index = indexPath;
}

+ (CGFloat)getCellHeight:(PairDTO *)dto width:(CGFloat)width
{
    CGFloat height = 44;
    if (dto.cellType == PairCell_Type_TOP_BOTTOM) {
        height = 54;
    }
    return height;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

@end
