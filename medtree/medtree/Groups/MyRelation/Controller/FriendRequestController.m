//
//  FriendRequestController.m
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FriendRequestController.h"
#import "SwitchCell.h"
#import "PairDTO.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "Pair2DTO.h"
#import "TextFieldCell.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "UserManager.h"
#import "LoadingView.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"

@interface FriendRequestController ()
{
    NSInteger           typeNum;
    NSString            *userID;
    NSString            *message;
    BOOL                isOn;
    BOOL                isChange;
}

@end

@implementation FriendRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
}

#pragma mark - system method
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //隐私时 在此处进行数据上传
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    
    NSLog(@"%@",[table getData]);
    if (typeNum == MethodType_Controller_Privacy) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[[AccountHelper getAccount] preferences]];
        BOOL isPrivacy = YES;
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *uDict = [array objectAtIndex:i];
            if ([[uDict objectForKey:@"key"] isEqualToString:@"close_my_connection"]) {
                isPrivacy = ![[uDict objectForKey:@"value"] boolValue];
                break;
            }
        }
        if (isOn != isPrivacy) {
            [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Privacy],@"key":isOn?@"_open":@"_close"} success:^(id JSON) {
                
            } failure:^(NSError *error, id JSON) {
                
            }];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (typeNum == MethodType_Controller_Add) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)clickSend
{
    if (message.length == 0) return;
    if (typeNum == MethodType_Controller_Add) {
        self.view.userInteractionEnabled = NO;
        [LoadingView showProgress:YES inView:self.view];
        NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_Add_Friend], @"friend_id":userID,@"message":message,@"hide_friend":[NSNumber numberWithBool:isOn]};
        [ServiceManager setData:param success:^(id JSON) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.view.userInteractionEnabled = YES;
                [LoadingView showProgress:NO inView:self.view];
                [InfoAlertView showInfo:@"请求发送成功" inView:self.view duration:1];
                [self performSelector:@selector(clickCancel) withObject:nil afterDelay:1];
                if (self.updateBlock) {
                    self.updateBlock();
                }
            });
        } failure:^(NSError *error, id JSON) {
            self.view.userInteractionEnabled = YES;
            [LoadingView showProgress:NO inView:self.view];
            [InfoAlertView showInfo:@"请求发送失败" inView:self.view duration:1];
        }];
    } else {
        
    }
}

#pragma mark - UI

- (void)createUI
{
    [FontUtil setBtnTitleFontColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [FontUtil setBarFontColor:[UIColor blackColor]];
    
    [super createUI];
    
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = [ImageCenter getBundleImage:@"whiteColor_naviBar_background_top.png"];
    [naviBar setTopTitle:@""];
    
    isOn = YES;
    isChange = NO;
    
    table.enableHeader = NO;
    table.scrollEnabled = NO;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"PairDTO": [SwitchCell class],@"Pair2DTO":[TextFieldCell class]}];
}

- (void)createCancelButton
{
    UIButton *backButton = [NavigationBar createNormalButton:@"取消" target:self action:@selector(clickCancel)];
    [naviBar setLeftButton:backButton];
}

- (void)clickCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createSendButton
{
    UIButton *backButton = [NavigationBar createNormalButton:@"发送" target:self action:@selector(clickSend)];
    [naviBar setRightButton:backButton];
}

#pragma mark - data

- (void)setupData
{
    typeNum = [[_dataDict objectForKey:@"type"] integerValue];
    switch (typeNum) {
        case MethodType_Controller_Privacy:
        {
            statusBar.image = [ImageCenter getBundleCatenaImage:@"naviBar_background_top.png"];
            [naviBar changeBackGroundImage:@"NO0_naviBar_background.png"];
            [self createBackButton];
            [naviBar setTopLabelColor:[UIColor whiteColor]];
            [naviBar setTopTitle:@"隐私设置"];
            PairDTO *dto = [[PairDTO alloc] init];
            dto.label = @"共享我的好友";
            dto.value = @"取消共享后将无法查看好友的好友";
            NSMutableArray *array = [NSMutableArray arrayWithArray:[[AccountHelper getAccount] preferences]];
            BOOL isPrivacy = YES;
            for (int i = 0; i < array.count; i ++) {
                NSDictionary *uDict = [array objectAtIndex:i];
                if ([[uDict objectForKey:@"key"] isEqualToString:@"close_my_connection"]) {
                    isPrivacy = ![[uDict objectForKey:@"value"] boolValue];
                    break;
                }
            }
            dto.isOn = isPrivacy;
            isOn = isPrivacy;
            [table setSectionTitleHeight:[NSArray arrayWithObjects:[NSNumber numberWithFloat:20], nil]];
            [table setData:[NSArray arrayWithObject:[NSArray arrayWithObject:dto]]];
            break;
        }
        case MethodType_Controller_Add:
        {
            [naviBar setTopTitle:@"添加好友"];
            [self createCancelButton];
            [self createSendButton];
            //
            Pair2DTO *dto1 = [[Pair2DTO alloc] init];
            dto1.title = @"内容限14字";
            dto1.label = [NSString stringWithFormat:@"我是%@",[[AccountHelper getAccount] name]];
            message = dto1.label;
            //
            PairDTO *dto = [[PairDTO alloc] init];
            dto.label = @"设置TA为私密好友";
            dto.value = @"设置后，我的好友无法通过我看到TA";
            isOn = NO;
            dto.isOn = isOn;
            //
            [table setSectionTitleHeight:[NSArray arrayWithObjects:[NSNumber numberWithFloat:20],[NSNumber numberWithFloat:20], nil]];
            [table setData:[NSArray arrayWithObjects:[NSArray arrayWithObjects:dto1, nil],[NSArray arrayWithObjects:dto, nil], nil]];
            break;
        }
        default:
            break;
    }
    userID = [_dataDict objectForKey:@"userID"];
}

#pragma mark - click
- (void)clickCell:(id)dto action:(NSNumber *)action
{    
    isOn = [action boolValue];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    message = ((Pair2DTO *)dto).label;
}


@end
