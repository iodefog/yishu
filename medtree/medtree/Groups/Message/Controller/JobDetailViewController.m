//
//  JobDetailViewController.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "JobDetailViewController.h"
#import "CommonWebView.h"
#import <InfoAlertView.h>
#import "MedShareManager.h"

@interface JobDetailViewController () <CommonWebViewDelegate>
{
    CommonWebView           *webView;
}

@property (nonatomic, strong) NSString *requestUrl;

@end

@implementation JobDetailViewController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    webView = [[CommonWebView alloc] init];
    webView.delegate = self;
    webView.isCanCyclic = YES;
    webView.parentVC = self;
    
    [self.view addSubview:webView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [naviBar setTopTitle:self.organization];
    
    [webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    if (self.positionId.length > 0) {
        self.requestUrl = [NSString stringWithFormat:@"%@/m/jobDetail.html?id=%@", [MedGlobal getJobUrl], self.positionId];
    } else {
        [InfoAlertView showInfo:@"没有查到此职位信息" inView:self.view duration:1.5];
    }
    
    [webView loadRequestURL:self.requestUrl];
}

- (void)clickShareWithInfo:(NSString *)message
{
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:self.organization
                                         deatail:self.shareInfo
                                           image:self.imageID
                                    defaultImage:nil
                                        shareURL:[NSString stringWithFormat:@"%@/m/jobDetail.html?id=%@", [MedGlobal getJobUrl], self.positionId]];
    
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

@end
