//
//  HomeGuideView.m
//  medtree
//
//  Created by tangshimi on 9/29/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeGuideView.h"
#import "LoginGetIntegralView.h"

@interface HomeGuideView ()

@property (nonatomic, strong) UIImageView *channelImageView;
@property (nonatomic, strong) UIImageView *channelMoreImageView;

@end

@implementation HomeGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backView.hidden = YES;
        
        UIView *topView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            view;
        });
        
        UIView *bottomLeftView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            view;
        });
        
        UIView *bottomRightView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            view;
        });
        
        UIView *midView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
            view;
        });

        
        [self addSubview:topView];
        [self addSubview:midView];
        [self addSubview:bottomLeftView];
        [self addSubview:bottomRightView];
        
        [self addSubview:self.channelImageView];
        [self addSubview:self.channelMoreImageView];
        
        [self.channelImageView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(topView.bottom).offset(-5);
            make.left.equalTo(@40);
        }];
        
        [self.channelMoreImageView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(midView.bottom).offset(-5);
            make.left.equalTo(90);
        }];
        
        CGFloat width = (GetScreenWidth - 2) / 3;
        CGFloat height = width * (200 / 245.0) * 2;
        height++;
        
        [topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(64 + 30 + height + 40);
        }];
        
        [bottomLeftView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(midView.bottom);
            make.left.equalTo(0);
            make.width.equalTo(GetScreenWidth / 5);
            make.bottom.equalTo(0);
        }];
        
        [bottomRightView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(midView.bottom);
            make.left.equalTo(GetScreenWidth / 5 * 2);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
        
        [midView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView.bottom).offset(55);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(-49);
        }];
    }
    return self;
}

+ (BOOL)showInView:(UIView *)inView
{
    if (![BaseGuideView showGuideView:[NSString stringWithUTF8String:object_getClassName(self)]]) {
        return NO;
    }
    [BaseGuideView setAlreadyShow:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    HomeGuideView *view = [[HomeGuideView alloc] initWithFrame:inView.bounds];
    view.alpha = 0;
    
    __block LoginGetIntegralView *integralView = nil;
    
    [inView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LoginGetIntegralView class]]) {
            integralView = obj;
        }
    }];
    
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1;
        if (integralView) {
            [inView insertSubview:view belowSubview:integralView];
        } else {
            [inView addSubview:view];
        }
    }];
    return YES;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)channelImageView
{
    if (!_channelImageView) {
        _channelImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_person_page.png");
            imageView;
        });
    }
    return _channelImageView;
}

- (UIImageView *)channelMoreImageView
{
    if (!_channelMoreImageView) {
        _channelMoreImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_jon_guide.png");
            imageView;
        });
    }
    return _channelMoreImageView;
}

@end
