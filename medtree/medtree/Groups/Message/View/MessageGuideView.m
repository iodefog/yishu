//
//  MessageGuideView.m
//  medtree
//
//  Created by tangshimi on 9/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MessageGuideView.h"

@interface MessageGuideView ()

@property (nonatomic, strong) UIView *topBlackView;
@property (nonatomic, strong) UIView *bottomBlackView;
@property (nonatomic, strong) UIImageView *notificationImageView;

@end

@implementation MessageGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backView.hidden = YES;
        
        [self addSubview:self.topBlackView];
        [self addSubview:self.bottomBlackView];
        [self addSubview:self.notificationImageView];
        
        [self.topBlackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(0);
            make.right.equalTo(0);
            make.height.equalTo(274);
        }];
        
        [self.bottomBlackView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(0);
            make.top.equalTo(344);
            make.right.equalTo(0);
            make.bottom.equalTo(0);
        }];
        
        [self.notificationImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(344);
            make.centerX.equalTo(0);
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
    
    MessageGuideView *view = [[self alloc] initWithFrame:inView.bounds];
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
            imageView.image = GetImage(@"message_guide.png");
            imageView;
        });
    }
    return _notificationImageView;
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
