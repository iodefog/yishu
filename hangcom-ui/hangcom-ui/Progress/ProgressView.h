//
//  ProgressView.h
//  hangcom-ui
//
//  Created by sam on 13-7-11.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircularProgressView;

@interface ProgressView : UIView {
    UIImageView *bgView;
    CircularProgressView *circularView;
    NSTimer *timer;
    NSInteger timerCount;
}

- (void)showBgView:(BOOL)tf;
- (void)setProgess:(CGFloat)p;
+ (void)showProgress:(BOOL)tf inView:(UIView *)inView;
+ (void)setProgess:(CGFloat)p;
+ (void)setDuration:(CGFloat)time from:(CGFloat)from to:(CGFloat)to;
+ (void)disableTimer;

@end
