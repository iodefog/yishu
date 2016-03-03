//
//  SwitchCell.m
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "SwitchCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "PairDTO.h"
#import "FontUtil.h"

@implementation SwitchCell

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
    
    // 昵称
    titleLab = [[UILabel alloc] initWithFrame: CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [UIColor blackColor];
    titleLab.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: titleLab];
    
    // 时间
    descLab = [[UILabel alloc] initWithFrame: CGRectZero];
    descLab.backgroundColor = [UIColor clearColor];
    descLab.textColor = [ColorUtil getColor:@"A0A0A0" alpha:1];
    descLab.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview: descLab];
    
    switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchView.on = YES;
    [switchView addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:switchView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(0, size.height-1, size.width, 1);
    CGFloat titleLabHeight = [FontUtil infoHeight:titleLab.text font:titleLab.font.pointSize width:size.width-30-50];
    CGFloat descLabHeight = [FontUtil infoHeight:descLab.text font:descLab.font.pointSize width:size.width-30-50];
    if (descLabHeight > 0) {
        titleLab.frame = CGRectMake(15, size.height-3-descLabHeight-3-titleLabHeight, size.width-50-30, titleLabHeight);
        descLab.frame = CGRectMake(15, size.height-3-descLabHeight, size.width-50-30, descLabHeight);
    } else {
        titleLab.frame = CGRectMake(15, (size.height-titleLabHeight)/2, size.width-50-30, titleLabHeight);
    }
    switchView.frame = CGRectMake(size.width-65, (size.height-30)/2, 50, 30);
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    titleLab.text = dto.label;
    if (dto.value.length > 0) {
        titleLab.font = [MedGlobal getMiddleFont];
    } else {
        titleLab.font = [UIFont systemFontOfSize:18];
    }
    descLab.text = dto.value;
    switchView.on = dto.isOn;
    [self layoutSubviews];
}

- (void)switchValueChanged:(id)sender
{
    UISwitch* control = (UISwitch*)sender;
    [self.parent clickCell:idto action:[NSNumber numberWithBool:control.on]];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44;
}

- (void)showBgView:(BOOL)tf
{
    bgView.alpha = 0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}

@end
