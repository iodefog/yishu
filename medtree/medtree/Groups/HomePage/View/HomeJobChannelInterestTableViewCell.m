//
//  HomeJobChannelInterestTableViewCell.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelInterestTableViewCell.h"
#import "PairDTO.h"

@interface HomeJobChannelInterestTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *choseDetailLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation HomeJobChannelInterestTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.choseDetailLabel];
    [self.contentView addSubview:self.arrowImageView];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.centerY.equalTo(0);
    }];
    
    [self.choseDetailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.choseDetailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.titleLabel.right).offset(50);
        make.right.equalTo(self.arrowImageView.left).offset(-10);
        make.centerY.equalTo(0);
    }];
    
    [self.arrowImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-30);
        make.centerY.equalTo(0);
    }];
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    self.titleLabel.text = dto.label;
    self.choseDetailLabel.text = dto.key;
    
    if (dto.accessType == 1) {
        self.arrowImageView.hidden = YES;
    } else {
        self.arrowImageView.hidden = NO;
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 60.0f;
}

#pragma mark -
#pragma mark - setter and getter -

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

- (UILabel *)choseDetailLabel
{
    if (!_choseDetailLabel) {
        _choseDetailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
    }
    return _choseDetailLabel;
}

- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"setting_img_arrow.png");
            imageView;
        });
    }
    return _arrowImageView;
}

- (void)setLastCell:(BOOL)lastCell
{
    [super setLastCell:lastCell];
    if (lastCell) {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
            make.height.equalTo(0.5);
        }];
    } else {
        [footerLine updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(10);
            make.right.equalTo(-10);
            make.bottom.equalTo(0);
            make.height.equalTo(0.5);
        }];
    }
}

@end
