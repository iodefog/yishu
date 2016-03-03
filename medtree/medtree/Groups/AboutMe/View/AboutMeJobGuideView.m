//
//  AboutMeJobGuideView.m
//  medtree
//
//  Created by tangshimi on 11/9/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "AboutMeJobGuideView.h"

@interface AboutMeJobGuideView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *topBlackView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *bottomBlackView;

@end

@implementation AboutMeJobGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backView.hidden = YES;
    
        [self addSubview:self.topBlackView];
        [self addSubview:self.midView];
        [self addSubview:self.bottomBlackView];
        [self addSubview:self.imageView];
        
        [self.topBlackView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.left.equalTo(0);
            make.height.equalTo(277.5);
        }];
        
        [self.midView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBlackView.bottom);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(45);
        }];
        
        [self.bottomBlackView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.midView.bottom);
            make.left.equalTo(0);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
        
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.midView.top);
            make.centerX.equalTo(-20);
        }];
    }
    return self;
}

+ (void)showInView:(UIView *)inView
{
    if (![BaseGuideView showGuideView:[NSString stringWithUTF8String:object_getClassName(self)]]) {
        return;
    }
    [BaseGuideView setAlreadyShow:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    AboutMeJobGuideView *view = [[self alloc] initWithFrame:inView.bounds];
    view.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1.0;
        [inView addSubview:view];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"about_me_integral_guide.png");
            imageView;
        });
    }
    return _imageView;
}

- (UIView *)topBlackView
{
    if (!_topBlackView) {
        _topBlackView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _topBlackView;
}

- (UIView *)midView
{
    if (!_midView) {
        _midView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
            view;
        });
    }
    return _midView;
}

- (UIView *)bottomBlackView
{
    if (!_bottomBlackView) {
        _bottomBlackView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _bottomBlackView;
}

@end
