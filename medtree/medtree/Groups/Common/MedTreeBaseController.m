//
//  MedTreeBaseController.m
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "ColorUtil.h"
#import "UserManager.h"
#import "InfoAlertView.h"
#import "ImageCenter.h"
#import "Aspects.h"

@interface MedTreeBaseController ()
{
    BOOL isShowErrorAlert;
}

@property (nonatomic, strong) UIView *noNetworkImageView;

@end

@implementation MedTreeBaseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            if (!self.hideNoNetworkImage && ![MedGlobal checkNetworkStatus]) {
                [self.view addSubview:self.noNetworkImageView];
                
                [self.noNetworkImageView makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
                }];
            }
        } error:NULL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)createUI
{
    [super createUI];
    
    isShowErrorAlert = NO;
    
    dataLoading = [[GetDataLoadingView alloc] init];
    dataLoading.hidden = YES;
    [self.view addSubview:dataLoading];
    
    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
}

- (UIButton *)createBackButton
{
    UIButton *backButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setImage:[ImageCenter getBundleImage:@"btn_back.png"] forState:UIControlStateNormal];
        [button setImage:[ImageCenter getBundleImage:@"btn_back_click.png"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    dataLoading.frame = CGRectMake(0, [self getOffset]+44+80, size.width, 100);
    [self.view bringSubviewToFront:dataLoading];
}

- (void)showErrorAlert:(NSString *)message
{
    if (isShowErrorAlert) {
        return;
    }
    isShowErrorAlert = YES;
    [InfoAlertView showInfo:message inView:[UIApplication sharedApplication].keyWindow duration:1];
    [self performSelector:@selector(changeShowErrorAlert) withObject:nil afterDelay:2];
}

- (void)changeShowErrorAlert
{
    isShowErrorAlert = NO;
}

#pragma mark -
#pragma mark - getter and setter -

- (UIView *)noNetworkImageView
{
    if (!_noNetworkImageView) {
        _noNetworkImageView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imageView = ({
                UIImageView *view = [[UIImageView alloc] initWithImage:GetImage(@"no_networks.png")];
                view;
            });
            
            [view addSubview:imageView];
            
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(0);
            }];
            
            view;
        });
    }
    return _noNetworkImageView;
}

@end
