//
//  LoadingView.h
//  medtree
//
//  Created by sam on 9/23/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView {
    UIImageView *bgView;
    UIImageView *loadingView;
    
    CGFloat     offsety;
    CGFloat     duration;
    NSInteger   repeat;
    NSInteger   index;
    NSTimer     *timer;
}

+ (void)showProgress:(BOOL)tf inView:(UIView *)inView;
+ (void)setOffset:(CGFloat)offset;

- (void)startTimer;
- (void)disableTimer;
- (void)showCover:(BOOL)tf;

@end
