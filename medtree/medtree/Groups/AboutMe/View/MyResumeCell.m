
//
//  MyResumeCell.m
//  medtree
//
//  Created by 边大朋 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyResumeCell.h"
#import "MedGlobal.h"
#import "ImageCenter.h"
#import "ResumeDTO.h"
#import "FontUtil.h"
#import "ExperienceDTO.h"
#import "DepartmentNameDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "CommonHelper.h"
#import "NSString+Extension.h"

#define MARGIN 15
#define HEADER 34
#define NEXT_IMAGE_WIDTH 5
#define NEXT_IMAGE_HEIGHT 10

@interface MyResumeCell ()
{
    UILabel         *keyLabel;
    UILabel         *valueLabel;
    UIImageView     *nextView;
    UIImageView     *headerView;
    UILabel         *experienceTimeLabel;
    UISwitch        *switchButton;
}
@end

@implementation MyResumeCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    self.backgroundColor = [ColorUtil getColor:@"F1F1F5" alpha:1];

    keyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    keyLabel.backgroundColor = [UIColor clearColor];
    keyLabel.textColor = [ColorUtil getColor:@"141A2D" alpha:1];
    keyLabel.textAlignment = NSTextAlignmentLeft;
    keyLabel.font = [MedGlobal getMiddleFont];
    [self.contentView addSubview: keyLabel];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textColor = [ColorUtil getColor:@"606060" alpha:1];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.font = [MedGlobal getLittleFont];
    [self.contentView addSubview: valueLabel];

    headerView = [[UIImageView alloc] init];
    headerView.layer.cornerRadius = HEADER / 2;
    headerView.layer.masksToBounds = YES;
    headerView.userInteractionEnabled = YES;
    headerView.hidden = YES;
    [self.contentView addSubview:headerView];
    
    nextView = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextView.userInteractionEnabled = YES;
    nextView.hidden = NO;
    nextView.image = [ImageCenter getBundleImage:@"img_next.png"];
    [self.contentView addSubview:nextView];
    
    experienceTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    experienceTimeLabel.backgroundColor = [UIColor clearColor];
    experienceTimeLabel.textColor = [ColorUtil getColor:@"606060" alpha:1];
    experienceTimeLabel.textAlignment = NSTextAlignmentLeft;
    experienceTimeLabel.font = [MedGlobal getTinyLittleFont];
    [self.contentView addSubview: experienceTimeLabel];
    
    switchButton = [[UISwitch alloc] init];
    [switchButton addTarget:self action:@selector(clickSwitch) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGSize keySize = [keyLabel.text sizeWithAttributes:@{NSFontAttributeName:keyLabel.font}];
    CGSize valueSize = [valueLabel.text sizeWithAttributes:@{NSFontAttributeName:valueLabel.font}];
    
    footerLine.frame = CGRectMake(MARGIN, size.height - 0.5, size.width - MARGIN * 2, 0.5);
    nextView.frame = CGRectMake(size.width - MARGIN - NEXT_IMAGE_WIDTH, (size.height - NEXT_IMAGE_HEIGHT) * 0.5, NEXT_IMAGE_WIDTH, NEXT_IMAGE_HEIGHT);
    headerView.frame = CGRectMake(size.width - MARGIN - NEXT_IMAGE_WIDTH - HEADER - 5, (size.height - HEADER) / 2, HEADER, HEADER);
    
    CGFloat maxWith = size.width - MARGIN * 2 - NEXT_IMAGE_WIDTH;
    if (keySize.width > maxWith) {
        keyLabel.frame = CGRectMake(MARGIN, (size.height - keySize.height) / 2, maxWith, keySize.height);
    } else {
        keyLabel.frame = CGRectMake(MARGIN, (size.height - keySize.height) / 2, keySize.width, keySize.height);
    }
    
    CGFloat maxValueLabelW = size.width - MARGIN * 2 - keySize.width - 5 - CGRectGetWidth(nextView.frame);
    if (maxValueLabelW < valueSize.width) {
        valueLabel.frame = CGRectMake(CGRectGetMaxX(keyLabel.frame), (size.height - valueSize.height) / 2, maxValueLabelW, valueSize.height);
    } else {
        valueLabel.frame = CGRectMake(size.width - valueSize.width - MARGIN - CGRectGetWidth(nextView.frame) - 5, (size.height - valueSize.height) / 2, valueSize.width, valueSize.height);
    }
    
    if (((ResumeDTO *)idto).resumeRowType == ResumeRowTypeSelfIntroduction
        || ((ResumeDTO *)idto).resumeRowType == ResumeRowTypeHonour
        || ((ResumeDTO *)idto).resumeRowType == ResumeRowTypeInterest) {
        valueSize = [valueLabel.text sizefitLabelInSize:CGSizeMake(maxWith, MAXFLOAT) Font:valueLabel.font];
        valueLabel.frame = CGRectMake(MARGIN, 12, maxWith, valueSize.height);
    }
    
    switchButton.frame = CGRectMake(size.width - MARGIN - switchButton.frame.size.width, (size.height - switchButton.frame.size.height) * 0.5, switchButton.frame.size.width, switchButton.frame.size.height);
}

#pragma mark - data
- (void)setInfo:(ResumeDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    keyLabel.text = dto.key;
    valueLabel.text = dto.value;
    
    if (dto.resumeRowType == ResumeRowTypeSelfIntroduction || dto.resumeRowType == ResumeRowTypeHonour || ((ResumeDTO *)idto).resumeRowType == ResumeRowTypeInterest) {
        valueLabel.numberOfLines = 0;
    } else {
        valueLabel.numberOfLines = 1;
    }
    
    if (dto.resumeRowType == ResumeRowTypePic) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big], dto.value];
        [headerView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[ImageCenter getBundleImage:@"img_head.png"]];
        headerView.hidden = NO;
        valueLabel.hidden = YES;
    } else {
        headerView.hidden = YES;
        valueLabel.hidden = NO;
    }

    if (dto.resumeRowType == ResumeRowTypePrivacy) {
        switchButton.hidden = NO;
        switchButton.on = dto.isOn;
        nextView.hidden = YES;
    } else {
        nextView.hidden = NO;
        switchButton.hidden = YES;
    }
    
    footerLine.hidden = !dto.isShowFootLine;
}

#pragma mark - click
- (void)clickSwitch
{
    [self.parent clickCell:@(switchButton.isOn) action:@(1000)];
}

#pragma mark - height
+ (CGFloat)getCellHeight:(ResumeDTO *)dto width:(CGFloat)width
{
    if (dto.resumeRowType == ResumeRowTypeSelfIntroduction || dto.resumeRowType == ResumeRowTypeHonour) {
        CGSize valueMaxSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN * 2 - NEXT_IMAGE_WIDTH, CGFLOAT_MAX);
        CGSize valueSize = [dto.value sizefitLabelInSize:valueMaxSize Font:[MedGlobal getLittleFont]];
        CGFloat height = valueSize.height + 12 + 12;
        if (height > 75) {
            return height;
        }
        return  75;
    } else if (dto.resumeRowType == ResumeRowTypeInterest) {
        CGSize valueMaxSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - MARGIN * 2 - NEXT_IMAGE_WIDTH, CGFLOAT_MAX);
        CGSize valueSize = [dto.value sizefitLabelInSize:valueMaxSize Font:[MedGlobal getLittleFont]];
        return valueSize.height + 12 + 12;
    }
    return 65;
}

@end
