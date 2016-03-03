//
//  FindGuideView.m
//  medtree
//
//  Created by tangshimi on 9/29/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "FindGuideView.h"

@interface FindGuideView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIImageView *eventDescriptionImageView;

@end

@implementation FindGuideView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backView.hidden = YES;
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self addSubview:self.eventDescriptionImageView];
        
        [self.topView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.height.equalTo(@104);
        }];
        
        [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(214, 0, 0, 0));
        }];
        
        [self.eventDescriptionImageView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.top).offset(10);
            make.left.equalTo(self.centerX);
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
    
    FindGuideView *view = [[FindGuideView alloc] initWithFrame:inView.bounds];
    [inView addSubview:view];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)topView
{
    if (!_topView) {
        _topView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _topView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            view;
        });
    }
    return _bottomView;
}

- (UIImageView *)eventDescriptionImageView
{
    if (!_eventDescriptionImageView) {
        _eventDescriptionImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"find_event_guide.png");
            imageView;
        });
    }
    return _eventDescriptionImageView;
}

@end
