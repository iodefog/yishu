//
//  LoadingView.m
//  medtree
//
//  Created by sam on 9/23/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "LoadingView.h"
#import "ImageCenter.h"
#import "MedGlobal.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createUI];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    bgView = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"  "]];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    
    loadingView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:loadingView];
    
    duration = 3;
    repeat = 32;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    CGFloat y = offsety > 0 ? offsety : (size.height-15)/2;
    loadingView.frame = CGRectMake((size.width-70)/2, y, 70, 15);
}

+ (id)shareInstance
{
    static LoadingView *lv = nil;
    if (lv == nil) {
        lv = [[LoadingView alloc] initWithFrame:CGRectZero];
    }
    return lv;
}

+ (void)showProgress:(BOOL)tf inView:(UIView *)inView
{
    LoadingView *lv = [LoadingView shareInstance];
    if (tf == YES) {
        CGSize size = inView.frame.size;
        CGFloat off = 0;
        if ([MedGlobal getSysVer] >= 7.0) {
            off = 20;
        }
        CGSize bsize = [[UIScreen mainScreen] bounds].size;
        if (bsize.height == size.height) {
            lv.frame = CGRectMake(0, 44+off, size.width, size.height-(44+off));
        } else {
            lv.frame = CGRectMake(0, 0, size.width, size.height);
        }
        
        [inView addSubview:lv];
        [lv startTimer];
    } else {
        [lv setOffset:0];
        [lv disableTimer];
        [lv removeFromSuperview];
    }
}

+ (void)setOffset:(CGFloat)offset
{
    LoadingView *lv = [LoadingView shareInstance];
    [lv setOffset:offset];
}

- (void)startTimer
{
    index = 0;
    [self setProgress:index];
    //
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    timer = [NSTimer scheduledTimerWithTimeInterval:duration/repeat target:self selector:@selector(setDuration:) userInfo:nil repeats:YES];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    [runloop addTimer:timer forMode:UITrackingRunLoopMode];
}

- (void)disableTimer
{
    if ([timer isValid]) {
        [timer invalidate];
    }
}

- (void)showCover:(BOOL)tf
{
    bgView.hidden = !tf;
}

- (void)setDuration:(NSTimer*)theTimer
{
    [self setProgress:index];
}

- (void)setProgress:(NSInteger)idx
{
    index = idx+1;
    NSString *image = [NSString stringWithFormat:@"small-loader00%02d.png", (int)((index % repeat)+1)];
    loadingView.image = [ImageCenter getBundleImage:image];
}

- (void)setOffset:(CGFloat)offset
{
    offsety = offset;
    [self layoutSubviews];
}

@end
