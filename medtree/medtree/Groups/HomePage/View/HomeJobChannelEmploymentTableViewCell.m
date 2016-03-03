//
//  HomeJobChannelRecommendTableViewCell.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelEmploymentTableViewCell.h"
#import "HomeJobChannelEmploymentDTO.h"
#import "UIImageView+setImageWithURL.h"
#import "UIColor+Colors.h"

@interface HomeJobChannelEmploymentTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *jobTitleLabel;
@property (nonatomic, strong) UILabel *enterpriseLabel;
@property (nonatomic, strong) UILabel *salaryLabel;
@property (nonatomic, strong) UILabel *natureLabel;
@property (nonatomic, strong) UILabel *levelLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation HomeJobChannelEmploymentTableViewCell

- (void)createUI
{
    [super createUI];
        
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.jobTitleLabel];
    [self.contentView addSubview:self.enterpriseLabel];
    [self.contentView addSubview:self.salaryLabel];
    [self.contentView addSubview:self.natureLabel];
    
    UIImageView *natureBackView = ({
        UIImageView *view = [UIImageView new];
        view.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)
                                                                resizingMode:UIImageResizingModeTile];
        view;
    });
    
    UIImageView *levelBackView = ({
        UIImageView *view = [UIImageView new];
        view.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)
                                                                resizingMode:UIImageResizingModeTile];
        view;
    });

    UIImageView *sizeBackView = ({
        UIImageView *view = [UIImageView new];
        view.image = [GetImage(@"corner_bg.png") resizableImageWithCapInsets:UIEdgeInsetsMake(10, 15, 10, 15)
                                                                resizingMode:UIImageResizingModeTile];
        view;
    });

    [self.contentView addSubview:natureBackView];
    [self.contentView addSubview:levelBackView];
    [self.contentView addSubview:sizeBackView];
    [self.contentView addSubview:self.levelLabel];
    [self.contentView addSubview:self.sizeLabel];
    [self.contentView addSubview:self.dateLabel];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.size.equalTo(CGSizeMake(50, 50));
    }];
    
    [self.jobTitleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.jobTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(10);
        make.top.equalTo(self.headImageView.top).offset(5);
        make.right.lessThanOrEqualTo(self.dateLabel.left).offset(-10);
    }];
    
    [self.enterpriseLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobTitleLabel.left);
        make.top.equalTo(self.jobTitleLabel.bottom);
        make.right.lessThanOrEqualTo(-10);
    }];
    
    [self.salaryLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jobTitleLabel.left);
        make.top.equalTo(self.enterpriseLabel.bottom).offset(2);
        make.right.lessThanOrEqualTo(-10);
    }];
    
    CGFloat width = 60;
    
    [self.natureLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(75);
        make.bottom.equalTo(-15);
        make.width.equalTo(width);
    }];
    
    [self.levelLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.natureLabel.right).offset (22);
        make.bottom.equalTo(-15);
        make.width.equalTo(width);
    }];
    
    [self.sizeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.levelLabel.right).offset (22);
        make.bottom.equalTo(-15);
        make.width.equalTo(width);
    }];
    
    [self.dateLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.jobTitleLabel.centerY);
        make.right.equalTo(-15);
    }];
    
    [natureBackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.natureLabel).insets(UIEdgeInsetsMake(-5, -5, -5, -5));
    }];
    
    [levelBackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.levelLabel).insets(UIEdgeInsetsMake(-5, -5, -5, -5));
    }];
    
    [sizeBackView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.sizeLabel).insets(UIEdgeInsetsMake(-5, -5, -5, -5));
    }];
    
    [self.contentView bringSubviewToFront:self.natureLabel];
}

- (void)setInfo:(HomeJobChannelEmploymentDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.imageURL];

    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:imageURL]
                           placeholderImage:GetImage(@"hospital_default_icon.png")];
    self.jobTitleLabel.text = dto.employmentTitle;
    self.enterpriseLabel.text = dto.enterpriseName;

    self.salaryLabel.text = [NSString stringWithFormat:@"%@ %@ 薪资%@", dto.enterprisePlace, dto.educationRequirements, dto.salary];
    self.natureLabel.text = dto.enterpriseNature;
    self.levelLabel.text = dto.enterpriseLevel;
    self.sizeLabel.text = dto.enterpriseSize;
    
    self.dateLabel.text = dto.publishTime;
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
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _jobTitleLabel;
}

- (UILabel *)enterpriseLabel
{
    if (!_enterpriseLabel) {
        _enterpriseLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _enterpriseLabel;
}

- (UILabel *)salaryLabel
{
    if (!_salaryLabel) {
        _salaryLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _salaryLabel;
}

- (UILabel *)natureLabel
{
    if (!_natureLabel) {
        _natureLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _natureLabel;
}

- (UILabel *)levelLabel
{
    if (!_levelLabel) {
        _levelLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _levelLabel;
}

- (UILabel *)sizeLabel
{
    if (!_sizeLabel) {
        _sizeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _sizeLabel;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor grayColor];
            label;
        });
    }
    return _dateLabel;
}

- (void)setLastCell:(BOOL)lastCell
{
    [super setLastCell:lastCell];
    if (lastCell) {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    } else {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(0);
            make.height.equalTo(1);
        }];
    }
}

@end
