//
//  PersonEditCell.m
//  medtree
//
//  Created by 边大朋 on 15-3-30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonEditCell.h"
#import "ColorUtil.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "UserDTO.h"
#import "PairDTO.h"
#import "FontUtil.h"
#import "UIImageView+setImageWithURL.h"
#import "AccountHelper.h"

@interface NewPersonEditCell ()<UITextFieldDelegate>
{
    UITextField         *textField;
    UILabel             *keyLab;     //标题
    UILabel             *valueLab;   //标题文字内容
    UIImageView         *headImg;    //标题头像图片
    UIImageView         *nextImg;    //下一页图片
    
    NSString            *imagePath;  //头像地址
}
@end

@implementation NewPersonEditCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    //标题键
    keyLab = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLab.backgroundColor = [UIColor clearColor];
    keyLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
    keyLab.textAlignment = NSTextAlignmentLeft;
    keyLab.font = [MedGlobal getMiddleFont];
    [self addSubview: keyLab];
    
    //标题对应的内容
    valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLab.backgroundColor = [UIColor clearColor];
    valueLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
    valueLab.textAlignment = NSTextAlignmentLeft;
    valueLab.font = [MedGlobal getLittleFont];
    [self addSubview: valueLab];
    
    //头像
    headImg = [[UIImageView alloc] init];
    headImg.layer.cornerRadius = 17;
    headImg.layer.masksToBounds = YES;
    headImg.userInteractionEnabled = YES;
    headImg.hidden = YES;
    [self addSubview:headImg];
    
    //下一级页面指示图片
    nextImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextImg.userInteractionEnabled = YES;
    nextImg.hidden = NO;
    nextImg.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self addSubview:nextImg];
    
    textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.hidden = YES;
    textField.delegate = self;
    textField.textAlignment = NSTextAlignmentRight;
    textField.returnKeyType = UIReturnKeyDone;
    [self addSubview:textField];
}

- (void)layoutSubviews
{
    PairDTO *dto = (PairDTO *)idto;
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat width = [FontUtil getTextWidth:dto.value font:valueLab.font];
    CGFloat height = [FontUtil getTextWidth:dto.value font:valueLab.font];
    //默认值
    keyLab.frame = CGRectMake(10, 0, 75, size.height);
    valueLab.frame = CGRectMake(size.width-width-20, (size.height-height)/2, width, height);
    footerLine.frame = CGRectMake(10, size.height-0.5, size.width-20, 0.5);
    
    nextImg.frame = CGRectMake(size.width-15, (size.height-10)/2, 5, 10);
    
    if(dto.cellType == 0) {
        headImg.frame = CGRectMake(size.width-55, (size.height-34)/2, 34, 34);
        headImg.hidden = NO;
        //footerLine.hidden = YES;
    } else if (dto.cellType == 1) {
        if([dto.value isEqualToString:@"待完善"]) {
            valueLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
        }
        if (index.row == 4) {
            footerLine.hidden = YES;
        }
    } else if (dto.cellType == 2) {
        if(![dto.value isEqualToString:@"待完善"]) {
            valueLab.font = [MedGlobal getTinyLittleFont];
            CGFloat vwidth = [FontUtil getTextWidth:dto.value font:valueLab.font];
            if (vwidth > size.width - 45) {
                vwidth = size.width - 45;
            }
            keyLab.frame = CGRectMake(10, 10, 75, 25);
            valueLab.frame = CGRectMake(10, CGRectGetMaxY(keyLab.frame) - 3, vwidth, 20);
        } else {
            valueLab.font = [MedGlobal getMiddleFont];
            width = [FontUtil getTextWidth:dto.value font:valueLab.font];
            valueLab.frame = CGRectMake(size.width-width-20, (size.height-20)/2, width, 20);
        }
        valueLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
        if (index.row == 8) {
            footerLine.hidden = YES;
        }
        if (dto.accessType == 1) {
            nextImg.hidden = YES;
        }
    } else if (dto.cellType == 3) {
        nextImg.hidden = YES;
        valueLab.frame = CGRectMake(size.width-100, (size.height-20)/2, 80, 20);
        headImg.hidden = YES;
        footerLine.hidden = NO;
        if (dto.accessType == 1) {
            valueLab.frame = CGRectMake(size.width-80, (size.height-20)/2, 80, 20);
            valueLab.textColor = [ColorUtil getColor:@"878787" alpha:1];
        } else {
            valueLab.textColor = [ColorUtil getColor:@"000000" alpha:1];
        }
    }
    
    if (index.row == 2) {
        textField.frame = CGRectMake(size.width-160, (size.height-20)/2, 140, 20);
    }
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    keyLab.text = dto.key;
    valueLab.text = dto.value;

    if (indexPath.row == 0) {
        valueLab.text = @"";
        if ([imagePath isEqualToString:dto.value] == NO) {
            NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], dto.value];
            [headImg med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"img_head.png"]];
            imagePath = dto.value;
        }
    }
}

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

//- (BOOL)textFieldShouldReturn:(UITextField *)field
//{
//    NSArray *array = [NSArray arrayWithObjects:field, valueLab, nil];
//    [self.parent clickCell:array index:index];
//    return YES;
//}

@end
