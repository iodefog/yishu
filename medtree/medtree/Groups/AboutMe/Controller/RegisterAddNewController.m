//
//  RegisterAddNewController.m
//  medtree
//
//  Created by 无忧 on 14-11-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "RegisterAddNewController.h"
#import "PersonEditSetTextView.h"
#import "InfoAlertView.h"
#import "LoadingView.h"
#import "ServiceManager.h"
#import "JSONKit.h"
#import "NewPersonIdentificationDetailController.h"
#import "AccountHelper.h"
#import "UserDTO.h"

@interface RegisterAddNewController ()
{
    UIButton *rightButton;
    NSString *topTitle;
    NSString *placeHolder;
    NSString *key;
    NSString *noticeMsg;
}

@property (nonatomic, strong) PersonEditSetTextView *textView;
@end

@implementation RegisterAddNewController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [self createRightButton];
    [self createBackButton];
}

- (void)createRightButton
{
    rightButton = [NavigationBar createNormalButton:@"确认" target:self action:@selector(btnClick)];
    rightButton.enabled = NO;
    [naviBar setRightButton:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupData];
    [self setupView];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    self.textView.frame = CGRectMake(0, [self getOffset]+44+10, size.width, 200);
}

- (void)setupData
{
    rightButton.enabled = self.content.length == 0 ? NO : YES;
    switch (self.infoType) {
        case EditUserInfoType_Interest:{
            topTitle = @"兴趣爱好";
            placeHolder = @"填写自己的兴趣爱好……";
            key = @"interest";
            noticeMsg = @"请填写兴趣爱好";
            break;
        }
        case EditUserInfoType_Honour:{
            topTitle = @"所获荣誉";
            placeHolder = @"填写自己的荣誉……";
            key = @"interest";
            noticeMsg = @"请填写荣誉";
            break;
        }
        case EditUserInfoType_Introduce:{
            topTitle = @"自我介绍";
            placeHolder = @"填写自我介绍……";
            key = @"interest";
            noticeMsg = @"请填写自我介绍";
            break;
        }
    }
    [self.textView setTextViewTextInfo:self.content];
    [naviBar setTopTitle:topTitle];
}

#pragma mark - getter & setter
- (PersonEditSetTextView *)textView
{
    if (_textView == nil) {
        _textView = [[PersonEditSetTextView alloc] initWithFrame:CGRectZero];
         [_textView setBgTitle:placeHolder];
        [self.view addSubview:_textView];
        _textView.parent = self;
    }
    return _textView;
}

- (void)checkIsEmpty
{
    if (self.textView.textViewInfo.length > 0) {
        rightButton.enabled = YES;
    } else {
        rightButton.enabled = NO;
    }
}

#pragma mark - click
- (void)btnClick
{
    if (self.textView.textViewInfo.length > 0) {
        [LoadingView showProgress:YES inView:self.view];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Update],@"data":[NSArray arrayWithObjects:@{@"value":self.textView.textViewInfo,@"key":key}, nil]} success:^(id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            UserDTO *udto = [AccountHelper getAccount];
            if (self.infoType == EditUserInfoType_Interest) {
                udto.interest = self.textView.textViewInfo;
            } else if (self.infoType == EditUserInfoType_Introduce) {
                udto.selfIntroduction = self.textView.textViewInfo;
            } else if (self.infoType == EditUserInfoType_Honour) {
                udto.honour = self.textView.textViewInfo;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
            });
            [AccountHelper setAccount:udto];
            [self clickBack];
        } failure:^(NSError *error, id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
                NSDictionary *result = [JSON objectFromJSONString];
                if (![result objectForKey:@"message"]) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        }];
    } else {
        [InfoAlertView showInfo:noticeMsg inView:self.view duration:1];
    }
}

@end
