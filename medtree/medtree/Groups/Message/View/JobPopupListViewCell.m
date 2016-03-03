//
//  JobPopupListViewCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "JobPopupListViewCell.h"

@interface JobPopupListViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation JobPopupListViewCell

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
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.separatorView];
        
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
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

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
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
            view.backgroundColor = [ColorUtil getColor:@"777777" alpha:1.0];
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
    self.titleLabel.text = infoDic[@"title"];
    
    BOOL hideSeparation = [infoDic[@"hideSeparation"] boolValue];
    
    self.separatorView.hidden = hideSeparation;
}

@end
