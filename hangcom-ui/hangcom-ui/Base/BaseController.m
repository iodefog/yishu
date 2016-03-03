//
//  BaseController.m
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseController.h"
#import "BaseConfig.h"
#import "ImageCenter.h"

@interface BaseController () 

@end

@implementation BaseController

- (void)loadView
{
    [super loadView];
    [self createUI];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [self removeCatenaImageNotifications];
    [self removeNotifications];
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (void)createUI
{
    [self createStatusBar];
    [self createNaviBar];
    [self registerNotifications];
    [self registerCatenaImageNotifications];
}

- (void)createStatusBar
{
    CGSize size = self.view.frame.size;
    statusBar = [[UIImageView alloc] init];
    statusBar.image = [ImageCenter getBundleCatenaImage:@"naviBar_background_top.png"];
    statusBar.frame = CGRectMake(0, [BaseConfig getOffset]-20, size.width, 20);
    statusBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:statusBar];

    if ([BaseConfig getSysVer] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;//OS7.0 指定边缘要延伸的方向
    }
}

- (void)createNaviBar
{
    CGSize size = self.view.frame.size;
    naviBar = [[NavigationBar alloc] initWithSize:CGSizeMake(size.width, 44)];
    naviBar.frame = CGRectMake(0, [BaseConfig getOffset], size.width, 44);
    naviBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:naviBar];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
//    CGSize size = self.view.frame.size;
//    statusBar.frame = CGRectMake(0, [BaseConfig getOffset]-20, size.width, 20);
//    naviBar.frame = CGRectMake(0, [BaseConfig getOffset], size.width, 44);
    if ([BaseConfig getSysVer] >= 7.0) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)registerNotifications
{

}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerCatenaImageNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCatenaImage) name:@"reloadCatenaImage" object:nil];
}

- (void)removeCatenaImageNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadCatenaImage" object:nil];
}

- (void)reloadCatenaImage
{
    [naviBar reloadBGImage];
    statusBar.image = [ImageCenter getBundleCatenaImage:@"naviBar_background_top.png"];
}

- (CGFloat)getOffset
{
    return [BaseConfig getOffset];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
