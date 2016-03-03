//
//  HomeJobChannelHotEnterpriseCollectionViewCell.m
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelHotEnterpriseCollectionViewCell.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"
#import "UIColor+Colors.h"

@interface HomeJobChannelHotEnterpriseCollectionViewCell ()

@property (nonatomic, strong) UIImageView *enterpriseImageView;
@property (nonatomic, strong) UILabel *enterpriseNameLabel;
@property (nonatomic, strong) UILabel *deatilLabel;
@property (nonatomic, strong) UIImageView *reflectionImageView;
@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation HomeJobChannelHotEnterpriseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.emptyImageView];
        [self.contentView addSubview:self.enterpriseImageView];
        [self.enterpriseImageView addSubview:self.enterpriseNameLabel];
        [self.contentView addSubview:self.deatilLabel];
        
        [self.emptyImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
        
        [self.enterpriseImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 40, 0));
        }];
        
        self.enterpriseNameLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self.enterpriseNameLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(0);
            make.left.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(28);
        }];
        
        self.deatilLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.deatilLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(-15);
            make.top.equalTo(0);
            make.height.equalTo(20);
        }];
        
      //  [self.contentView addSubview:self.reflectionImageView];
    }
    return self;
}

#pragma mark -
#pragma mark - seter and getter -

- (UIImageView *)enterpriseImageView
{
    if (!_enterpriseImageView) {
        _enterpriseImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 8.0f;
            imageView;
        });
    }
    return _enterpriseImageView;
}

- (UILabel *)enterpriseNameLabel
{
    if (!_enterpriseNameLabel) {
        _enterpriseNameLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _enterpriseNameLabel;
}

- (UILabel *)deatilLabel
{
    if (!_deatilLabel) {
        _deatilLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
    }
    return _deatilLabel;
}

- (UIImageView *)reflectionImageView
{
    if (!_reflectionImageView) {
        _reflectionImageView = ({
            UIImageView *reflection = [[UIImageView alloc] init];;
            reflection.frame = CGRectMake(0, GetViewHeight(self) - 30, GetViewWidth(self), GetViewHeight(self));
            reflection.contentMode = UIViewContentModeScaleToFill;
            reflection.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
            reflection.layer.cornerRadius = 8.0f;
            reflection.clipsToBounds = YES;
            reflection.alpha = 0.2;
            
            CAGradientLayer *mask = [CAGradientLayer layer];
            mask.frame = CGRectMake(0, 20, GetViewWidth(self), GetViewHeight(self) - 20);
            mask.colors = [NSArray arrayWithObjects:
                           (id)[UIColor clearColor].CGColor,
                           (id)[UIColor whiteColor].CGColor, nil
                           ];
            reflection.layer.mask = mask;

            reflection;
        });
    }
    return _reflectionImageView;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 8.0f;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.layer.shadowOffset = CGSizeMake(0, 5);
            imageView.layer.shadowColor = [UIColor colorFromHexString:@"#aaafd3"].CGColor;
            imageView.layer.shadowRadius = 1;
            imageView.layer.shadowOpacity = 0.8;
            imageView;
        });
    }
    return _emptyImageView;
}

- (void)setDetailDTO:(HomeJobChannelHotEmploymentDetailDTO *)detailDTO
{
    _detailDTO = detailDTO;
    
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], detailDTO.enterpriseImage];
    [self.enterpriseImageView med_setImageWithUrl:[NSURL URLWithString:imageURL] placeholderImage:GetImage(@"hospital_default.png") options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image) {
            self.reflectionImageView.image = image;
        } else {
            self.reflectionImageView.image = GetImage(@"hospital_default.png");
        }
    }];
    self.enterpriseNameLabel.text = [NSString stringWithFormat:@"   %@", detailDTO.enterpriseName];
    self.deatilLabel.text = [NSString stringWithFormat:@"在招职位%@个", @(detailDTO.enterpriseEmploymentCount)];
    self.reflectionImageView.hidden = YES;
}

- (void)setHideReflection:(BOOL)hideReflection
{
    _hideReflection = hideReflection;
    self.reflectionImageView.hidden = hideReflection;
}

@end
