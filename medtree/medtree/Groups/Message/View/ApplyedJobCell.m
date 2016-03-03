//
//  ApplyedJobCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "ApplyedJobCell.h"
// dto
#import "JobApplyDTO.h"
// util
#import "UIImageView+setImageWithURL.h"
#import <DateUtil.h>

@interface ApplyedJobCell ()
{
    UILabel             *timeLabel;
    UIView              *dividView;
    UIView              *unreadView;
    UIImageView         *iconView;
    UILabel             *titleLabel;
    UILabel             *updateTimeLabel;
    UILabel             *organizationLabel;
    UILabel             *contextLabel;
    UIImageView         *resultView;
    
    UILabel             *typeLabel;
    UILabel             *scaleLabel;
    UILabel             *levelLabel;
}

@end

@implementation ApplyedJobCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    headerLine.hidden = YES;
    timeLabel = [self createLabelFont:[MedGlobal getTinyLittleFont] color:@"737373"];
    
    unreadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    unreadView.layer.masksToBounds = YES;
    unreadView.layer.cornerRadius = 5;
    unreadView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:unreadView];
    
    dividView = [[UIView alloc] init];
    dividView.backgroundColor = [ColorUtil getColor:@"cccccc" alpha:1.0];
    [self.contentView addSubview:dividView];
    
    iconView = [[UIImageView alloc] init];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 24;
    [self.contentView addSubview:iconView];
    
    titleLabel = [self createLabelFont:[MedGlobal getLittleFont] color:@"19233b"];
    updateTimeLabel = [self createLabelFont:[MedGlobal getTinyLittleFont] color:@"737373"];
    organizationLabel = [self createLabelFont:[MedGlobal getTinyLittleFont] color:@"737373"];
    contextLabel = [self createLabelFont:[MedGlobal getTinyLittleFont] color:@"737373"];
    typeLabel = [self createLabelFont:[MedGlobal getTinyLittleFont_10] color:@"737373"];
    typeLabel.backgroundColor = [ColorUtil getColor:@"f4f4f7" alpha:1.0];
    typeLabel.layer.masksToBounds = YES;
    typeLabel.layer.cornerRadius = 11;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    scaleLabel = [self createLabelFont:[MedGlobal getTinyLittleFont_10] color:@"737373"];
    scaleLabel.backgroundColor = [ColorUtil getColor:@"f4f4f7" alpha:1.0];
    scaleLabel.layer.masksToBounds = YES;
    scaleLabel.layer.cornerRadius = 11;
    scaleLabel.textAlignment = NSTextAlignmentCenter;
    levelLabel = [self createLabelFont:[MedGlobal getTinyLittleFont_10] color:@"737373"];
    levelLabel.backgroundColor = [ColorUtil getColor:@"f4f4f7" alpha:1.0];
    levelLabel.layer.masksToBounds = YES;
    levelLabel.layer.cornerRadius = 11;
    levelLabel.textAlignment = NSTextAlignmentCenter;
    
    resultView = [[UIImageView alloc] init];
    resultView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:resultView];
}

- (UILabel *)createLabelFont:(UIFont *)font color:(NSString *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = [ColorUtil getColor:color alpha:1.0];
    [self.contentView addSubview:label];
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    CGSize timeLabelS = [timeLabel.text sizeWithAttributes:@{NSFontAttributeName:timeLabel.font}];
    timeLabel.frame = CGRectMake(15, 10, timeLabelS.width, timeLabel.font.lineHeight);
    unreadView.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 5, 12, 10, 10);
    dividView.frame = CGRectMake(15, 30, size.width - 30, 0.5);
    iconView.frame = CGRectMake(15, CGRectGetMaxY(dividView.frame) + 15, 48, 48);
    resultView.frame = CGRectMake(size.width - 86, 50, 86, 62);
    CGFloat x = CGRectGetMaxX(iconView.frame) + 10;
    CGFloat maxWidth = (CGRectGetMinX(resultView.frame) - 10) - x;
    titleLabel.frame = CGRectMake(x, CGRectGetMaxY(dividView.frame) + 15, maxWidth, titleLabel.font.lineHeight);
    organizationLabel.frame = CGRectMake(x, CGRectGetMaxY(titleLabel.frame) + 2, maxWidth, organizationLabel.font.lineHeight);
    contextLabel.frame = CGRectMake(x, CGRectGetMaxY(organizationLabel.frame) + 2, maxWidth, contextLabel.font.lineHeight);
    
    CGSize updateTimeLabelS = [updateTimeLabel.text sizeWithAttributes:@{NSFontAttributeName:updateTimeLabel.font}];
    updateTimeLabel.frame = CGRectMake(size.width - updateTimeLabelS.width - 15, 48, updateTimeLabelS.width, 12);
    typeLabel.frame = CGRectMake(x, 105, 71, 22);
    scaleLabel.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame) + 11, 105, 71, 22);
    levelLabel.frame = CGRectMake(CGRectGetMaxX(scaleLabel.frame) + 11, 105, 71, 22);
}

#pragma mark data
- (void)setInfo:(JobApplyDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    timeLabel.text = [DateUtil getDisplayTime:dto.update];
    unreadView.hidden = dto.checked;
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.avater];
    [iconView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"hospital_default_icon.png"]];
    titleLabel.text = dto.jobTitle;
    organizationLabel.text = [NSString stringWithFormat:@"%@ | %@", dto.city, dto.organization];
    contextLabel.text = [NSString stringWithFormat:@"薪资：%@", dto.salary];
    
    updateTimeLabel.text = [DateUtil getFormatTime:dto.jobUpdate format:@"MM月dd日"];
    typeLabel.text = [UnitNatureType getLabel:dto.orginType];
    scaleLabel.text = [UnitSizeType getLabel:dto.orginScale];
    levelLabel.text = [UnitLevelType getLabel:dto.orginLevel];
    NSString *imageName = nil;
    switch (dto.applyResult) {
        case ApplyResultDeliver: {
            imageName = @"resume_deliver.png";
            break;
        }
        case ApplyResultChecking: {
            imageName = @"resume_checking.png";
            break;
        }
        case ApplyResultInviteAudition: {
            imageName = @"invite_audition.png";
            break;
        }
        case ApplyResultAuditionAccess: {
            imageName = @"audition_success.png";
            break;
        }
        case ApplyResultAuditionFailure: {
            imageName = @"audition_failure.png";
            break;
        }
        case ApplyResultResumeFailure: {
            imageName = @"resume_failure.png";
            break;
        }
        case ApplyResultInviteDelivery: {
            imageName = @"invite_delivery.png";
            break;
        }
        default: {
            break;
        }
    }
    
    if (imageName != nil) {
        resultView.image = [UIImage imageNamed:imageName];
    }
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(JobApplyDTO *)dto width:(CGFloat)width
{
    return 140;
}

@end
