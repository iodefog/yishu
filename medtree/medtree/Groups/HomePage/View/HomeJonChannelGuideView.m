//
//  HomeJonChannelGuideView.m
//  medtree
//
//  Created by tangshimi on 11/9/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJonChannelGuideView.h"

@interface HomeJonChannelGuideView ()

@property (nonatomic, strong) UIImageView *notificationImageView;

@end

@implementation HomeJonChannelGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.notificationImageView];
        
        [self.notificationImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(22);
            make.right.equalTo(-5);
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
    
    HomeJonChannelGuideView *view = [[self alloc] initWithFrame:inView.bounds];
    view.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1.0;
        [inView addSubview:view];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)notificationImageView
{
    if (!_notificationImageView) {
        _notificationImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_job_channel_guide.png");
            imageView;
        });
    }
    return _notificationImageView;
}

@end
