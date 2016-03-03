//
//  MyCollectPositionCell.m
//  medtree
//
//  Created by Jiangmm on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyCollectPositionCell.h"
#import "HomeJobChannelEmploymentDTO.h"
#import "UIImageView+setImageWithURL.h"
#import <ColorUtil.h>
#import "UIColor+Colors.h"
#define CHMargin 15

@interface MyCollectPositionCell ()

@property (nonatomic,strong) UIImageView *headImageView;    //  头像
@property (nonatomic,strong) UILabel     *jobTitleLabel;    //  职位名称
@property (nonatomic,strong) UILabel     *timeLabel;        // 发布时间
@property (nonatomic,strong) UILabel     *enterpriseLabel;  // 所属医院
@property (nonatomic,strong) UILabel     *provinceLabel;    //工作地点
@property (nonatomic,strong) UILabel     *educationLabel;   //学历要求
@property (nonatomic,strong) UILabel     *salaryLabel;      // 薪资
@property (nonatomic,strong) UILabel     *natureLabel;      //医院性质
@property (nonatomic,strong) UILabel     *rankLabel;        //医院等级
@property (nonatomic,strong) UILabel     *scaleLabel;       //医院规模

@end

@implementation MyCollectPositionCell

- (void)createUI
{
    [super createUI];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.jobTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.enterpriseLabel];
    [self.contentView addSubview:self.provinceLabel];
    [self.contentView addSubview:self.educationLabel];
    [self.contentView addSubview:self.salaryLabel];
    UIImageView *natureView = [[UIImageView alloc] init];
    natureView.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeTile];
    [natureView addSubview:self.natureLabel];

    UIImageView *rankView = [[UIImageView alloc] init];
    rankView.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeTile];
    [rankView addSubview:self.rankLabel];
   
    UIImageView *scaleView = [[UIImageView alloc] init];
    scaleView.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(5, 10, 5, 10) resizingMode:UIImageResizingModeTile];
    [scaleView addSubview:self.scaleLabel];
   
    [self.contentView addSubview:natureView];
    [self.contentView addSubview:rankView];
    [self.contentView addSubview:scaleView];

    CGFloat width = self.frame.size.width;
    self.headImageView.frame = CGRectMake(CHMargin, CHMargin, 50, 50);
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jobTitleLabel.centerY);
        make.right.equalTo(-CHMargin);
    }];
    self.jobTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 10, 10, width - CHMargin * 2 - 60, 18);
    self.enterpriseLabel.frame = CGRectMake(CGRectGetMinX(self.jobTitleLabel.frame), CGRectGetMaxY(self.jobTitleLabel.frame) + 6, width - CGRectGetMinX(self.jobTitleLabel.frame) - CHMargin, 14);
    self.provinceLabel.frame = CGRectMake(CGRectGetMinX(self.enterpriseLabel.frame), CGRectGetMaxY(self.enterpriseLabel.frame) + 6, width - CGRectGetMinX(self.enterpriseLabel.frame) - 15, 14);
    natureView.frame = CGRectMake(73, CGRectGetMaxY(self.provinceLabel.frame) + 12,70,20);
    self.natureLabel.frame = CGRectMake(0, 5, 70, 10);
    rankView.frame = CGRectMake(CGRectGetMaxX(natureView.frame) + 11, CGRectGetMaxY(self.provinceLabel.frame) + 12,70 ,20);
    self.rankLabel.frame = CGRectMake(0, 5, 70, 10);
    scaleView.frame = CGRectMake(CGRectGetMaxX(rankView.frame) + 11, CGRectGetMaxY(self.provinceLabel.frame) + 12, 70, 20);
    self.scaleLabel.frame = CGRectMake(0, 5, 70, 10);
}

- (void)setInfo:(HomeJobChannelEmploymentDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.imageURL];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:imageURL]
                           placeholderImage:GetImage(@"hospital_default_icon.png")];
    self.jobTitleLabel.text = dto.employmentTitle;
    self.timeLabel.text = dto.publishTime;
    self.enterpriseLabel.text = dto.enterpriseName;
    self.provinceLabel.text = [NSString stringWithFormat:@"%@   %@   %@",dto.enterprisePlace,dto.educationRequirements,dto.salary];
    self.natureLabel.text = dto.enterpriseNature;
    self.rankLabel.text = dto.enterpriseLevel;
    self.scaleLabel.text = dto.enterpriseSize;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 107;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 25.0f;
            imageView.clipsToBounds = YES;
            imageView.image = GetImage(@"hospital_default_icon.png");
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)jobTitleLabel
{
    if (!_jobTitleLabel) {
        _jobTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [ColorUtil getColor:@"19233b" alpha:1.0];
            label.font = [UIFont systemFontOfSize:16];
            label;
        });
    }
    return _jobTitleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            
            [self getRadiusMidLabel];

        });
    }
    return _timeLabel;
}
- (UILabel *)enterpriseLabel
{
    if (!_enterpriseLabel) {
        _enterpriseLabel = ({
            
            [self getRadiusMidLabel];

        });
    }
    return _enterpriseLabel;
}

- (UILabel *)provinceLabel
{
    if (!_provinceLabel) {
        _provinceLabel = ({
            
            [self getRadiusMidLabel];

        });
    }
    return _provinceLabel;
}
- (UILabel *)educationLabel
{
    if (!_educationLabel) {
        _educationLabel = ({
            
            [self getRadiusMidLabel];

        });
    }
    return _educationLabel;
}

- (UILabel *)salaryLabel
{
    if (!_salaryLabel) {
        _salaryLabel = ({
            [self getRadiusMidLabel];
        });
    }
    return _salaryLabel;
}

- (UILabel *)natureLabel
{
    if (!_natureLabel) {
        _natureLabel = ({
            [self getRadiusSmallLabel];
        });
    }
    return _natureLabel;
}

- (UILabel *)rankLabel
{
    if (!_rankLabel) {
        _rankLabel = ({
            [self getRadiusSmallLabel];
        });
    }
    return _rankLabel;
}

- (UILabel *)scaleLabel
{
    if (!_scaleLabel) {
        _scaleLabel = ({
           [self getRadiusSmallLabel];
        });
    }
    return _scaleLabel;
}

- (UILabel *)getRadiusMidLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    return label;

}

- (UILabel *)getRadiusSmallLabel{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:10];
  
   return  label;
}

- (void)setLastCell:(BOOL)lastCell
{
    [super setLastCell:lastCell];
    if (lastCell) {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(0.5);
        }];
    } else {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(0);
            make.height.equalTo(0.5);
        }];
    }
}

@end
