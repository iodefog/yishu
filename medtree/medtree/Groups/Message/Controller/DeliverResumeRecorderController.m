//
//  DeliverResumeRecorderController.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DeliverResumeRecorderController.h"
#import "JobDetailViewController.h"
#import "CommonWebView.h"
#import <InfoAlertView.h>

@interface DeliverResumeRecorderController () <CommonWebViewDelegate>
{
    CommonWebView           *webView;
}
@property (nonatomic, strong) NSString *requestUrl;

@end

@implementation DeliverResumeRecorderController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    [self createRightButton];
    [naviBar setTopTitle:@"投递记录"];
    
    webView = [[CommonWebView alloc] initWithFrame:CGRectMake(0, 64, GetViewWidth(self.view), GetViewHeight(self.view) - 64)];
    webView.delegate = self;
    webView.parentVC = self;
    webView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.view addSubview:webView];
}

- (void)createRightButton
{
    UIButton *rightButton = [NavigationBar createRightButton:@"职位" target:self action:@selector(clickPosition)];
    [naviBar setRightButton:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.applyID.length > 0) {
        self.requestUrl = [NSString stringWithFormat:@"%@/m/myResumeNotice.html?id=%@", [MedGlobal getJobUrl],self.applyID];
        [webView loadRequestURL:self.requestUrl];
    } else {
        [InfoAlertView showInfo:@"无效的职位申请信息" inView:self.view duration:1.0];
    }
}

#pragma mark - CommonWebViewDelegate
- (void)isCanShowClose:(BOOL)isShow
{
    
}

- (void)isCanShowLoading:(BOOL)isShow
{
    
}

- (void)isCanShowError:(BOOL)isShow
{
    
}

#pragma mark - click
- (void)clickPosition
{
    JobDetailViewController *vc = [[JobDetailViewController alloc] init];
    vc.organization = self.organization;
    vc.positionId = self.positionId;
    vc.imageID = self.imageID;
    vc.shareInfo = self.shareInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIWebViewDelegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [InfoAlertView showInfo:@"当前设备无法拨打电话" duration:1.5];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

@end
