//
//  HorizontalScrollTabView.h
//  qxun
//
//  Created by tangshimi on 5/2/15.
//  Copyright (c) 2015 xincc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalScrollTabViewDelegate <NSObject>

- (void)horizontalScrollTabViewItemDidClick:(NSInteger)selectedIndex;

- (BOOL)horizontalScrollTabViewItemShouldClick:(NSInteger)selectedIndex;

@end

@interface HorizontalScrollTabView : UIView {

}

@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) UIFont *itemFont;

@property (nonatomic, strong) UIColor *selectedItemColor;
@property (nonatomic, strong) UIColor *unSelectedItemColor;

@property (nonatomic, assign) BOOL showBottomLine;
@property (nonatomic, strong) UIColor *bottomLineColor;

@property (nonatomic, strong) UIImage *backgroundImage;

/**
 *  两端的边距
 */
@property (nonatomic, assign) CGFloat edgeSpace;

/**
 *  相邻两个item的间隔
 */
@property (nonatomic, assign) CGFloat itemSpace;

/**
 *  最小的item的宽度
 */
@property (nonatomic, assign) CGFloat minItemWidth;

@property (nonatomic, assign) NSInteger selectedItemIndex;

@property (nonatomic, assign) BOOL isAlwaysResponseClick;

@property (nonatomic, weak) id <HorizontalScrollTabViewDelegate> delegate;

- (UIButton *)itemWithIndex:(NSInteger)index;

@end

