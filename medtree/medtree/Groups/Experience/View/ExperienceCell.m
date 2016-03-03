//
//  ExperienceCell.m
//  medtree
//
//  Created by 边大朋 on 15/6/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceCell.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "ExperienceDTO.h"
#import "CommonHelper.h"
#import "FontUtil.h"
#import "DepartmentNameDTO.h"
#import "CertificationStatusType.h"

@interface ExperienceCell () <UIGestureRecognizerDelegate>
{
    //经历时间
    NSString *experienceInterval;
    
    //机构、学校
    UILabel *orgLab;
    //部门、学科
    UILabel *depLab;
    //工作职称、学历
    UILabel *titleLab;
    //时间
    UILabel *timeLab;
    //是否认证
    UIButton *certBtn;
}

@end
@implementation ExperienceCell

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];
    orgLab = [[UILabel alloc] initWithFrame:CGRectZero];
    orgLab.backgroundColor = [UIColor clearColor];
    orgLab.textColor = [ColorUtil getColor:@"19233B" alpha:1];
    orgLab.textAlignment = NSTextAlignmentLeft;
    orgLab.font = [MedGlobal getMiddleFont];
    [self addSubview: orgLab];
    
    depLab = [[UILabel alloc] initWithFrame:CGRectZero];
    depLab.numberOfLines = 1;
    depLab.backgroundColor = [UIColor clearColor];
    depLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    depLab.textAlignment = NSTextAlignmentLeft;
    depLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview: depLab];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    titleLab.textAlignment = NSTextAlignmentRight;
    titleLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview: titleLab];
    
    timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.backgroundColor = [UIColor clearColor];
    timeLab.textColor = [ColorUtil getColor:@"737373" alpha:1];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [MedGlobal getLittleFont];
    [self addSubview: timeLab];
    
    certBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certBtn.titleLabel.textColor = [UIColor whiteColor];
    certBtn.layer.cornerRadius = 3;
    certBtn.layer.masksToBounds = YES;
    certBtn.titleLabel.font = [MedGlobal getTinyLittleFont];
    [self addSubview: certBtn];
    [self createPan];
}

- (void)setInfo:(ExperienceDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    orgLab.text = dto.org;
    NSString *depAndTitle = [NSString stringWithFormat:@"%@   %@", dto.department.name, dto.title];
    depLab.text = depAndTitle;
    
    certBtn.hidden = dto.isShowVerify;
    if (dto.experienceCertStatus == CertificationStatusType_No) {
        [certBtn setTitle:@"立即认证" forState:UIControlStateNormal];
        certBtn.backgroundColor = [ColorUtil getColor:@"D6D7D9" alpha:1];
        [certBtn addTarget:self action:@selector(clickToCert) forControlEvents:UIControlEventTouchUpInside];
    } else if (dto.experienceCertStatus == CertificationStatusType_Pass) {
        [certBtn setTitle:@"已认证" forState:UIControlStateNormal];
        certBtn.backgroundColor = [ColorUtil getColor:@"1EBAB5" alpha:1];
    } else if (dto.experienceCertStatus == CertificationStatusType_Wait) {
        [certBtn setTitle:@"认证中" forState:UIControlStateNormal];
        certBtn.backgroundColor = [ColorUtil getColor:@"CD7336" alpha:1];
    } else {
        [certBtn setTitle:@"认证失败" forState:UIControlStateNormal];
        certBtn.backgroundColor = [ColorUtil getColor:@"AC363B" alpha:1];
    }
    [self formatTimeWithStartDate:dto.startDate endDate:dto.endDate];
}

- (void)formatTimeWithStartDate:(NSString *)startDate endDate:(NSString *)endDate
{
    startDate = [CommonHelper getDateWithStringToMonth:startDate];
    if ((NSObject *)endDate == [NSNull null] || endDate.length == 0) {
        endDate = @"至今";
    } else {
        endDate = [CommonHelper getDateWithStringToMonth:endDate];
    }
    
    experienceInterval = [NSString stringWithFormat:@"%@-%@" ,startDate, endDate];
    timeLab.text = experienceInterval;
}

#pragma mark - click
- (void)clickToCert
{
    [self.parent clickCell:idto action:@(ExperienceAction_GoToCert)];
}

/** 用来屏蔽点击事件 */
- (void)createPan
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
}

- (void)deleteCell
{
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    CGFloat space = 10;
    orgLab.frame = CGRectMake(space, 12, size.width-space*2-45-space, 25);
    depLab.frame = CGRectMake(10, CGRectGetMaxY(orgLab.frame) + 2, size.width-space * 2 - 80, 15);
    
    NSString *text = [certBtn titleForState:UIControlStateNormal];
    CGSize certSize = [text sizeWithAttributes:@{NSFontAttributeName:certBtn.titleLabel.font}];
    if (!certBtn.hidden) {
        certBtn.frame = CGRectMake(size.width - certSize.width - 5 - 15, 12, certSize.width + 5, 25);
    }
    timeLab.frame = CGRectMake(size.width-90, depLab.frame.origin.y, 80, 15);
}

- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}
@end
