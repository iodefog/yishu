//
//  ProgressView.m
//  hangcom-ui
//
//  Created by sam on 13-7-11.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "ProgressView.h"
#import "CircularProgressView.h"
#import "ImageCenter.h"

@implementation ProgressView

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
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)createUI
{
    bgView = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"img_trans_cover.png"]];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    
    circularView = [[CircularProgressView alloc] initWithFrame:CGRectZero];
    [self addSubview:circularView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    circularView.frame = CGRectMake((size.width*3)/8, (size.height-size.width/4)/2, size.width/4, size.width/4);
}

- (void)showBgView:(BOOL)tf
{
    bgView.hidden = !tf;
}

- (void)setProgess:(CGFloat)p
{
    circularView.progress = p;
}

+ (id)shareInstance
{
    static ProgressView *pv = nil;
    if (pv == nil) {
        pv = [[ProgressView alloc] initWithFrame:CGRectZero];
    }
    return pv;
}

+ (void)showProgress:(BOOL)tf inView:(UIView *)inView
{
    ProgressView *pv = [ProgressView shareInstance];
    if (tf == YES) {
        CGSize size = inView.frame.size;
        pv.frame = CGRectMake(0, 0, size.width, size.height);
        [inView addSubview:pv];
    } else {
        [pv removeFromSuperview];
        pv = nil;
    }
}

+ (void)setProgess:(CGFloat)p
{
    [[ProgressView shareInstance] setProgess:p];
}

+ (void)setDuration:(CGFloat)time from:(CGFloat)from to:(CGFloat)to
{
    [[ProgressView shareInstance] setDuration:time from:from to:to];
}

+ (void)disableTimer
{
    [[ProgressView shareInstance] disableTimer];
}

- (void)setDuration:(CGFloat)time from:(CGFloat)from to:(CGFloat)to
{
    timerCount = 0;
    NSInteger repeat = 100;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithFloat:from] forKey:@"From"];
    [userInfo setObject:[NSNumber numberWithFloat:to] forKey:@"To"];
    [userInfo setObject:[NSNumber numberWithFloat:repeat] forKey:@"Repeat"];
    //
    timer = [NSTimer scheduledTimerWithTimeInterval:time/repeat target:[ProgressView shareInstance] selector:@selector(setDuration:) userInfo:userInfo repeats:YES];
}

- (void)disableTimer
{
    if ([timer isValid]) {
        [timer invalidate];
    }
}

- (void)setDuration:(NSTimer*)theTimer
{
    NSDictionary *userInfo = theTimer.userInfo;
    CGFloat from = [[userInfo objectForKey:@"From"] floatValue];
    CGFloat to = [[userInfo objectForKey:@"To"] floatValue];
    CGFloat repeat = [[userInfo objectForKey:@"Repeat"] floatValue];
    CGFloat step = (to-from)/repeat;
    timerCount++;
    if (timerCount <= repeat) {
        CGFloat p = from+step*timerCount;
        NSLog(@"duration %f", p);
        [self setProgess:p];
    }
}

@end
