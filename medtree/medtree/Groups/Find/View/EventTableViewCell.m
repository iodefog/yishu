//
//  EventTableViewCell.m
//  medtree
//
//  Created by tangshimi on 9/1/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventTableViewCell.h"
#import "UIColor+Colors.h"
#import "EventDTO.h"
#import "UIImageView+setImageWithURL.h"
#import <DateUtil.h>
#import "ImageCenter.h"

@interface EventTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *eventTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation EventTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.eventTitleLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.equalTo(@120);
        make.bottom.equalTo(@-10);
    }];
    
    [self.eventTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(self.headImageView.right).offset(20);
        make.right.equalTo(@-15);
    }];
    
    [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(20);
        make.right.equalTo(@-15);
        make.bottom.equalTo(@-10);
    }];
    
    [footerLine makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
        make.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setInfo:(EventDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_120_90], dto.small_image_id];
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:photo] placeholderImage:[ImageCenter getBundleImage:@"feed_default_image.png"]];

    self.eventTitleLabel.text = dto.title;

    NSString *commonTimeStr = [MedGlobal isBigPhone] ? @"时间：" :@"";
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@ ------ %@", commonTimeStr,
                           [DateUtil getFormatTime:dto.start_time format:@"yyyy.MM.dd"],
                           [DateUtil getFormatTime:dto.end_time format:@"yyyy.MM.dd"]];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 110.0f;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView  = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _headImageView;
}

- (UILabel *)eventTitleLabel
{
    if (!_eventTitleLabel) {
        _eventTitleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:16];
            label.numberOfLines = 2;
            label;
        });
    }
    return _eventTitleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor colorFromHexString:@"#6b6b6b"];
            label.font = [UIFont systemFontOfSize:14];
            label.adjustsFontSizeToFitWidth = YES;
            label;
        });
    }
    return _timeLabel;
}

@end
