//
//  LoadingTableView.m
//  medtree
//
//  Created by sam on 9/23/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "LoadingTableView.h"
#import "LoadingView.h"

@implementation LoadingTableView

- (void)createUI
{
    [super createUI];
    
    _refreshHeaderView.hidden = YES;
    _refreshFooterView.hidden = YES;
    
    CGSize size = self.frame.size;

    _headerView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0-60, size.width, 60)];
    [_headerView showCover:NO];
    _footerView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0-60, size.width, 60)];
    [_footerView showCover:NO];
}

- (void)setEnableFooter:(BOOL)tf
{
    [super setEnableFooter:tf];
    //
    if (tf == YES) {
        if ([self.subviews containsObject:_footerView] == NO) {
            [_footerView startTimer];
            [self addSubview:_footerView];
        }
    } else {
        if ([self.subviews containsObject:_footerView] == YES) {
            [_footerView disableTimer];
            [_footerView removeFromSuperview];
        }
    }
}

- (void)setEnableHeader:(BOOL)tf
{
    [super setEnableHeader:tf];
    //
    if (tf == YES) {
        if ([self.subviews containsObject:_headerView] == NO) {
            [_headerView startTimer];
            [self addSubview:_headerView];
        }
    } else {
        if ([self.subviews containsObject:_headerView] == YES) {
            [_headerView disableTimer];
            [_headerView removeFromSuperview];
        }
    }
}

- (void)updateFooter
{
    CGSize size = self.contentSize;
    CGSize size2 = self.frame.size;
    if (size.height < size2.height) {
        size.height = size2.height;
    }
    _footerView.frame = CGRectMake(0, size.height, size.width, 60);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //
    
    CGSize size = self.contentSize;
    _headerView.frame = CGRectMake(0, 0-60, size.width, 60);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    //
    if ([self.parent respondsToSelector:@selector(clickTable)]) {
        [self.parent clickTable];
    }
}

@end
