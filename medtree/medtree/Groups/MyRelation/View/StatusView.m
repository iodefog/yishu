//
//  StatusView.m
//  medtree
//
//  Created by tangshimi on 6/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "StatusView.h"

@interface StatusView ()

@property (nonatomic, strong)UIImageView *statusImageView;

@end

@implementation StatusView

static StatusView *statusView;

- (instancetype)initWithInView:(UIView *)inView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.frame = inView.bounds;
        [self addSubview:self.statusImageView];
    }
    return self;
}

#pragma mark - 
#pragma mark - public -

- (void)showWithStatusType:(StatusViewStatusType)statusType
{
    self.statusType = statusType;
}

- (void)hide
{
    if (self.removeFromSuperViewWhenHide) {
        [self removeFromSuperview];
    } else {
        self.hidden = YES;
    }
}

#pragma mark - 
#pragma mark - setter and getter -

- (UIImageView *)statusImageView
{
    if (!_statusImageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        _statusImageView = imageView;
    }
    return _statusImageView;
}

- (void)setStatusType:(StatusViewStatusType)statusType
{
    if (_statusType == statusType) {
        return;
    }
    
    _statusType = statusType;
    
    if (statusType == StatusViewLoadingStatusType) {
        self.statusImageView.image = [UIImage imageNamed:@"get_data_loading.png"];
        self.statusImageView.frame = CGRectMake(0, 0, 82, 82);
    } else if (statusType == StatusViewEmptyStatusType) {
        self.statusImageView.image = [UIImage imageNamed:@"get_data_no_data.png"];
        self.statusImageView.frame = CGRectMake(0, 0, 120, 44);
    }
    
    self.statusImageView.center = self.center;
}

@end
