//
//  RecorderView.m
//  medtree
//
//  Created by sam on 12/5/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "RecorderView.h"
#import "ImageCenter.h"

@interface RecorderView ()
{
    /** 录音过短 */
    UIImageView         *shortView;
}

@end

@implementation RecorderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgView.image = [ImageCenter getBundleImage:@"ON_chat_voice_play.png"];
    [self addSubview:bgView];
    
    timeView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:timeView];

    cancelView = [[UIImageView alloc] initWithFrame:CGRectZero];
    cancelView.image = [ImageCenter getBundleImage:@"OFF_chat_voice_play.png"];
    cancelView.hidden = YES;
    [self addSubview:cancelView];
    
    shortView = [[UIImageView alloc] init];
    shortView.image = [ImageCenter getBundleImage:@"short_chat_voice_play.png"];
    shortView.hidden = YES;
    [self addSubview:shortView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bgView.frame = CGRectMake((size.width-150)/2, (size.height-150)/2, 150, 150);
    timeView.frame = CGRectMake((size.width-150)/2, (size.height-150)/2, 150, 150);
    cancelView.frame = CGRectMake((size.width-150)/2, (size.height-150)/2, 150, 150);
    shortView.frame = CGRectMake((size.width-150)/2, (size.height-150)/2, 150, 150);
}

- (void)startRecord
{
    if ([timer isValid]) {
        [timer invalidate];
    }
    //
    shortView.hidden = YES;
    bgView.hidden = NO;
    timeView.hidden = NO;
    //
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    timeIndex = 0;
}

- (void)stopRecord
{
    [self setPlayTime:2];
    if ([timer isValid]) {
        [timer invalidate];
    }
    cancelView.hidden = YES;
}

- (void)setCancelRecordStatus:(BOOL)tf
{
    cancelView.hidden = !tf;
    bgView.hidden = tf;
    timeView.hidden = tf;
    shortView.hidden = YES;
}

- (void)timerFired:(NSTimer *)timerFired {
    [self setPlayTime:timeIndex];
    timeIndex++;
}

- (void)setShortCancelRecord
{
    cancelView.hidden = YES;
    bgView.hidden = YES;
    timeView.hidden = YES;
    shortView.hidden = NO;
    if ([timer isValid]) {
        [timer invalidate];
    }
}

- (void)setPlayTime:(NSInteger)idx
{
    timeView.image = [ImageCenter getBundleImage:[NSString stringWithFormat:@"ON_chat_voice_play%d.png", (int)idx%4+1]];
}

@end
