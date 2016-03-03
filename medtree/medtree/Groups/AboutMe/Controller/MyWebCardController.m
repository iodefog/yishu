//
//  MyWebCardController.m
//  medtree
//
//  Created by 陈升军 on 15/9/29.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyWebCardController.h"

#import "CommonWebView.h"
#import "UrlParsingHelper.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "Keychain.h"
#import "ShareHelper.h"
#import "ChatFriendListController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "EditPersonCardInfoController.h"
#import "MedShareManager.h"

@interface MyWebCardController () <CommonWebViewDelegate>
{
    CommonWebView               *webView;
    UIButton                    *completeButton;
    UIButton                    *shareButton;
}

@end

@implementation MyWebCardController

- (void)viewDidAppear:(BOOL)animated
{
    if ([[AccountHelper getAccount] is_card_complete]) {
        [self createShareButton];
    } else {
        [self createCompleteButton];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];

    webView.frame = CGRectMake(0, [self getOffset]+44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-([self getOffset]+44));
    
    [ClickUtil event:@"me_card_view" attributes:nil];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"我的名片"];
    
    webView = [[CommonWebView alloc] initWithFrame:CGRectMake(0, [self getOffset]+44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-([self getOffset]+44))];
    webView.parentVC = self;
    webView.delegate = self;
    webView.isCanCyclic = YES;
    [self.view addSubview:webView];
    [self createBackButton];
}

- (void)createShareButton
{
    shareButton = [NavigationBar createImageButton:@"btn_share.png" selectedImage:@"btn_share_click.png" target:self action:@selector(clickShare)];
    [naviBar setRightButton:shareButton];
}

- (void)createCompleteButton
{
    completeButton = [NavigationBar createNormalButton:@"待完善" target:self action:@selector(clickComplete)];
    [naviBar setRightButton:completeButton];
}

- (void)clickComplete
{
    EditPersonCardInfoController *card = [[EditPersonCardInfoController alloc] init];
    card.userDTO = [AccountHelper getAccount];
    [self.navigationController pushViewController:card animated:YES];
}

- (void)loadData
{
    UserDTO *userDTO = [AccountHelper getAccount];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue]) {
        self.urlPath = [NSString stringWithFormat:@"http://test.m.medtree.cn/daily/personalcard?id=%@",userDTO.account_id];
    } else {
        self.urlPath = [NSString stringWithFormat:@"http://m.medtree.cn/daily/personalcard?id=%@",userDTO.account_id];
    }
    [webView loadRequestURL:self.urlPath];
}

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - commonwebview delegate

- (void)isCanShowClose:(BOOL)isShow
{
    
}

- (void)isCanShowError:(BOOL)isShow
{
    
}

- (void)isCanShowLoading:(BOOL)isShow
{
    
}

#pragma mark -
#pragma mark - 分享

- (void)clickShare
{
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:@"医树名片"
                                         deatail:[NSString stringWithFormat:@"姓名：%@\n医树号：%@",[[AccountHelper getAccount] name], [[AccountHelper getAccount] userID]] image:nil
                                    defaultImage:nil
                                        shareURL:self.urlPath];
    
}

@end
