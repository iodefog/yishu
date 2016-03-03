//
//  HomeJobChannelUnitViewController.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitViewController.h"
#import "CommonWebView.h"
#import <InfoAlertView.h>
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "MedShareManager.h"

@interface HomeJobChannelUnitViewController ()

@property (nonatomic, strong) CommonWebView *unitWebView;

@end

@implementation HomeJobChannelUnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unitWebView.frame = CGRectMake(0, 64, GetScreenWidth, GetScreenHeight - 64);
    
    [self.unitWebView loadRequestURL:self.enterpriseDTO.enterpriseURL];
    
    [ClickUtil event:@"homepage_channel_open_company" attributes:@{ @"company_id" : self.enterpriseDTO.enterpriseID,
                                                                    @"title" : self.enterpriseDTO.enterpriseName }];
}

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    
    [naviBar setTopTitle:self.enterpriseDTO.enterpriseName];
    
    [self.view addSubview:self.unitWebView];
}

#pragma mark -
#pragma mark - response event -

/*
 *网页调用
 */

- (void)clickShareWithInfo:(NSString *)message
{
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:self.enterpriseDTO.enterpriseName
                                         deatail:self.enterpriseDTO.shareInfo
                                           image:self.enterpriseDTO.enterpriseImage
                                    defaultImage:nil
                                        shareURL:self.enterpriseDTO.enterpriseURL];
}

#pragma mark -
#pragma mark - setter and getter -

- (CommonWebView *)unitWebView
{
    if (!_unitWebView) {
        _unitWebView = ({
            CommonWebView *webView = [[CommonWebView alloc] initWithFrame:self.view.bounds];
            webView.parentVC = self;
            webView;
        });
    }
    return _unitWebView;
}

@end
