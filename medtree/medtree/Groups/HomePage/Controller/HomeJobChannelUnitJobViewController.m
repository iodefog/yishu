//
//  HomeJobChannelUnitJobViewController.m
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitJobViewController.h"
#import "CommonWebView.h"
#import "HomeJobChannelEmploymentDTO.h"
#import <JSONKit.h>
#import <InfoAlertView.h>
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MedShareManager.h"
#import "ChannelManager.h"

@interface HomeJobChannelUnitJobViewController ()

@property (nonatomic, strong) CommonWebView *unitWebView;

@end

@implementation HomeJobChannelUnitJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.unitWebView.frame = CGRectMake(0, 64, GetScreenWidth, GetScreenHeight - 64);

    if (self.employmentDTO) {
        [self.unitWebView loadRequestURL:self.employmentDTO.employmentURL];
        
        [ClickUtil event:@"homepage_channel_company_share" attributes:@{ @"job_id" : self.employmentDTO.employmentID, @"title" : self.employmentDTO.employmentTitle }];
    } else {
        [self employmentRequest];
    }
    
    [AccountHelper getAccount].lookEmploymentAndEnterpriseCount ++;
}

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    
    [self.view addSubview:self.unitWebView];
    
    [naviBar setTopTitle:self.employmentDTO.employmentTitle];
}

- (void)clickShareWithInfo:(NSString *)message
{
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:self.employmentDTO.employmentTitle
                                         deatail:self.employmentDTO.shareInfo
                                           image:self.employmentDTO.imageURL
                                    defaultImage:nil
                                        shareURL:self.employmentDTO.employmentURL];
}

#pragma mark -
#pragma mark - request -

- (void)employmentRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeJobChannelEmploymentByID), @"job_id" : self.employmentID };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        if (JSON[@"success"]) {
            self.employmentDTO = JSON[@"employment"];
            
            [self.unitWebView loadRequestURL:self.employmentDTO.employmentURL];
        }
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (CommonWebView *)unitWebView
{
    if (!_unitWebView) {
        _unitWebView = ({
            CommonWebView *webView = [[CommonWebView alloc] initWithFrame:self.view.bounds];
            webView.isCanCyclic = YES;
            webView.parentVC = self;
            webView;
        });
    }
    return _unitWebView;
}

@end
