//
//  MedLoadingView.m
//  medtree
//
//  Created by tangshimi on 10/27/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedLoadingView.h"

static CGFloat const kAnimationDuration = 0.25;

@interface MedLoadingView ()

@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UIImageView *loadingTextImageView;
@property (nonatomic, strong) UIView *loadingContainerView;
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) CALayer *dotImageViewMask;

@end

@implementation MedLoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.loadingImageView];
        [self addSubview:self.loadingContainerView];
        [self.loadingContainerView addSubview:self.loadingImageView];
        [self addSubview:self.loadingTextImageView];
        [self addSubview:self.dotImageView];
        self.dotImageView.layer.mask = self.dotImageViewMask;
        self.dotImageViewMask.frame =  CGRectMake(-self.dotImageView.image.size.width, 0, self.dotImageView.image.size.width, self.dotImageView.image.size.height);
        
        [self.loadingContainerView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-10);
            make.size.equalTo(CGSizeMake(82, 82));
        }];
        
        self.loadingImageView.frame = CGRectMake(0, 0, 82, 82);
        
        [self.loadingTextImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loadingContainerView.bottom).offset(15);
            make.left.equalTo(self.loadingContainerView.left);
            make.bottom.equalTo(-10);
        }];
        
        [self.dotImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loadingTextImageView.top).offset(-5);
            make.left.equalTo(self.loadingTextImageView.right).offset(5);
        }];
        
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(82, 82);
}

#pragma mark -
#pragma mark - public -

+ (MedLoadingView *)showLoadingViewAddedTo:(UIView *)view
{
    MedLoadingView *loadingView = [[self alloc] init];
    [view addSubview:loadingView];
    
    [loadingView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(0);
    }];
    
    [loadingView startAnimation];
    
    return loadingView;
}

+ (BOOL)hideLoadingViewForView:(UIView *)view
{
    UIView *viewToRemove = nil;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            viewToRemove = subView;
        }
    }
    
    if (viewToRemove) {
        [viewToRemove removeFromSuperview];
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)restartAnimationInView:(UIView *)view
{
    MedLoadingView *loadingView = nil;
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[self class]]) {
            loadingView = (MedLoadingView *)subView;
        }
    }

    if (loadingView) {
        [loadingView startAnimation];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark - animation -

- (void)startAnimation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration = 6 * kAnimationDuration - 0.3;
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(-self.dotImageView.image.size.width, 0, self.dotImageView.image.size.width, self.dotImageView.image.size.height)];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, self.dotImageView.image.size.width, self.dotImageView.image.size.height)];
        [self.dotImageViewMask addAnimation:animation forKey:@"maskAnimation"];
    });
    
    [UIView animateWithDuration:kAnimationDuration delay:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
        self.loadingImageView.layer.transform = transform;
    } completion:^(BOOL finished) {
        self.loadingImageView.image = [UIImage imageNamed:@"loading_2.png"];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            CATransform3D transform =CATransform3DIdentity;
            self.loadingImageView.layer.transform = transform;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:kAnimationDuration animations:^{
                CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
                self.loadingImageView.layer.transform = transform;
            } completion:^(BOOL finished) {
                self.loadingImageView.image = [UIImage imageNamed:@"loading_3.png"];
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    CATransform3D transform =CATransform3DIdentity;
                    self.loadingImageView.layer.transform = transform;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:kAnimationDuration animations:^{
                        CATransform3D transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
                        self.loadingImageView.layer.transform = transform;
                    } completion:^(BOOL finished) {
                        self.loadingImageView.image = [UIImage imageNamed:@"loading_1.png"];
                        [UIView animateWithDuration:kAnimationDuration animations:^{
                            CATransform3D transform =CATransform3DIdentity;
                            self.loadingImageView.layer.transform = transform;
                        } completion:^(BOOL finished) {
                            if (finished) {
                                [self startAnimation];
                            }
                        }];
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)loadingImageView
{
    if (!_loadingImageView) {
        _loadingImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"loading_1.png");
            imageView;
        });
    }
    return _loadingImageView;
}

- (UIView *)loadingContainerView
{
    if (!_loadingContainerView) {
        _loadingContainerView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
    }
    return _loadingContainerView;
}

- (UIImageView *)loadingTextImageView
{
    if (!_loadingTextImageView) {
        _loadingTextImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"loading_text.png");
            imageView;
        });
    }
    return _loadingTextImageView;
}

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"loading_dot.png");
            imageView;
        });
    }
    return _dotImageView;
}

- (CALayer *)dotImageViewMask
{
    if (!_dotImageViewMask) {
        _dotImageViewMask = ({
            CALayer *layer = [CALayer layer];
            layer.anchorPoint = CGPointZero;
            layer.backgroundColor = [UIColor whiteColor].CGColor;
            layer;
        });
    }
    return _dotImageViewMask;
}

@end
