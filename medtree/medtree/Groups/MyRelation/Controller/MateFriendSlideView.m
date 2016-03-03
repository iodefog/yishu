//
//  MateFriendSlideView.m
//  medtree
//
//  Created by 陈升军 on 15/4/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateFriendSlideView.h"
#import "CycleScrollView.h"
#import "ImageCenter.h"


@implementation MateFriendSlideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    if (mainScorllView) {
        [mainScorllView removeTimer];
        mainScorllView.parent = nil;
        mainScorllView = nil;
    }
}

- (void)createUI
{
    mainScorllView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width*740/750) animationDuration:1];
    mainScorllView.backgroundColor = [UIColor clearColor];
    mainScorllView.parent = self;
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainScorllView.frame.size.width, mainScorllView.frame.size.height)];
        view.image = [ImageCenter getBundleImage:[NSString stringWithFormat:@"mate_friend_%d.png",i+1]];
        [viewsArray addObject:view];
    }
    [mainScorllView setViewArray:viewsArray];
    [self addSubview:mainScorllView];
}

- (void)setSelectIndex:(NSInteger)idx
{
    [self setIndex:idx];
}

- (void)setTapIndex:(NSInteger)idx
{
    
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    mainScorllView.frame = CGRectMake(0, 0, size.width, size.height);
    for (int i=0; i<4; i++) {
        UIImageView *dotView = (UIImageView *)[self viewWithTag:200+i+1];
        dotView.frame = CGRectMake((size.width-(4*16))+16*i-15, 20, 6, 6);
        [self bringSubviewToFront:dotView];
    }
}

- (void)setTotal:(NSInteger)total
{
    for (int i=0; i<total; i++) {
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        if (i == 0) {
            dotView.image = [ImageCenter getBundleImage:@"scroll_page_index_select.png"];
        } else {
            dotView.image = [ImageCenter getBundleImage:@"scroll_page_index.png"];
        }
        dotView.tag = 200+1+i;
        [self addSubview:dotView];
        [self bringSubviewToFront:dotView];
    }
}

- (void)setIndex:(NSInteger)idx
{
    for (int i=0; i<4; i++) {
        UIImageView *dotView = (UIImageView *)[self viewWithTag:200+i+1];
        if (i == idx) {
            dotView.image = [ImageCenter getBundleImage:@"scroll_page_index_select.png"];
        } else {
            dotView.image = [ImageCenter getBundleImage:@"scroll_page_index.png"];
        }
        [self bringSubviewToFront:dotView];
    }
}

@end
