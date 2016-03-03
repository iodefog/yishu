//
//  NavigationBarHeadView.m
//  medtree
//
//  Created by tangshimi on 7/30/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "NavigationBarHeadView.h"
#import "AccountHelper.h"
#import "UserManager.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"
#import "RootViewController.h"
@interface NavigationBarHeadView ()

@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation NavigationBarHeadView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(15, 7, 50, 30);
        [self addSubview:self.dotImageView];
        [self addSubview:self.headImageView];
        
        self.dotImageView.frame = CGRectMake(12, 0, 4, 30);
        self.headImageView.frame = CGRectMake(CGRectGetMaxX(self.dotImageView.frame) + 4, 0, 30, 30);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChangeAction:) name:UserInfoChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuViewControllerWillShowAction:) name:MenuViewControllerWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuViewControllerWillHideAction:) name:MenuViewControllerWillHideNotification object:nil];
        
        [self userInfoChangeAction:nil];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark - response evnet -

- (void)userInfoChangeAction:(NSNotification *)notification
{
    UserDTO *userDTO = [AccountHelper getAccount];
    
    if (userDTO) {
        NSString *path = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Small], [userDTO photoID]];
        [self.headImageView med_setImageWithUrl:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"img_head.png"]];
    }    
}

- (void)menuViewControllerWillShowAction:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.userInfo;
    if (infoDic) {
        self.alpha = [infoDic[@"alpha"] floatValue];
    } else {
        [UIView animateWithDuration:0.35 animations:^{
            self.alpha = 0;
        }];
    }
}

- (void)menuViewControllerWillHideAction:(NSNotification *)notification
{
    NSDictionary *infoDic = notification.userInfo;
    if (infoDic) {
        self.alpha = [infoDic[@"alpha"] floatValue];
    } else {
         [UIView animateWithDuration:0.35 animations:^{
             self.alpha = 1;
         }];
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)dotImageView
{
    if (!_dotImageView) {
        _dotImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage imageNamed:@"head_view_dot.png"];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView;
        });
    }
    return _dotImageView;
}

- (UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            imageView.layer.borderWidth = 1.0;
            imageView.layer.cornerRadius = 15.0;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
    }
    return _headImageView;
}

@end
