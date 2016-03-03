//
//  AdvertisementView.m
//  medtree
//
//  Created by tangshimi on 7/3/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AdvertisementView.h"
#import "UIImageView+setImageWithURL.h"
#import "MedGlobal.h"
#import "RecommendDTO.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import <DateUtil.h>

@interface AdvertisementView ()

@property (strong, nonatomic) UIImageView *advertisementImageView;
@property (strong, nonatomic) UIButton *closeButton;
@property (weak, nonatomic) UIView *inView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation AdvertisementView

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.inView = inView;
        
        [self addSubview:self.advertisementImageView];
        [self.advertisementImageView addSubview:self.closeButton];
        [self.advertisementImageView addGestureRecognizer:self.tapGesture];
        
        self.advertisementImageView.frame = CGRectMake(15, 85, CGRectGetWidth(inView.bounds) - 30, CGRectGetHeight(inView.bounds) - 85 - 60);
        self.closeButton.frame = CGRectMake(CGRectGetWidth(self.advertisementImageView.frame) - 15, -10, 20, 20);
    }
    return self;
}

#pragma mark - 
#pragma mark - response event -

- (void)closeButtonAction:(UIButton *)button
{
    [self hideAnimated:YES];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tap
{
    [self hideAnimated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.clickBlock();
    });
}

#pragma mark -
#pragma mark - public -

- (void)showAnimated:(BOOL)animated
{
    self.frame = self.inView.bounds;
    [self.inView addSubview:self];
    
    if (animated) {
        self.advertisementImageView.alpha = 0;
        self.advertisementImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        [UIView animateWithDuration:0.5 animations:^{
            self.advertisementImageView.alpha = 1;
            self.advertisementImageView.transform = CGAffineTransformIdentity;
        }];
    } else {

    }
}

#pragma mark -
#pragma mark - private -

- (void)hideAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.advertisementImageView.alpha = 0;
            self.advertisementImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideAnimated:YES];
}

#pragma mark - 
#pragma mark - getter and setter -

- (UIImageView *)advertisementImageView
{
    if (!_advertisementImageView) {
        UIImageView *advertisementImageView = [[UIImageView alloc] init];
        advertisementImageView.contentMode = UIViewContentModeScaleAspectFit;
        advertisementImageView.userInteractionEnabled = YES;
        advertisementImageView.backgroundColor = [UIColor clearColor];
        _advertisementImageView = advertisementImageView;
    }
    return _advertisementImageView;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"home_advertisement_close.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _closeButton = closeButton;
    }
    return _closeButton;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        tap.delaysTouchesBegan = YES;
        _tapGesture = tap;
    }
    return _tapGesture;
}

- (void)setRecommendDTO:(RecommendDTO *)recommendDTO
{
    if (!recommendDTO) {
        return;
    }
    
    _recommendDTO = recommendDTO;
    NSString *bimageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], recommendDTO.image_id];
    [self.advertisementImageView med_setImageWithUrl:[NSURL URLWithString:bimageURL]];
    
    NSString *currentTime = [DateUtil convertToDay:[NSDate date]];
    NSString *key = [NSString stringWithFormat:@"%@%@",[AccountHelper getAccount].userID, @"advertismentTime"];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:currentTime forKey:key];
    [userDefault synchronize];
}

- (BOOL)todayShowAdvertisementView
{
    NSString *key = [NSString stringWithFormat:@"%@%@",[AccountHelper getAccount].userID, @"advertismentTime"];

    NSString *currentTime = [DateUtil convertToDay:[NSDate date]];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [userDefault objectForKey:key];
    
    return [currentTime isEqualToString:lastTime];
}

@end
