//
//  HomeChannelMoreTableViewCell.m
//  medtree
//
//  Created by tangshimi on 11/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelMoreTableViewCell.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "UIImageView+setImageWithURL.h"

@interface HomeChannelMoreTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end


@implementation HomeChannelMoreTableViewCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];

    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.top.equalTo(10);
        make.size.equalTo(CGSizeMake(100, 70));
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.top).offset(5);
        make.left.equalTo(self.headImageView.right).offset(10);
        make.right.lessThanOrEqualTo(-15);
    }];

    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(4);
        make.left.equalTo(self.titleLabel.left);
        make.right.lessThanOrEqualTo(-15);
        make.bottom.lessThanOrEqualTo(self.headImageView.bottom);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-15);
        make.left.equalTo(15);
        make.height.equalTo(0.5);
        make.bottom.equalTo(self.bottom);
    }];
}

- (void)setInfo:(HomeRecommendChannelDetailDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    index = indexPath;
    idto = dto;
    
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], dto.channelImage];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:imageURL] placeholderImage:nil];
    
    self.titleLabel.text = dto.channelName;
    self.detailLabel.text = dto.channelIntroduction;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 90.0;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_default.png");
            imageView.layer.cornerRadius = 8.0;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor grayColor];
            label.numberOfLines = 2;
            label;
        });
    }
    return _detailLabel;
}

@end
