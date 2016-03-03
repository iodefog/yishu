//
//  BaseGuideView.m
//  medtree
//
//  Created by tangshimi on 6/4/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseGuideView.h"
#import "AccountHelper.h"
#import "UserDTO.h"

@interface BaseGuideView ()


@end

@implementation BaseGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        self.backView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+ (void)setAlreadyShow:(NSString *)className
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@", [AccountHelper getAccount].userID, className];
    [userDefault setObject:@(YES) forKey:key];
    [userDefault synchronize];
}

+ (BOOL)showGuideView:(NSString *)className
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@", [AccountHelper getAccount].userID, className];
    
    return ![[userDefault objectForKey:key] boolValue];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)backView
{
    if (!_backView) {
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        _backView = backView;
    }
    return _backView;
}

@end
