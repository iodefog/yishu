//
//  HorizontalScrollTabView.m
//  qxun
//
//  Created by tangshimi on 5/2/15.
//  Copyright (c) 2015 xincc. All rights reserved.
//

#import "HorizontalScrollTabView.h"
#import "NSString+Extension.h"

#define BOTTOM_LINE_HEIGHT 2
#define BUTTON_BASE_TAG  10000

@interface HorizontalScrollTabView ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *bottomLineImageView;
@property (nonatomic, assign) BOOL isSetupView;

@end

@implementation HorizontalScrollTabView

@synthesize backgroundImage = backgroundImage_;
@synthesize items = items_;
@synthesize showBottomLine = showBottomLine_;
@synthesize backgroundView = backgroundView_;
@synthesize scrollView = scrollView_;
@synthesize bottomLineImageView = bottomLineImageView_;
@synthesize itemFont = itemFont_;
@synthesize selectedItemIndex = selectedItemIndex_;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        selectedItemIndex_ = -1;
        
        [self addSubview:self.backgroundView];
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
 
    if (CGRectGetHeight(frame) == 0 || CGRectGetWidth(frame) == 0) {
        return;
    }
    
    if (!self.isSetupView) {
        [self setUpView];
    }
    
    CGFloat nextItemStartLoaction = [self starLocation];
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [self itemWithIndex:i];
        button.frame = CGRectMake(nextItemStartLoaction, 0, CGRectGetWidth(button.frame), CGRectGetHeight(self.frame));
        
        if (i < self.items.count - 1) {
            nextItemStartLoaction += CGRectGetWidth(button.frame) + self.itemSpace;
        } else {
            nextItemStartLoaction += CGRectGetWidth(button.frame);
        }
        
        if (self.selectedItemIndex == i) {
            button.selected = YES;
        }
    }
    
    scrollView_.contentSize = CGSizeMake(nextItemStartLoaction + self.edgeSpace, CGRectGetHeight(frame));
    
    if (self.showBottomLine) {
        UIButton *currentSelectedButton = [self itemWithIndex:self.selectedItemIndex];
        self.bottomLineImageView.frame = CGRectMake(CGRectGetMinX(currentSelectedButton.frame),
                                                    CGRectGetHeight(frame) - BOTTOM_LINE_HEIGHT,
                                                    CGRectGetWidth(currentSelectedButton.frame),
                                                    BOTTOM_LINE_HEIGHT);
        if (self.bottomLineColor) {
            self.bottomLineImageView.backgroundColor = self.bottomLineColor;
        } else {
            self.bottomLineImageView.backgroundColor = self.selectedItemColor;
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setup view -
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setUpView
{
    self.isSetupView = YES;
    
    CGFloat nextItemStartLoaction = [self starLocation];;
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.items[i] forState:UIControlStateNormal];
        CGSize itemSize = [self itemWidth:self.items[i]];
        button.frame = CGRectMake(nextItemStartLoaction, 0, itemSize.width, CGRectGetHeight(self.frame));
        button.titleLabel.font = self.itemFont;
        [button setTitleColor:self.selectedItemColor forState:UIControlStateNormal | UIControlStateSelected];
        [button setTitleColor:self.unSelectedItemColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BUTTON_BASE_TAG + i;
        [scrollView_ addSubview:button];
        
        if (i < self.items.count - 1) {
            nextItemStartLoaction += itemSize.width + self.itemSpace;
        } else {
            nextItemStartLoaction += itemSize.width;
        }
    }
    
    scrollView_.contentSize = CGSizeMake(nextItemStartLoaction + self.edgeSpace, CGRectGetHeight(self.frame));
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - response event -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)itemClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(horizontalScrollTabViewItemShouldClick:)]) {
        if ([self.delegate horizontalScrollTabViewItemShouldClick:button.tag - BUTTON_BASE_TAG]) {
            if (button.tag - BUTTON_BASE_TAG != self.selectedItemIndex) {
                [self changeItemWithCurrentIndex:self.selectedItemIndex
                                   didClickIndex:button.tag  - BUTTON_BASE_TAG];
                self.selectedItemIndex = button.tag - BUTTON_BASE_TAG;
                if ([self.delegate respondsToSelector:@selector(horizontalScrollTabViewItemDidClick:)]) {
                    [self.delegate horizontalScrollTabViewItemDidClick:self.selectedItemIndex];
                }
            } else {
                if (self.isAlwaysResponseClick) {
                    if ([self.delegate respondsToSelector:@selector(horizontalScrollTabViewItemDidClick:)]) {
                        [self.delegate horizontalScrollTabViewItemDidClick:self.selectedItemIndex];
                    }
                }
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - helper -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)changeItemWithCurrentIndex:(NSInteger)currentIndex didClickIndex:(NSInteger)didClickIndex
{
    if (!self.isSetupView) {
        return;
    }
    
    UIButton *currentButton = [self itemWithIndex:currentIndex];
    UIButton *didClickButton = [self itemWithIndex:didClickIndex];
    didClickButton.selected = YES;
    currentButton.selected = NO;
    
    
    if (!currentButton) {
        if (self.showBottomLine) {
            bottomLineImageView_.hidden = NO;
            bottomLineImageView_.frame = CGRectMake(didClickButton.frame.origin.x,
                                                    didClickButton.frame.size.height - BOTTOM_LINE_HEIGHT,
                                                    didClickButton.frame.size.width,
                                                    BOTTOM_LINE_HEIGHT);
        }
    }
    
    if (didClickButton) {
        [UIView animateWithDuration:0.2 animations:^{
            bottomLineImageView_.frame = CGRectMake(didClickButton.frame.origin.x,
                                                    didClickButton.frame.size.height - BOTTOM_LINE_HEIGHT,
                                                    didClickButton.frame.size.width,
                                                    BOTTOM_LINE_HEIGHT);
        }];
    } else {
        if (self.showBottomLine) {
            bottomLineImageView_.hidden = YES;
        }
    }
        
    CGPoint point = CGPointMake((CGRectGetMidX(didClickButton.frame) - CGRectGetMidX(self.frame)), 0);
    
    if (scrollView_.contentSize.width > CGRectGetWidth(self.frame)) {
        if (point.x > 0 && point.x <= scrollView_.contentSize.width - CGRectGetWidth(self.frame)){
            [UIView animateWithDuration:0.2 animations:^{
                scrollView_.contentOffset = point;
            }];
        } else if (point.x <= 0){
            [UIView animateWithDuration:0.2 animations:^{
                scrollView_.contentOffset = CGPointZero;
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                scrollView_.contentOffset = CGPointMake(scrollView_.contentSize.width - CGRectGetWidth(self.frame), 0);
            }];
        }
    }
}

- (CGFloat)starLocation
{
    CGFloat width = 0;
    for (NSString *itemString in self.items) {
        width += [self itemWidth:itemString].width;
    }
    
    width += (self.items.count - 1) * self.itemSpace;
    if (width < CGRectGetWidth(self.frame)) {
        CGFloat location = (CGRectGetWidth(self.frame) - width) / 2.0;
        return location < self.edgeSpace ? self.edgeSpace : location;
    } else {
        return self.edgeSpace;
    }
}

- (CGSize)itemWidth:(NSString *)string
{
    CGSize size =[NSString sizeForString:string Size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) Font:self.itemFont];
    
    if (size.width < self.minItemWidth) {
        size.width = self.minItemWidth;
    }
    return size;
}

- (UIButton *)itemWithIndex:(NSInteger)index
{
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:BUTTON_BASE_TAG + index];
    return button;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - setter and getter -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImageView *)backgroundView
{
    if (!backgroundView_) {
        UIImageView *backgroundView = [[UIImageView alloc] init];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor clearColor];
        backgroundView_ = backgroundView;
    }
    return backgroundView_;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (!backgroundImage) {
        return;
    }
    backgroundImage_ = backgroundImage;
    self.backgroundView.image = backgroundImage;
}

- (UIScrollView *)scrollView
{
    if (!scrollView_) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.bounces = NO;
        scrollView.scrollEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        scrollView_ = scrollView;
    }
    return scrollView_;
}

- (UIImageView *)bottomLineImageView
{
    if (!bottomLineImageView_) {
        UIImageView *bottomImageView = [[UIImageView alloc] init];
        if (self.bottomLineColor) {
            bottomImageView.backgroundColor = self.bottomLineColor;
        } else {
            bottomImageView.backgroundColor = self.selectedItemColor;
        }
        bottomLineImageView_ = bottomImageView;
    }
    return bottomLineImageView_;
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    if (showBottomLine_ == showBottomLine) {
        return;
    }
    
    showBottomLine_ = showBottomLine;
    if (showBottomLine) {
        [self.scrollView addSubview:self.bottomLineImageView];
        if (!self.isSetupView) {
            return;
        }
        
        UIButton *currentSelectedButton = [self itemWithIndex:self.selectedItemIndex];
        self.bottomLineImageView.frame = CGRectMake(CGRectGetMinX(currentSelectedButton.frame),
                                                    CGRectGetHeight(self.frame) - BOTTOM_LINE_HEIGHT,
                                                    CGRectGetWidth(currentSelectedButton.frame),
                                                    BOTTOM_LINE_HEIGHT);
        self.bottomLineImageView.backgroundColor = self.bottomLineColor;
    } else {
        [self.bottomLineImageView removeFromSuperview];
    }
}

- (void)setItems:(NSArray *)items
{
    if (!items) {
        return;
    }

    items_ = nil;
    items_ = items;
    
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    [self setUpView];
}

- (void)setItemFont:(UIFont *)itemFont
{
    if (!itemFont) {
        return;
    }
    
    itemFont_ = itemFont;
    
    if (!self.isSetupView) {
        return;
    }
    
    for (NSInteger i = 0; i < self.items.count; i ++) {
        UIButton *button = [self itemWithIndex:i];
        if (!button) {
            return;
        }
        [button.titleLabel setFont:itemFont];
    }
}

- (void)setSelectedItemIndex:(NSInteger)index
{
//    if (index < 0 || index > self.items.count - 1) {
//        NSLog(@"index越界");
//        return;
//    }
    
    if (!self.isSetupView) {
        selectedItemIndex_ = index;
        return;
    }
    
    if (index != selectedItemIndex_) {
//        if (![self itemWithIndex:selectedItemIndex_]) {
//            selectedItemIndex_ = index;
//            return;
//        }
        
        [self changeItemWithCurrentIndex:selectedItemIndex_ didClickIndex:index];
        selectedItemIndex_ = index;
    }
}

@end
