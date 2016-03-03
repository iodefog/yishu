//
//  MyRelationGuideView.m
//  medtree
//
//  Created by tangshimi on 9/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MyRelationGuideView.h"

@interface MyRelationGuideView ()

@property (nonatomic, strong) UIImageView *expandImageView;
@property (nonatomic, strong) UIImageView *relationDescriptionImageView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, weak) UIView *buttonSuperView;
@property (nonatomic, copy) NSArray *buttonArray;


@end

@implementation MyRelationGuideView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.expandImageView];
        [self addSubview:self.relationDescriptionImageView];
        [self addSubview:self.circleImageView];
        
        [self.expandImageView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-5);
            make.top.equalTo(@20);
        }];
        
        CGFloat headerHeight = GetScreenWidth > 320 ? GetScreenWidth - 120 : 260;
        
        [self.relationDescriptionImageView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@100);
            make.top.equalTo(headerHeight + 64 - 10);
        }];
        
        [self.circleImageView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.circleImageView.height);
            make.top.equalTo(@74);
            make.centerX.equalTo(self.centerX);
        }];
        
        _buttonArray = [buttonArray copy];
        
        for (UIView *view in buttonArray) {
            view.userInteractionEnabled = NO;
            self.buttonSuperView = view.superview;
            CGRect frame = view.frame ;
            frame.origin.y += 64;
            view.frame = frame;
            [self addSubview:view];
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = 0;
        for (UIView *view in self.buttonArray) {
            [UIView animateWithDuration:0.35 animations:^{
                view.transform = CGAffineTransformMakeScale(0.6, 0.6);
            } completion:^(BOOL finished) {
                view.userInteractionEnabled = YES;
                CGRect frame = [view.superview convertRect:view.frame toView:self.buttonSuperView];
                view.frame = frame;
                [self.buttonSuperView addSubview:view];
                
                [UIView animateWithDuration:0.35 animations:^{
                    view.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }];
        }
    } completion:nil];
}

+ (void)showInView:(UIView *)inView buttonArray:(NSArray *)buttonArray;
{
    if (![BaseGuideView showGuideView:[NSString stringWithUTF8String:object_getClassName(self)]]) {
        return;
    }
    
    [BaseGuideView setAlreadyShow:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    MyRelationGuideView *view = [[self alloc] initWithFrame:inView.bounds buttonArray:buttonArray];
    view.alpha = 0;
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 1;
        [inView addSubview:view];
    } completion:nil];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)expandImageView
{
    if (!_expandImageView) {
        _expandImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"myrelation_expand_guide.png");
            imageView;
        });
    }
    return _expandImageView;
}

- (UIImageView *)relationDescriptionImageView
{
    if (!_relationDescriptionImageView) {
        _relationDescriptionImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"myrelation_description_guide.png");
            imageView;
        });
    }
    return _relationDescriptionImageView;
}

- (UIImageView *)circleImageView
{
    if (!_circleImageView) {
        _circleImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"myrelation_circle_guide.png");
            imageView;
        });
    }
    return _circleImageView;
}

@end
