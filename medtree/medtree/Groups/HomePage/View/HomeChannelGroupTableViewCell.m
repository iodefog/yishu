//
//  HomeChannelGroupTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelGroupTableViewCell.h"
#import "UIImageView+setImageWithURL.h"
#import "NSString+Extension.h"

@interface HomeChannelGroupTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIImageView *officeImageView;
@property (nonatomic, strong) UILabel *officeLabel;

@end


@implementation HomeChannelGroupTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.placeLabel];
    [self.contentView addSubview:self.officeImageView];
    [self.contentView addSubview:self.officeLabel];
    
    self.headImageView.frame = CGRectMake(15, 8, 44, 44);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 15, 8, 100, 20);
    self.logoImageView.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 15, 60 - 25, 15, 12);
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    [self.headImageView med_setImageWithUrl:[NSURL URLWithString:@"http://img.zcool.cn/community/03320dd554c75c700000158fce17209.jpg"]];

    NSString *name = @"没事骑车出去转转";
    
    CGFloat nameWidth = [NSString sizeForString:name Size:CGSizeMake(GetScreenWidth, CGFLOAT_MAX) Font:self.nameLabel.font].width;
    
    self.nameLabel.text = name;
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.headImageView.frame) + 15, 8, nameWidth, 20);
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 16, 8, GetScreenWidth - CGRectGetMaxX(self.nameLabel.frame) - 15, 20);
    
    self.numberLabel.text = @"80/100人";
    
    NSString *place = @"北京";
    self.placeLabel.text = place;
    CGFloat placeWidth = [NSString sizeForString:place Size:CGSizeMake(GetScreenWidth, CGFLOAT_MAX) Font:self.placeLabel.font].width;
    self.placeLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 3, 60 -25, placeWidth, 12);
    
    self.officeImageView.frame = CGRectMake(CGRectGetMaxX(self.placeLabel.frame) + 15, 60 -25, 12, 12);
    
    self.officeLabel.text = @"心脏科室";
    self.officeLabel.frame = CGRectMake(CGRectGetMaxX(self.officeImageView.frame) + 3, 60 - 25, GetScreenWidth - CGRectGetMaxX(self.officeImageView.frame) - 15, 12);
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.cornerRadius = 22.0f;
            imageView.clipsToBounds = YES;
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
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _nameLabel;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _numberLabel;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view;
        });
    }
    return _logoImageView;
}

- (UILabel *)placeLabel
{
    if (!_placeLabel) {
        _placeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
    }
    return _placeLabel;
}

- (UIImageView *)officeImageView
{
    if (!_officeImageView) {
        _officeImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.image = GetImage(@"home_office_logo.png");
            view;
        });
    }
    return _officeImageView;
}

- (UILabel *)officeLabel
{
    if (!_officeLabel) {
        _officeLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont systemFontOfSize:12];
            label;
        });
    }
    return _officeLabel;
}

@end
