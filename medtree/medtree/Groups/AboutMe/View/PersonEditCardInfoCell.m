//
//  PersonEditCardInfoCell.m
//  medtree
//
//  Created by 陈升军 on 15/8/4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PersonEditCardInfoCell.h"
#import "UserDTO.h"
//#import "PersonCardInfoAcademicTagsView.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "Pair3DTO.h"
#import "FontUtil.h"

@implementation PersonEditCardInfoCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    /**编辑提示视图**/
    editView = [[UIView alloc] init];
    [self addSubview:editView];
    
    editHeaderLine = [[UILabel alloc] init];
    editHeaderLine.backgroundColor = [ColorUtil getColor:@"D6D6D6" alpha:1];
    [editView addSubview:editHeaderLine];
    
    editHintLab = [[UILabel alloc] init];
    editHintLab.textColor = [ColorUtil getColor:@"626262" alpha:1];
    editHintLab.backgroundColor = [UIColor clearColor];
    editHintLab.font = [MedGlobal getLittleFont];
    editHintLab.text = @"名片信息";
    [editView addSubview:editHintLab];
    
    editStatueLab = [[UILabel alloc] init];
    editStatueLab.textColor = [ColorUtil getColor:@"365C8A" alpha:1];
    editStatueLab.backgroundColor = [UIColor clearColor];
    editStatueLab.text = @"(待完善)";
    editStatueLab.font = [MedGlobal getLittleFont];
    [editView addSubview:editStatueLab];
    
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:[ImageCenter getNamedImage:@"person_info_edit_image.png"] forState:UIControlStateNormal];
    [editButton setBackgroundImage:[ImageCenter getNamedImage:@"person_info_edit_image_click.png"] forState:UIControlStateHighlighted];
    [editButton addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
    [editView addSubview:editButton];
    
    editFootLine = [[UILabel alloc] init];
    editFootLine.backgroundColor = [ColorUtil getColor:@"D6D6D6" alpha:1];
    [editView addSubview:editFootLine];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    editView.frame = CGRectMake(0, 0, size.width, size.height);
    editHeaderLine.frame = CGRectMake(0, 10, size.width, 0.5);
    CGFloat width = [FontUtil getTextWidth:editHintLab.text font:editHintLab.font];
    editHintLab.frame = CGRectMake(15, 10, width, size.height-10);
    editStatueLab.frame = CGRectMake(15+width, 10, 200, size.height-10);
    editButton.frame = CGRectMake(size.width-15-46, 10, 46, 44);
    editFootLine.frame = CGRectMake(15, size.height-0.5, size.width-30, 0.5);
}

- (void)clickEdit
{
    [self.parent clickCell:idto index:index];
}

- (void)setInfo:(Pair3DTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    if (dto.key.length > 0) {
        editStatueLab.hidden = NO;
    } else {
        editStatueLab.hidden = YES;
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44+10;
}

@end
