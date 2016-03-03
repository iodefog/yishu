//
//  FindEventTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/27/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FindEventTableViewCell.h"
#import "EventDTO.h"
#import "DateUtil.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"
#import "IMageCenter.h"

@interface FindEventTableViewCell ()

@property (nonatomic, strong) UIImageView *eventImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation FindEventTableViewCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.eventImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.eventImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.bottom.equalTo(@-10);
        make.width.equalTo(@120);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eventImageView.right).offset(20);
        make.top.equalTo(@10);
        make.right.equalTo(@-15);
    }];
    
    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.eventImageView.right).offset(20);
        make.top.equalTo(self.titleLabel.bottom).offset(5);
        make.right.equalTo(@-15);
    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.detailLabel.left);
        make.top.equalTo(self.detailLabel.bottom).offset(5);
        make.right.equalTo(@-15);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(15);
        make.right.equalTo(-15);
        make.bottom.equalTo(0);
        make.height.equalTo(0.5);
    }];
}

- (void)setInfo:(EventDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_120_90], dto.small_image_id];
    [self.eventImageView med_setImageWithUrl:[NSURL URLWithString:photo] placeholderImage:[ImageCenter getBundleImage:@"feed_default_image.png"]];
    self.titleLabel.text = dto.title;
    self.detailLabel.text = dto.summary;
    NSString *commonTimeStr = [MedGlobal isBigPhone] ? @"时间：" :@"";
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@ - %@", commonTimeStr,
                           [DateUtil getFormatTime:dto.start_time format:@"yyyy.MM.dd"],
                           [DateUtil getFormatTime:dto.end_time format:@"yyyy.MM.dd"]];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 110.0;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)eventImageView
{
    if (!_eventImageView) {
        _eventImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [ImageCenter getBundleImage:@"feed_default_image.png"];
            imageView;
        });
    }
    return _eventImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
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
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label.numberOfLines = 2;
            label;
        });
    }
    return _detailLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:11];
            label;
        });
    }
    return _timeLabel;
}

@end
