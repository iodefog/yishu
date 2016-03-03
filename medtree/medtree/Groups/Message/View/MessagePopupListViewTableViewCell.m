//
//  MessagePopupListViewTableViewCell.m
//  medtree
//
//  Created by tangshimi on 9/2/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MessagePopupListViewTableViewCell.h"
#import "UIColor+Colors.h"

@interface MessagePopupListViewTableViewCell ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation MessagePopupListViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tintColor = [UIColor whiteColor];
        
        self.selectedBackgroundView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
            view;
        });
        
        [self.contentView addSubview:self.logoImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.separatorView];
        
        [self.logoImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.centerY.equalTo(@0);
        }];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.right).offset(5);
            make.centerY.equalTo(@0);
        }];
        
        [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.right.equalTo(@-5);
            make.bottom.equalTo(@0);
            make.height.equalTo(@0.5);
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
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
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            label;
        });
    }
    return _titleLabel;
}

- (UIView *)separatorView
{
    if (!_separatorView) {
        _separatorView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor colorFromHexString:@"#777777"];
            view;
        });
    }
    return _separatorView;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    if (!infoDic) {
        return;
    }
    infoDic = [infoDic copy];
    
    self.logoImageView.image = [GetImage(infoDic[@"image"]) imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleLabel.text = infoDic[@"title"];
    
    BOOL showSeparation = [infoDic[@"showSeparation"] boolValue];
    
    self.separatorView.hidden = !showSeparation;
}

@end
