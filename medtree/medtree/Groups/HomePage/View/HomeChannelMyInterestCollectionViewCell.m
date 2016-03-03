//
//  HomeChannelMyInterestCollectionViewCell.m
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelMyInterestCollectionViewCell.h"

@interface HomeChannelMyInterestCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation HomeChannelMyInterestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.label];
        [self.contentView addSubview:self.selectImageView];
        
        self.label.frame = self.bounds;
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.selectImageView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@0);
            make.right.equalTo(@0);
        }];
    }
    return self;
}

#pragma mark -
#pragma marl - setter and getter -

- (UILabel *)label
{
    if (!_label) {
        _label = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
    }
    return _label;
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = ({
            UIImageView *view = [[UIImageView alloc] init];
            view.image = GetImage(@"home_channel_interest_selected.png");
            view;
        });
    }
    return _selectImageView;
}

- (void)setTitle:(NSString *)title
{
    if (!title) {
        return;
    }
    
    _title = title;
    
    self.label.text = title;
}

- (void)setShowSelectedView:(BOOL)showSelectedView
{
    _showSelectedView = showSelectedView;
    self.selectImageView.hidden = !showSelectedView;
}

@end
