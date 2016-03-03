//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)dealloc
{
    [self clearScrollDelegate];
}

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
//        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationDuration = animationDuration;
    }
    return self;
}

- (void)clearScrollDelegate
{
    scroll.delegate = nil;
}

- (void)addScrollDelegate
{
    scroll.delegate = self;
}

- (void)addTimer
{
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        scroll.autoresizingMask = 0xFF;
        scroll.contentMode = UIViewContentModeCenter;
        scroll.contentSize = CGSizeMake(3 * CGRectGetWidth(scroll.frame), CGRectGetHeight(scroll.frame));
        scroll.delegate = self;
        scroll.contentOffset = CGPointMake(CGRectGetWidth(scroll.frame), 0);
        scroll.pagingEnabled = YES;
        [self addSubview:scroll];
        
        self.currentPageIndex = 0;
        
        self.contentViews = [[NSMutableArray alloc] init];
        viewArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)setViewArray:(NSArray *)array
{
    self.totalPageCount = array.count;
    [viewArray removeAllObjects];
    [viewArray addObjectsFromArray:array];
}

- (void)configContentViews
{
    [scroll.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(scroll.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [scroll addSubview:contentView];
    }
    [scroll setContentOffset:CGPointMake(scroll.frame.size.width, 0)];
}

- (UIView *)getViewWithIndex:(NSInteger)idx
{
    if (idx > viewArray.count || idx == viewArray.count) {
        UIView *view = [[UIView alloc] init];
        return view;
    } else {
        return [viewArray objectAtIndex:idx];
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    
    [self.contentViews removeAllObjects];
    if (self.parent == nil) {
        return;
    }
    [self.contentViews addObject:[self getViewWithIndex:previousPageIndex]];
    [self.contentViews addObject:[self getViewWithIndex:self.currentPageIndex]];
    [self.contentViews addObject:[self getViewWithIndex:rearPageIndex]];
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;

    if(contentOffsetX >= (2 * CGRectGetWidth(scroll.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        if (self.parent) {
            [self.parent setSelectIndex:self.currentPageIndex];
        }
        
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        if (self.parent) {
            [self.parent setSelectIndex:self.currentPageIndex];
        }
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scroll setContentOffset:CGPointMake(CGRectGetWidth(scroll.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    if (self.parent != nil || self.animationTimer != nil) {
        CGPoint newOffset = CGPointMake(scroll.contentOffset.x + CGRectGetWidth(scroll.frame), scroll.contentOffset.y);
        [scroll setContentOffset:newOffset animated:YES];
    } else {
        [timer invalidate];
    }
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    [self.parent setTapIndex:self.currentPageIndex];
}

#pragma mark - setter & getter
- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator
{
    scroll.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
}
@end
