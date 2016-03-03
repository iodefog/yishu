//
//  NewPersonIdentificationCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonIdentificationCell.h"
#import "ColorUtil.h"
#import "FontUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "CertificationDTO.h"
#import "UserType.h"
#import "CertificationStatusType.h"


@implementation NewPersonIdentificationCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    
    titleLab = [[UILabel alloc] init];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.font = [MedGlobal getMiddleFont];
    [self addSubview:titleLab];
    
    detailLab = [[UILabel alloc] init];
    detailLab.backgroundColor = [UIColor clearColor];
    detailLab.font = [MedGlobal getTinyLittleFont];
    detailLab.textColor = [UIColor lightGrayColor];
    [self addSubview:detailLab];
    
    statuLab = [[UILabel alloc] init];
    statuLab.textColor = [UIColor whiteColor];
    statuLab.backgroundColor = [UIColor lightGrayColor];
    statuLab.textAlignment = NSTextAlignmentCenter;
    statuLab.font = [MedGlobal getLittleFont];
    [self addSubview:statuLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    if (detailLab.text.length > 0) {
        titleLab.frame = CGRectMake(15, 10, size.width, 30);
        detailLab.frame = CGRectMake(15, 35, size.width-95, 20);
    } else {
        titleLab.frame = CGRectMake(15, 0, size.width, size.height);
    }
    
    statuLab.frame = CGRectMake(size.width-80, 15, 65, 30);
}

- (void)setInfo:(CertificationDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    titleLab.text = [UserType getShortLabel:dto.userType];
    statuLab.text = [NSString stringWithFormat:@" %@",[CertificationStatusType getLabel:dto.status]];
    if (dto.status == CertificationStatusType_Wait) {//认证中
        statuLab.backgroundColor = [ColorUtil getColor:@"D88745" alpha:1];
    } else if (dto.status == CertificationStatusType_Pass) {//已认证
        statuLab.backgroundColor = [ColorUtil getColor:@"365c8a" alpha:1];
    } else if (dto.status == CertificationStatusType_No) {//未认证
        statuLab.backgroundColor = [ColorUtil getColor:@"DFDFDF" alpha:1];
    } else {
        statuLab.text = @"认证失败";
        statuLab.backgroundColor = [ColorUtil getColor:@"BC4B4B" alpha:1];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

@end
