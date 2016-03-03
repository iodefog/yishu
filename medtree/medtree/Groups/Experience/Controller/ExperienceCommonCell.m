//
//  ExperienceCommonCell.m
//  medtree
//
//  Created by 边大朋 on 15/6/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceCommonCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "OrganizationNameDTO.h"
#import "DepartmentNameDTO.h"
#import "ProvinceDTO.h"
#import "TitleDTO.h"

@implementation ExperienceCommonCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    keyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLab.backgroundColor = [UIColor clearColor];
    keyLab.textColor = [ColorUtil getColor:@"19233B" alpha:1];
    keyLab.textAlignment = NSTextAlignmentLeft;
    keyLab.font = [MedGlobal getMiddleFont];
    [self addSubview: keyLab];
    
    valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLab.backgroundColor = [UIColor clearColor];
    valueLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    valueLab.textAlignment = NSTextAlignmentLeft;
    valueLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview: valueLab];
    
    nextImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImg.userInteractionEnabled = YES;
    nextImg.hidden = YES;
    nextImg.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImg];
    
    selectImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    selectImage.userInteractionEnabled = YES;
    selectImage.hidden = YES;
    selectImage.image = [ImageCenter getBundleImage:@"img_cell_checked.png"];
    [self addSubview:selectImage];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    CGFloat space = 10;
    keyLab.frame = CGRectMake(space, (size.height-20)/2, size.width-20, 25);
    valueLab.frame = CGRectMake(space, CGRectGetMaxY(keyLab.frame)+2, 200, 15);
    selectImage.frame = CGRectMake(size.width-30, (size.height-16)/2, 16, 16);
    if (valueLab.text.length > 0) {
        keyLab.frame = CGRectMake(space, ((size.height-(25+15+2))/2), size.width-20, 25);
        valueLab.frame = CGRectMake(space, CGRectGetMaxY(keyLab.frame)+2, 200, 15);
    }
    nextImg.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
}

#pragma mark - 数据源
- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;

    if ([dto isKindOfClass:[ProvinceDTO class]]) { // 省份
        nextImg.hidden = NO;
        keyLab.text = [(ProvinceDTO *)idto name];
    } else if ([dto isKindOfClass:[OrganizationNameDTO class]]) { // 机构cell
        keyLab.text = [(OrganizationNameDTO *)idto name];
    } else if ([dto isKindOfClass:[DepartmentNameDTO class]]) { // 部门cell
        keyLab.text = [(DepartmentNameDTO *)idto name];
        if ([(DepartmentNameDTO *)idto hasChild]) {
            nextImg.hidden = NO;
        } else {
            nextImg.hidden = YES;
        }
    } else if ([dto isKindOfClass:[TitleDTO class]]) { // 职称cell
        keyLab.text = [(TitleDTO *)dto title];
        selectImage.hidden = ![(TitleDTO *)dto isSelected];
    }
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end
