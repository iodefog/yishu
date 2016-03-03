


//
//  AddAcademicTagCell.m
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AddAcademicTagCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "AcademicTagDTO.h"
#import "ColorUtil.h"

@implementation AddAcademicTagCell

- (void)createUI
{
    [super createUI];
    titleLab = [[UILabel alloc] init];
    titleLab.textColor = [ColorUtil getColor:@"19233b" alpha:1];
    titleLab.font = [MedGlobal getMiddleFont];
    [self addSubview:titleLab];
    
    selectView = [[UIImageView alloc] init];
    selectView.image = [ImageCenter getBundleImage:@""];
    [self addSubview:selectView];

}


- (void)setInfo:(AcademicTagDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    titleLab.text = dto.tagName;
    if (dto.isSelect) {
        selectView.image = [ImageCenter getBundleImage:@"btn_addacademic_select.png"];
    } else if (dto.isUserTag) {
        selectView.image = [ImageCenter getBundleImage:@"choose_contact_unselected.png"];
    } else{
        selectView.image = [ImageCenter getBundleImage:@"btn_addacademic_noselect.png"];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    CGSize titleSize = [titleLab.text sizeWithAttributes:@{NSFontAttributeName:titleLab.font}];
    titleLab.frame = CGRectMake(35, (size.height-titleSize.height)/2, titleSize.width, titleSize.height);
    selectView.frame = CGRectMake(size.width-20-26, (size.height-20)/2, 20, 20);
    footerLine.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44;
}
@end
