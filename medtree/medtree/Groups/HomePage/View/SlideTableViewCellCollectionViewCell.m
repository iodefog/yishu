//
//  SlideTableViewCellCollectionViewCell.m
//  medtree
//
//  Created by tangshimi on 8/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SlideTableViewCellCollectionViewCell.h"
#import "UIImageView+setImageWithURL.h"
#import "MedGlobal.h"

@interface SlideTableViewCellCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SlideTableViewCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
        
        self.imageView.frame = self.bounds;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(10);
            make.size.equalTo(CGSizeMake(50, 50));
            make.centerX.equalTo(0);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            if ([MedGlobal isPhone6Plus]) {
                make.bottom.equalTo(-20);
            } else {
                make.bottom.equalTo(-10);
            }
            
            make.centerX.equalTo(0);
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - getter and getter -

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 25;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _titleLabel;
}

- (void)setChannelDetailDTO:(HomeRecommendChannelDetailDTO *)channelDetailDTO
{
    if (!channelDetailDTO.channelID && channelDetailDTO.channelName) {
        self.imageView.image = GetImage(@"home_more_channel.png");
    } else if (!channelDetailDTO.channelID && !channelDetailDTO.channelName) {
        self.imageView.image = nil;
    } else {
        [self.imageView med_setImageWithUrl:[NSURL URLWithString:channelDetailDTO.channelImage]
                           placeholderImage:GetImage(@"home_channel_default.png")];
    }
    self.titleLabel.text = channelDetailDTO.channelName;
}

@end
