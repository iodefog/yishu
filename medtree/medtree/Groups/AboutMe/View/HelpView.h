//
//  HelpView.h
//  xhjxhd
//
//  Created by sam on 7/24/14.
//  Copyright (c) 2014 wuyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HelpViewDelegate <NSObject>

- (void)setIsShowHelp:(BOOL)sender;

@end

@interface PageView : UIView {
    UIImageView *imageView;
    NSInteger totalCount;
}

- (void)setImage:(UIImage *)image;

@end

@interface HelpView : UIView <UIScrollViewDelegate> {
    UIScrollView *scroll;
    NSInteger pageCount;
    NSInteger pageIndex;
}

//- (BOOL)isIphone6Plus;

@property (nonatomic, assign) id<HelpViewDelegate> parent;

- (void)showHelp;

@end
