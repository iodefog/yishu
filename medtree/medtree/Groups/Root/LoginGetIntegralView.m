//
//  LoginGetIntegralView.m
//  medtree
//
//  Created by tangshimi on 9/17/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "LoginGetIntegralView.h"
#import "SignDTO.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import <DateUtil.h>
#import "UIColor+Colors.h"

@interface LoginGetIntegralView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *firstLineLabel;
@property (nonatomic, strong) UILabel *secondLineLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *getMoreIntegralButton;
@property (nonatomic, strong) UIImageView *closeImageView;

@end

@implementation LoginGetIntegralView

- (void)createUI
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.topImageView];
    [self.containerView addSubview:self.titleButton];
    [self.containerView addSubview:self.firstLineLabel];
    [self.containerView addSubview:self.secondLineLabel];
    [self.containerView addSubview:self.detailLabel];
    [self.containerView addSubview:self.getMoreIntegralButton];
    [self.containerView addSubview:self.closeImageView];
    
    [self.containerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(32);
        make.right.equalTo(-32);
        make.height.equalTo(self.containerView.width).multipliedBy(650 / 600);
        make.centerY.equalTo(self.centerY);
    }];
    
    [self.closeImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(5);
        make.right.equalTo(-10);
    }];
    
    [self.topImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [self.topImageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(-50);
        make.centerX.equalTo(0);
    }];
    
    [self.titleButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.topImageView.bottom).offset(5);
        make.size.equalTo(CGSizeMake(100, 25));
    }];
    
    [self.firstLineLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.firstLineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleButton.bottom).offset(10);
        make.centerX.equalTo(0);
    }];
    
    [self.secondLineLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.secondLineLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstLineLabel.bottom);
        make.centerX.equalTo(0);
    }];
  
    [self.getMoreIntegralButton makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView.bottom).offset(-5).priorityHigh();
        make.centerX.equalTo(0);
    }];

    [self.detailLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(0);
        make.top.equalTo(self.secondLineLabel.bottom);
        make.bottom.equalTo(self.getMoreIntegralButton.top);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hide];
}

#pragma mark -
#pragma mark - response event -

- (void)getMoreIntegralButtonAction:(UIButton *)button
{
    if (self.getMoreIntegralBlock) {
        self.getMoreIntegralBlock();
        
        [self hide];
    }
}

#pragma mark -
#pragma mark - show and hide -

- (void)showInView:(UIView *)inView
{
    [inView addSubview:self];
    self.frame = inView.bounds;

    [self updateConstraintsIfNeeded];

    self.containerView.alpha = 0;
    self.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.containerView.alpha = 1;
        self.containerView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.35 animations:^{
        self.containerView.alpha = 0;
        self.containerView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - public -

- (void)setTodayAlreadyGetIntergtal
{
    NSString *key = [NSString stringWithFormat:@"%@-kGetIntegralNSUserDefaultKey", [AccountHelper getAccount].userID];
    NSString *time = [DateUtil convertToDay:[NSDate date]];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:time forKey:key];
    [userDefault synchronize];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 10;
            
            view;
        });
    }
    return _containerView;
}

- (UIButton *)titleButton
{
    if (!_titleButton) {
        _titleButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"积分兑好礼" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            [button setTitleColor:[UIColor colorFromHexString:@"#ffc83b"] forState:UIControlStateNormal];
            button.layer.cornerRadius = 12.5;
            button.clipsToBounds = YES;
            button.layer.borderColor = [UIColor colorFromHexString:@"#ffc83b"].CGColor;
            button.layer.borderWidth = 1.0;
            button;
        });
    }
    return _titleButton;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"quick_sign_bg.png");
            imageView;
        });
    }
    return _topImageView;
}

- (UILabel *)firstLineLabel
{
    if (!_firstLineLabel) {
        _firstLineLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont boldSystemFontOfSize:24];
            label.textColor = [UIColor blackColor];
            label.text = @"登录送积分";
            label;
        });
    }
    return _firstLineLabel;
}

- (UILabel *)secondLineLabel
{
    if (!_secondLineLabel) {
        _secondLineLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor blackColor];
            label;
        });
    }
    return _secondLineLabel;
}


- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 2;
            label.textColor = [UIColor colorFromHexString:@"#ffc83b"];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:50];
        
            label;
        });
    }
    return _detailLabel;
}

- (UIButton *)getMoreIntegralButton
{
    if (!_getMoreIntegralButton) {
        _getMoreIntegralButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"如何赚取更多积分" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(getMoreIntegralButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _getMoreIntegralButton;
}

- (UIImageView *)closeImageView
{
    if (!_closeImageView) {
        _closeImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"btn_academic_delete.png");
            imageView;
        });
    }
    return _closeImageView;
}


- (void)setSignDTO:(SignDTO *)signDTO
{
    _signDTO = signDTO;
    
    [self setTodayAlreadyGetIntergtal];
    
    NSString *text = nil;
    if (signDTO.content && ![signDTO.content isEqualToString:@""]) {
        text = [NSString stringWithFormat:@"+%@", @(signDTO.point)];
        
        self.topImageView.image = GetImage(@"sign_in_continuous.png");
    } else {
        text = [NSString stringWithFormat:@"+%@", @(signDTO.point)];
        
       self.topImageView.image = GetImage(@"sign_in.png");
    }

    self.secondLineLabel.text = signDTO.content;
    self.detailLabel.text =  text;
}

- (BOOL)todayGetIntegral
{
    NSString *key = [NSString stringWithFormat:@"%@-kGetIntegralNSUserDefaultKey", [AccountHelper getAccount].userID];
    NSString *time = [DateUtil convertToDay:[NSDate date]];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [userDefault objectForKey:key];
    
    return [time isEqualToString:lastTime];
}

@end
