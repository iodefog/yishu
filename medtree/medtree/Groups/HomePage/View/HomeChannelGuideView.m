//
//  HomeChannelGuideView.m
//  medtree
//
//  Created by tangshimi on 9/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelGuideView.h"

@interface HomeChannelGuideView ()

@property (nonatomic, strong) UIImageView *recommendImageView;
@property (nonatomic, strong) UIImageView *squareImageView;
@property (nonatomic, strong) UIImageView *writeImageView;

@end

@implementation HomeChannelGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.recommendImageView];
        [self addSubview:self.squareImageView];
        [self addSubview:self.writeImageView];

        [self.squareImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(GetScreenWidth > 320 ? 32.5 : 25);
            make.top.equalTo(@64);
        }];
        
        [self.recommendImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(GetScreenWidth > 320 ? -32.5 : -25);
            make.top.equalTo(@64);
        }];
        
        [self.writeImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(@-45);
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
    
    HomeChannelGuideView *view = [[self alloc] initWithFrame:inView.bounds];
    [inView addSubview:view];
}

#pragma mark -
#pragma mark - getter and setter -

- (UIImageView *)recommendImageView
{
    if (!_recommendImageView) {
        _recommendImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_recommend_guide.png");
            imageView;
        });
    }
    return _recommendImageView;
}

- (UIImageView *)squareImageView
{
    if (!_squareImageView) {
        _squareImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_square_guide.png");
            imageView;
        });
    }
    return _squareImageView;
}

- (UIImageView *)writeImageView
{
    if (!_writeImageView) {
        _writeImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_write_guide.png");
            imageView;
        });
    }
    return _writeImageView;
}

@end
