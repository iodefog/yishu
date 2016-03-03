//
//  MyIntegralCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MyIntegralCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "PairDTO.h"


@implementation MyIntegralCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [MedGlobal getMiddleFont];
    titleLab.text = @"";
    [self addSubview:titleLab];
    
    detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.font = [MedGlobal getLittleFont];
    detailLab.textColor = [UIColor lightGrayColor];
    detailLab.text = @"";
    [self addSubview:detailLab];
    
    nextImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImage.userInteractionEnabled = YES;
    nextImage.hidden = NO;
    nextImage.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImage];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    [self resize:size];
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    bgView.frame = CGRectMake(0, 0, size.width, size.height-1);
    footerLine.frame = CGRectMake(isLastCell?0:15, size.height-1, size.width-2*(isLastCell?0:15), 1);
    titleLab.frame = CGRectMake(15, 0, size.width-30, size.height);
    nextImage.frame = CGRectMake(size.width-20, (size.height-10)/2, 5, 10);
    detailLab.frame = CGRectMake(size.width-[FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize]-40, 0, size.width-[FontUtil getLabelWidth:detailLab labelFont:detailLab.font.pointSize], size.height);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    titleLab.text = dto.key;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 50;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

@end
