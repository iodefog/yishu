//
//  NewCommonPersonCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewCommonPersonCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "UserDTO.h"
#import "FontUtil.h"
#import "OrganizationDTO.h"
#import "commonHelper.h"

@interface NewCommonPersonCell ()
{
   
    NSString                *dates;
}
@end

@implementation NewCommonPersonCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    //标题键
    keyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLab.backgroundColor = [UIColor clearColor];
    keyLab.textColor = [ColorUtil getColor:@"19233B" alpha:1];
    keyLab.textAlignment = NSTextAlignmentLeft;
    keyLab.font = [MedGlobal getMiddleFont];
    [self addSubview: keyLab];
    
    //标题对应的内容
    valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLab.backgroundColor = [UIColor clearColor];
    valueLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    valueLab.textAlignment = NSTextAlignmentRight;
    valueLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview: valueLab];
    
    //标题对应的内容2
    value2Lab = [[UILabel alloc] initWithFrame:CGRectZero];
    value2Lab.backgroundColor = [UIColor clearColor];
    value2Lab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    value2Lab.textAlignment = NSTextAlignmentRight;
    value2Lab.font = [MedGlobal getTinyLittleFont];
    [self addSubview: value2Lab];
    
    //时间
    timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [MedGlobal getLittleFont];
    [self addSubview: timeLab];
    
    //下一级页面指示图片
    nextImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImg.userInteractionEnabled = YES;
    nextImg.hidden = NO;
    nextImg.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImg];
    
    //开关设置
    setSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    setSwitch.hidden = YES;
    [setSwitch addTarget: self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:setSwitch];
    bgView.alpha = 0;
}

- (void)switchValueChanged:(id)sender
{
    UISwitch* control = (UISwitch*)sender;
    [self.parent clickCell:odto action:[NSNumber numberWithBool:control.on]];
 //   [self.parent2 switchValueChanged];
}

- (void)layoutSubviews
{
    OrganizationDTO *dto = odto;
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    
    //默认值
    keyLab.frame = CGRectMake(10, 12, size.width-20, 25);
    
    footerLine.frame = CGRectMake(10, size.height-0.5, size.width-20, 0.5);
    nextImg.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    
    if (odto.cellType == 0) {         //工作、教育经历列表cell
        
        if (isLastCell) {
            footerLine.hidden = YES;
        } else {
            footerLine.hidden = NO;
        }
        
        nextImg.hidden = YES;
        /*
        CGFloat width = [FontUtil getTextWidth:dto.value font:valueLab.font];
        CGFloat width2 = 0;
        if (dto.value2) {
            width2 = [FontUtil getTextWidth:dto.value2 font:value2Lab.font];
        }
         */
        //valueLab.frame = CGRectMake(10, CGRectGetMaxY(keyLab.frame)+2, width, 15);
        
        valueLab.frame = CGRectMake(10, CGRectGetMaxY(keyLab.frame)+2, size.width-15*2-80, 15);
        
        
        //value2Lab.frame = CGRectMake(CGRectGetMaxX(valueLab.frame)+10, CGRectGetMaxY(keyLab.frame)+2, width2, 15);
        timeLab.frame = CGRectMake(size.width-90, CGRectGetMaxY(keyLab.frame), 80, 15);
    } else if (odto.cellType == 1 || odto.cellType == 3 || odto.cellType == 4 || dto.cellType == 5) {  //工作，教育经历详情cell
        nextImg.hidden = NO;
        CGFloat width;
        if (odto.cellType == 1) {
            if (dto.value.length == 0 && dto.value != nil) {
                width = [FontUtil getTextWidth:dates font:valueLab.font];
            } else {
                width = [FontUtil getTextWidth:dto.value font:valueLab.font];
            }
            valueLab.frame = CGRectMake(10, CGRectGetMaxY(keyLab.frame)+2, width, 15);
        } else if (odto.cellType == 3 || dto.cellType == 5) {
            keyLab.frame = CGRectMake(10, (size.height-20)/2, size.width-20, 25);
        } else if (odto.cellType == 4) {
            keyLab.frame = CGRectMake(10, (size.height-20)/2, size.width-20, 25);
            setSwitch.hidden = NO;
            setSwitch.frame = CGRectMake(size.width-90, 10, 60, 20);
            setSwitch.on = odto.isOn;
            nextImg.hidden = YES;
        }
        if (odto.value.length == 0 && ![odto.key isEqualToString:@"时间"]) {
            keyLab.frame = CGRectMake(10, (size.height-20)/2, size.width-20, 25);
        }
    } else if (odto.cellType == 2) {  //个人主页cell
        nextImg.hidden = YES;
        CGFloat width = [FontUtil getTextWidth:dto.value font:valueLab.font];
        valueLab.frame = CGRectMake(10, CGRectGetMaxY(keyLab.frame)+2, width, 15);
        if (odto.isCommonFriend) {
            keyLab.frame = CGRectMake(10, (size.height-20)/2, size.width-20, 25);
        }
        footerLine.hidden = NO;
    }
    if (odto.isLastCell == YES) {
        footerLine.hidden = YES;
    }
    isDisable = YES;
}

- (void)setInfo:(OrganizationDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    odto = dto;
    
    keyLab.text = dto.key;
    valueLab.text = dto.value;
    
    valueLab.hidden = YES;
    value2Lab.hidden = YES;
    timeLab.hidden = YES;
    setSwitch.hidden = YES;
    
    if (odto.cellType == 0) {         //工作、教育经历列表cell
        
        value2Lab.hidden = NO;
        timeLab.hidden = NO;
        valueLab.hidden = NO;
        value2Lab.text = dto.value2;
        valueLab.textAlignment = NSTextAlignmentLeft;
        
        valueLab.text = [NSString stringWithFormat:@"%@   %@", dto.value, dto.value2];
        [self formatTime:timeLab];
    
    } else if (odto.cellType == 1 ) {  //工作、教育经历详情cell
        valueLab.hidden = NO;
        if (odto.cellType == 1 && indexPath.row != 2) {
            if (dto.value.length == 0 && dto.value != nil) {
                [self formatTime:valueLab];      
            }
        }
    } else if (odto.cellType == 2) {  //个人主页cell
        
        valueLab.hidden = NO;
        value2Lab.hidden = YES;
        timeLab.hidden = YES;
    } else if (odto.cellType == 4) {
        timeLab.hidden = YES;
    }
}

- (void)formatTime:(UILabel *)label
{
    NSString *startDate = odto.startDate;
    NSString *endDate = odto.endDate;
    
    startDate = [CommonHelper getDateWithStringToMonth:startDate];
    if ((NSObject *)endDate == [NSNull null] || endDate.length == 0) {
        endDate = @"至今";
    } else {
        endDate = [CommonHelper getDateWithStringToMonth:endDate];
    }
    dates = [NSString stringWithFormat:@"%@-%@" ,startDate, endDate];
    label.text = dates;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (touchType == 1) {
        touchType = 0;
        return;
    }
    if (odto.isCommonFriend == YES) {
        [self.parent clickCell:nil index:index];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    touchType = 1;
}


#pragma mark rewrite system method 禁用cell选中
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

@end
