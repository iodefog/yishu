//
//  CommonWebController.m
//  medtree
//
//  Created by 陈升军 on 15/9/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CommonWebController.h"
#import "CommonWebView.h"
#import "UrlParsingHelper.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "Keychain.h"
#import "ShareHelper.h"
#import "ChatFriendListController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "MedShareManager.h"

@interface CommonWebController () <CommonWebViewDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>
{
    CommonWebView               *webView;
    BOOL                        isCanGoBack;
    UIButton                    *closeButton;
    UIButton                    *shareButton;
    NSString                    *shareInfo;
}


@end

@implementation CommonWebController

- (void)viewDidAppear:(BOOL)animated
{
    [webView.commonWebView reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadData];
    
    shareButton.hidden = !self.isShowShare;
    if (self.naviTitle.length > 0) {
        [naviBar setTopTitle:self.naviTitle];
    } else {
        [naviBar setTopTitle:@"详情"];
    }
    
    webView.frame = CGRectMake(0, [self getOffset]+44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-([self getOffset]+44));
}

- (void)createUI
{
    [super createUI];
    
    webView = [[CommonWebView alloc] initWithFrame:CGRectMake(0, [self getOffset]+44, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-([self getOffset]+44))];
    webView.parentVC = self;
    webView.delegate = self;
    webView.isCanCyclic = YES;
    [self.view addSubview:webView];
    [self createShareButton];
    [self createCloseButton];
}

- (void)createCloseButton
{
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(40, 0, 44, 44);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickClose) forControlEvents:UIControlEventTouchUpInside];
    [naviBar setLeftButtons:@[[self createBackButton], closeButton]];
    closeButton.hidden = YES;
}

- (void)createShareButton
{
    shareButton = [NavigationBar createImageButton:@"btn_share.png" selectedImage:@"btn_share_click.png" target:self action:@selector(clickShare)];
    [naviBar setRightButton:shareButton];
    shareButton.hidden = YES;
}

- (void)loadData
{
    [webView loadRequestURL:self.urlPath];
}

- (void)clickBack
{
    if (isCanGoBack) {
        [webView.commonWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)clickClose
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - commonwebview delegate

- (void)isCanShowClose:(BOOL)isShow
{
    isCanGoBack = isShow;
    closeButton.hidden = !isShow;
    [naviBar setNeedsLayout];
}

- (void)isCanShowError:(BOOL)isShow
{
    
}

- (void)isCanShowLoading:(BOOL)isShow
{
    
}

#pragma mark -
#pragma mark - 分享

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 12346) {
        if (buttonIndex == 0) {
            ChatFriendListController *cflc = [[ChatFriendListController alloc] init];
            cflc.shareInfo = shareInfo;
            [self.navigationController pushViewController:cflc animated:YES];
        } else if (buttonIndex == 1) {
            [[MedShareManager sharedInstance] showInView:self.view text:shareInfo];
        } else if (buttonIndex == 2) {
            [self sendSMS:shareInfo recipientList:@[]];
        }
    }
}

- (void)clickShare
{
    [[MedShareManager sharedInstance] showInView:self.view
                                           title:self.shareTitle
                                         deatail:self.shareDescription
                                           image:self.shareImageID
                                    defaultImage:nil
                                        shareURL:self.urlPath];
}

- (void)clickShareWithInfo:(NSString *)info
{
    shareInfo = info;
    //
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"医树好友", @"其他好友", @"发送短信", nil];
    sheet.tag = 12346;
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark - 短信代理

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{
            
        }];
    }
}

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MessageComposeResultCancelled) {
            [InfoAlertView showInfo:@"短信发送已取消！" inView:self.view duration:1];
        } else if (result == MessageComposeResultSent) {
            [InfoAlertView showInfo:@"短信发送成功！" inView:self.view duration:1];
        } else {
            [InfoAlertView showInfo:@"短信发送失败！" inView:self.view duration:1];
        }
    }];
}

@end
