//
//  SectionTitleTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/17/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SectionTitleTableViewCell.h"
#import "SectionTitleDTO.h"

@interface SectionTitleTableViewCell ()

@property (nonatomic, strong) UIView *verticalView;
@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation SectionTitleTableViewCell

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.verticalView];
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.moreButton];
    
    self.verticalView.frame = CGRectMake(15, 7.5, 3, 15);
    self.titleLable.frame = CGRectMake(CGRectGetMaxX(self.verticalView.frame) + 10, 0, 150, GetViewHeight(self));
    self.titleLable.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.moreButton.frame = CGRectMake(GetViewWidth(self) -  70, 0, 70, GetViewHeight(self));
    self.moreButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

#pragma mark -
#pragma mark - response event -

- (void)moreButtonAction:(UIButton *)button
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:idto index:index action:@(SectionTitleTableViewCellClickTypeLookMore)];
    }
}

- (void)setInfo:(SectionTitleDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    self.verticalView.backgroundColor = dto.verticalViewColor;
    self.titleLable.text = dto.title;
    self.moreButton.hidden = !dto.showMoreButton;
    
    if (dto.moreButtonTitle) {
        [self.moreButton setTitle:dto.moreButtonTitle forState:UIControlStateNormal];
    }
    
    self.userInteractionEnabled = dto.showMoreButton;
    
    if (dto.backgroundColor) {
        self.backgroundColor = dto.backgroundColor;
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    footerLine.hidden = dto.hideFooterLine;
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 30;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)verticalView
{
    if (!_verticalView) {
        _verticalView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
    }
    return _verticalView;
}

- (UILabel *)titleLable
{
    if (!_titleLable) {
        _titleLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentLeft;
            label;
        });
    }
    return _titleLable;
}

- (UIButton *)moreButton
{
    if (!_moreButton) {
        _moreButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _moreButton;
}

@end
