//
//  MessagePushJobCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MessagePushJobCell.h"
#import "NSString+Extension.h"
#import "UIImageView+setImageWithURL.h"
#import "PushJobDetailDTO.h"
#import "UserDTO.h"

@interface MessagePushJobCell ()
{
    UIImageView         *iconView;
    UILabel             *nameLabel;
    UILabel             *orginLabel;
    UILabel             *contentLabel;
    UIView              *jobView;
    UIImageView         *jobIconView;
    UILabel             *jobTitleLabel;
    UILabel             *jobOrginLabel;
    UILabel             *jobContextLabel;
    UILabel             *timeLabel;
}

@end

@implementation MessagePushJobCell

#pragma mark - UI
- (void)createUI
{
    iconView = [[UIImageView alloc] init];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 20;
    [self.contentView addSubview:iconView];
    
    jobView = [[UIView alloc] init];
    jobView.backgroundColor = [ColorUtil getColor:@"f4f4f4" alpha:1.0];
    [self.contentView addSubview:jobView];
    
    jobIconView = [[UIImageView alloc] init];
    [jobView addSubview:jobIconView];
    
    nameLabel = [self createLabelFont:[UIFont systemFontOfSize:16] color:@"207878"];
    [self.contentView addSubview:nameLabel];
    orginLabel = [self createLabelFont:[UIFont systemFontOfSize:14] color:@"808080"];
    [self.contentView addSubview:orginLabel];
    contentLabel = [self createLabelFont:[UIFont systemFontOfSize:18] color:@"111726"];
    [self.contentView addSubview:contentLabel];
    timeLabel = [self createLabelFont:[UIFont systemFontOfSize:11] color:@"8d919e"];
    [self.contentView addSubview:timeLabel];
    
    jobTitleLabel = [self createLabelFont:[UIFont systemFontOfSize:16] color:@"111726"];
    [jobView addSubview:jobTitleLabel];
    jobOrginLabel = [self createLabelFont:[UIFont systemFontOfSize:14] color:@"737373"];
    [jobView addSubview:jobOrginLabel];
    jobContextLabel = [self createLabelFont:[UIFont systemFontOfSize:14] color:@"737373"];
    [jobView addSubview:jobContextLabel];
}

- (UILabel *)createLabelFont:(UIFont *)font color:(NSString *)color
{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = [ColorUtil getColor:color alpha:1.0];
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    iconView.frame = CGRectMake(15, 8, 40, 40);
    nameLabel.frame = CGRectMake(65, 8, [nameLabel.text getStringWithFont:nameLabel.font], 16);
    orginLabel.frame = CGRectMake(65, CGRectGetMaxY(nameLabel.frame) + 8, [orginLabel.text getStringWithFont:orginLabel.font], 14);
    contentLabel.frame = CGRectMake(65, CGRectGetMaxY(orginLabel.frame) + 2, [contentLabel.text getStringWithFont:contentLabel.font], 36);
    jobView.frame = CGRectMake(65, CGRectGetMaxY(contentLabel.frame), size.width - 15 - 65, 70);
    jobIconView.frame = CGRectMake(0, 0, 70, 70);
    jobTitleLabel.frame = CGRectMake(82, 11, [jobTitleLabel.text getStringWidthInWidth:(CGRectGetWidth(jobView.frame) - 92) font:jobTitleLabel.font], 16);
    jobOrginLabel.frame = CGRectMake(82, CGRectGetMaxY(jobTitleLabel.frame) + 4, [jobOrginLabel.text getStringWidthInWidth:(CGRectGetWidth(jobView.frame) - 92) font:jobOrginLabel.font], 14);
    jobContextLabel.frame = CGRectMake(82, CGRectGetMaxY(jobOrginLabel.frame) + 5, [jobContextLabel.text getStringWidthInWidth:(CGRectGetWidth(jobView.frame) - 92) font:jobContextLabel.font], 14);
    timeLabel.frame = CGRectMake(65, CGRectGetMaxY(jobView.frame) + 11, [timeLabel.text getStringWithFont:timeLabel.font], 11);
}

- (void)setInfo:(PushJobDetailDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.user.photoID];
    [iconView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"img_head.png"]];
    nameLabel.text = dto.user.name;
    orginLabel.text = dto.user.organization_name;
    contentLabel.text = @"推荐了一个新职位";
    timeLabel.text = dto.timestamp;
    [jobIconView med_setImageWithUrl:[NSURL URLWithString:[[MedGlobal getPicHost:ImageType_Orig] stringByAppendingString:dto.enterpriseLogo]] placeholderImage:[UIImage imageNamed:@"hospital_default1_icon.png"]];
    jobTitleLabel.text = dto.jobTitle;
    jobOrginLabel.text = dto.enterpriseName;
    jobContextLabel.text = [NSString stringWithFormat:@"%@ %@ %@", dto.province, [DegreeType getLabel:dto.degree], [SalaryType getLabel:dto.salary]];
}

#pragma mark - height
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 187;
}

@end
