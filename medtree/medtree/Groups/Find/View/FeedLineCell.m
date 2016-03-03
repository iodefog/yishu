//
//  NewFeedLineCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "FeedLineCell.h"
#import "ColorUtil.h"

@interface FeedLineCell ()

@property (nonatomic, strong) UIView *whiteView;

@end

@implementation FeedLineCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor clearColor];

    [self.contentView addSubview:self.whiteView];
    
    [self.whiteView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 10.5, 0));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    footerLine.frame = CGRectMake(0, 9.5, size.width, 0.5);
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 20;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _whiteView;
}

@end

