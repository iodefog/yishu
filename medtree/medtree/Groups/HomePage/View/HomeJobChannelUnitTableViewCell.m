//
//  HomeJobChannelSearchTableViewCell.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitTableViewCell.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "UIImageView+setImageWithURL.h"

@interface HomeJobChannelUnitTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation HomeJobChannelUnitTableViewCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    
    [self.headImageView  makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(10);
        make.bottom.equalTo(-10);
        make.width.equalTo(self.headImageView.height);
    }];
    
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.top).offset(3);
        make.left.equalTo(self.headImageView.right).offset(10);
        make.right.lessThanOrEqualTo(-15);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.bottom).offset(5);
        make.left.equalTo(self.nameLabel);
        make.right.lessThanOrEqualTo(-15);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
}

- (void)setInfo:(HomeJobChannelHotEmploymentDetailDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.enterpriseImage];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:GetImage(@"hospital_default_icon.png")];
    self.nameLabel.text = dto.enterpriseName;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@", dto.enterprisePlace, dto.enterpriseNature, dto.enterpriseSize];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 65.0f;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 22.5;
            imageView.clipsToBounds = YES;
            imageView.image = GetImage(@"hospital_default_icon.png");
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _detailLabel;
}

@end
