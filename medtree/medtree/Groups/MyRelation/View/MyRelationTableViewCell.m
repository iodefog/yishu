//
//  MyRelationTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/25/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MyRelationTableViewCell.h"
#import "PairDTO.h"

@interface MyRelationTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation MyRelationTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.headImageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.right).offset(15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-15);
        make.centerY.equalTo(self.contentView.centerY);
    }];
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    PairDTO *pairDTO = dto;
    
    self.headImageView.image = GetImage(pairDTO.imageName);
    
    self.titleLabel.text = pairDTO.key;
    
    if (pairDTO.isLastCell) {
        footerLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1);
    } else {
        footerLine.frame = CGRectMake(15, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame) - 30, 1);
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60.0f;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
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
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"setting_img_arrow.png");
            imageView;
        });
    }
    return _arrowImageView;
}

@end
