//
//  MateUserCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateUserCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "PairDTO.h"

@implementation MateUserCell

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
    
    self.backgroundColor = [UIColor clearColor];
    
    // 昵称
    nameLab = [[UILabel alloc] initWithFrame: CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: nameLab];
    
    // 时间
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    detailLab.font = [MedGlobal getTinyLittleFont];
//    detailLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview: detailLab];
    
    selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImage.image = [ImageCenter getBundleImage:@"hidden_icon_select_image.png"];
    selectImage.userInteractionEnabled = YES;
    [self addSubview:selectImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height-2);
    footerLine.frame = CGRectMake(10, size.height-2, size.width-20, 2);
    nameLab.frame = CGRectMake(10, 20, size.width, 20);
    detailLab.frame = CGRectMake(10, 45, size.width-20, 20);
    selectImage.frame = CGRectMake(size.width-30, (size.height-20)/2, 20, 20);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    nameLab.text = dto.key;
    detailLab.text = dto.value;
    selectImage.image = dto.isSelect?[ImageCenter getBundleImage:@"hidden_icon_select_image_click.png"]:[ImageCenter getBundleImage:@"hidden_icon_select_image.png"];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 70;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

@end
