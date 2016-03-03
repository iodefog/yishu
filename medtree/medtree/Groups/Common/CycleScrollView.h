//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//  循环滚动

#import <UIKit/UIKit.h>

@protocol CycleScrollViewDelegate <NSObject>

- (void)setSelectIndex:(NSInteger)idx;
- (void)setTapIndex:(NSInteger)idx;

@end

@interface CycleScrollView : UIView
{
    UIScrollView    *scroll;
    NSMutableArray  *viewArray;
}

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@property (nonatomic, assign) id<CycleScrollViewDelegate> parent;

- (void)removeTimer;
- (void)addTimer;
- (void)clearScrollDelegate;
- (void)addScrollDelegate;
- (void)setViewArray:(NSArray *)array;

/** 显示水平滚动条 */
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);

/**
 数据源：获取的page
 **/
@property (nonatomic , copy) void (^PageAtIndexBlock)(NSInteger pageAtIndex);

@end