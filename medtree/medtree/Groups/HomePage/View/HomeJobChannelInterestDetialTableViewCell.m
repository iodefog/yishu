//
//  HomeJobChannelInterestDetialTableViewCell.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelInterestDetialTableViewCell.h"
#import "PairDTO.h"

@interface HomeJobChannelInterestDetialTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation HomeJobChannelInterestDetialTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectImageView];
    
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(35);
        make.right.lessThanOrEqualTo(self.selectImageView.left).offset(-15);
        make.centerY.equalTo(0);
    }];
    
    [self.selectImageView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-23);
        make.centerY.equalTo(0);
    }];
}

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    self.titleLabel.text = dto.label;
    self.selectImageView.image = dto.isSelect ? GetImage(@"home_selected.png"): GetImage(@"home_unselected");
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

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"home_unselected.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _selectImageView;
}

@end
