//
//  MateUserHeaderCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateUserHeaderCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "UserDTO.h"
#import "FontUtil.h"


@implementation MateUserHeaderCell

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
    
    self.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
    
    nameLab = [[UILabel alloc] initWithFrame: CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor blackColor];
    nameLab.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: nameLab];
    
    sameNumLab = [[UILabel alloc] initWithFrame: CGRectZero];
    sameNumLab.backgroundColor = [UIColor clearColor];
    sameNumLab.textColor = [ColorUtil getColor:@"365c8a" alpha:1];
    sameNumLab.font = [MedGlobal getTinyLittleFont];
    [self.contentView addSubview: sameNumLab];
    
    phoneLab = [[UILabel alloc] initWithFrame: CGRectZero];
    phoneLab.backgroundColor = [UIColor clearColor];
    phoneLab.textColor = [UIColor lightGrayColor];
    phoneLab.font = [MedGlobal getTinyLittleFont];
    [self.contentView addSubview: phoneLab];
    
    detailBGView = [[UIView alloc] init];
    detailBGView.backgroundColor = [ColorUtil getColor:@"E9E9E9" alpha:1];
    [self addSubview:detailBGView];
    
    detailLab = [[UILabel alloc] initWithFrame: CGRectZero];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.textColor = [ColorUtil getColor:@"767676" alpha:1];
    detailLab.font = [MedGlobal getTinyLittleFont];
    detailLab.numberOfLines = 0;
    detailLab.text = @"您的朋友是下面哪个身份？\n身份确定后，TA会在您的人脉中展现，当TA注册医树后，医树会邀请TA作为您的医树好友。";
    detailLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview: detailLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;

    CGFloat width = [FontUtil getLabelWidth:nameLab labelFont:nameLab.font.pointSize];
    nameLab.frame = CGRectMake(10, 20, width, 20);
    sameNumLab.frame = CGRectMake(width+10+10, 20, size.width-width-20, 20);
    phoneLab.frame = CGRectMake(10, 45, size.width, 20);
    detailBGView.frame = CGRectMake(0, 70, size.width, 70);
    detailLab.frame = CGRectMake(15, 70, size.width-30, 70);
}

- (void)setInfo:(UserDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    nameLab.text = dto.name;
    sameNumLab.text = [NSString stringWithFormat:@"%@个同名同姓", @(dto.sameNameNum)];
    for (int i = 0; i < dto.phones.count; i ++) {
        if (i == 0) {
            phoneLab.text = [dto.phones objectAtIndex:i];
        } else {
            phoneLab.text = [NSString stringWithFormat:@"%@  %@",phoneLab.text,[dto.phones objectAtIndex:i]];
        }
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 140;
}

@end
