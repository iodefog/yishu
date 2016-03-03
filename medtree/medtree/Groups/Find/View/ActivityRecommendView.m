//
//  ActivityRecommendView.m
//  medtree
//
//  Created by tangshimi on 5/28/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "ActivityRecommendView.h"
#import "UIColor+Colors.h"
#import "AccountHelper.h"
#import "UserDTO.h"

#import "CommonWebView.h"

@interface ActivityRecommendView ()

@property (nonatomic, strong) CommonWebView *activityRecommendWebView;
@property (nonatomic, strong) UIButton *iKnowButton;

@end

@implementation ActivityRecommendView

- (void)dealloc
{

}

- (void)createUI
{
    [self addSubview:self.activityRecommendWebView];
    [self addSubview:self.iKnowButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.activityRecommendWebView.frame = CGRectMake(0,
                                                     0,
                                                     CGRectGetWidth(self.frame),
                                                     CGRectGetHeight(self.frame) - 60);
    
    self.iKnowButton.frame = CGRectMake(0,
                                        CGRectGetHeight(self.frame) - 60,
                                        CGRectGetWidth(self.frame),
                                        60);
}

#pragma mark -
#pragma mark - response event -

- (void)iKnowButtonAction:(UIButton *)button
{
    [UIView animateWithDuration:1.0 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - setter and getter

- (CommonWebView *)activityRecommendWebView
{
    if(!_activityRecommendWebView){
        CommonWebView *webView = [[CommonWebView alloc] init];
        webView.isCanCyclic = NO;
        webView.parentVC = self.parentVC;
        _activityRecommendWebView = webView;
    }
    return _activityRecommendWebView;
}

- (UIButton *)iKnowButton
{
    if (!_iKnowButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"我知道了" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorFromHexString:@"#365c8a"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(iKnowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _iKnowButton = button;
    }
    return _iKnowButton;
}

- (void)setActivityRecommendURL:(NSString *)activityRecommendURL
{
    if (!activityRecommendURL) {
        return;
    }
    
    _activityRecommendURL = nil;
    _activityRecommendURL = activityRecommendURL;
    
    [self.activityRecommendWebView loadRequestURL:activityRecommendURL];
}

@end
