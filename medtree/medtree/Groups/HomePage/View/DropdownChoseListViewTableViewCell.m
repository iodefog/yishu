//
//  DropdownChoseListViewTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/20/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DropdownChoseListViewTableViewCell.h"

@interface DropdownChoseListViewTableViewCell ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) UIView *bottomLineView;


@end

@implementation DropdownChoseListViewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLable];
        [self.contentView addSubview:self.selectImageView];
        [self addSubview:self.bottomLineView];
        
        NSDictionary *viewsDict = @{ @"titleLabel" : self.titleLable,
                                     @"selectImageView" : self.selectImageView,
                                     @"bottomLineView" : self.bottomLineView };
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[titleLabel]-10-[selectImageView]-20-|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomLineView]|" options:0 metrics:nil views:viewsDict]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:nil views:viewsDict]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[selectImageView]|" options:0 metrics:nil views:viewsDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomLineView(0.5)]-0-|" options:0 metrics:nil views:viewsDict]];
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter -

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _titleLable;
}

- (UIImageView *)selectImageView
{
    if (!_selectImageView) {
        _selectImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            imageView.image = [UIImage imageNamed:@"home_unselected.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _selectImageView;
}

- (UIView *)bottomLineView
{
    if (!_bottomLineView) {
        _bottomLineView =  ({
            UIView *view = [[UIView alloc] init];
            view.translatesAutoresizingMaskIntoConstraints = NO;
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _bottomLineView;
}

- (void)setInfoDic:(NSDictionary *)infoDic
{
    if (!infoDic) {
        return;
    }
    _infoDic = infoDic;
    
    self.titleLable.text = infoDic[@"title"];
    self.selectImageView.image = [infoDic[@"selected"] boolValue] ? GetImage(@"home_selected.png"): GetImage(@"home_unselected");
}

@end
