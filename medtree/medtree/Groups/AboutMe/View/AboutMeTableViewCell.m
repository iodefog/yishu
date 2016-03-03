//
//  AboutMeTableViewCell.m
//  medtree
//
//  Created by tangshimi on 7/30/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AboutMeTableViewCell.h"
#import "PairDTO.h"

@interface AboutMeTableViewCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *detailImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation AboutMeTableViewCell

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.selectedBackgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        view;
    });
    
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailImageView];
    
    self.logoImageView.frame = CGRectMake(27.0, 0, 30, CGRectGetHeight(self.frame));
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 15, 0, 130, CGRectGetHeight(self.frame));
    self.detailImageView.frame = CGRectMake(CGRectGetWidth(self.frame) - 80, 0, 48, CGRectGetHeight(self.frame));
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    PairDTO *pairDTO = dto;
    self.logoImageView.image = [UIImage imageNamed:pairDTO.imageName];
    self.titleLabel.text = pairDTO.key;
    if (![pairDTO.value isEqualToString:@""]) {
        self.detailImageView.hidden = NO;
        
        self.detailImageView.image = [UIImage imageNamed:
          [pairDTO.value isEqualToString:@"已认证"] ? @"my_identification_status_yes.png" : @"my_identification_status_no.png"];
    } else {
        self.detailImageView.hidden = YES;
    }
}

- (void)clickCell
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:)]) {
        [self.parent clickCell:nil index:self.indexPath];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _logoImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentLeft;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:17];
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            label;
        });
    }
    return _titleLabel;
}

- (UIImageView *)detailImageView
{
    if (!_detailImageView) {
        _detailImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
            imageView;
        });
    }
    return _detailImageView;
}

@end
