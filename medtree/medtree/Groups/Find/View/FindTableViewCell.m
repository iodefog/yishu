//
//  FindTableViewCell.m
//  medtree
//
//  Created by tangshimi on 7/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FindTableViewCell.h"
#import "UIColor+Colors.h"
#import "MedGlobal.h"
#import "FindDTO.h"
#import "UIImageView+setImageWithURL.h"

@interface FindTableViewCell ()

@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;

@property (strong, nonatomic) FindDTO *findDTO;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation FindTableViewCell

- (void)createUI
{
    [super createUI];
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.logoImageView.frame = CGRectMake(15, (CGRectGetHeight(self.frame) - 46) / 2, 46, 46);
    self.arrowImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 24 - 5, (CGRectGetHeight(self.frame) - 10) / 2, 9, 14);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10,
                                       0,
                                       CGRectGetWidth(self.frame) - CGRectGetMaxX(self.logoImageView.frame) - 29,
                                       CGRectGetHeight(self.frame));
    footerLine.frame = CGRectMake(isLastCell ? 0 : 10, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame) - (isLastCell ? 0 : 20), 0.5);
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    self.findDTO = dto;
    self.indexPath = indexPath;
    
    NSString *photo = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], self.findDTO.iconImageURL];
    [self.logoImageView med_setImageWithUrl:[NSURL URLWithString:photo]];

    self.titleLabel.text = self.findDTO.title;
}

- (void)clickCell
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:)]) {
        [self.parent clickCell:self.findDTO index:self.indexPath];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    if ([MedGlobal isBigPhone]) {
        return 80;
    }
    return 70;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        logoImageView.layer.cornerRadius = 23.0;
        logoImageView.layer.masksToBounds = YES;
        _logoImageView = logoImageView;
    }
    return _logoImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:18];
        label.textColor = [UIColor colorFromHexString:@"#111726"];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"setting_img_arrow.png"];
        _arrowImageView = imageView;
    }
    return _arrowImageView;
}

@end
