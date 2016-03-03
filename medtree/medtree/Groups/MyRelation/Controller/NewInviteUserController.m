//
//  NewInviteUserController.m
//  medtree
//
//  Created by 陈升军 on 15/4/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewInviteUserController.h"
#import "UserDTO.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "pinyin.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "NewMateFriendCell.h"
#import "OperationHelper.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "FontUtil.h"
#import "ImageCenter.h"

@interface NewInviteUserController ()<MFMessageComposeViewControllerDelegate, UIActionSheetDelegate>
{
    NSMutableArray          *userArray;
    NSMutableArray          *phonesArray;
}
@end

@implementation NewInviteUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)createUI
{
    [super createUI];
    [FontUtil setBtnTitleFontColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [FontUtil setBarFontColor:[UIColor blackColor]];
    [naviBar setTopTitle:@"邀请好友"];
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = [ImageCenter getBundleImage:@"whiteColor_naviBar_background_top.png"];
//    [self createBackButton];
    
    
    UIButton *closeButton = [NavigationBar createNormalButton:@"关闭" target:self action:@selector(clickBack)];
    [naviBar setLeftButton:closeButton];
    
    userArray = [[NSMutableArray alloc] init];
    phonesArray = [[NSMutableArray alloc] init];
    
    table.enableHeader = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"UserDTO": [NewMateFriendCell class]}];
}

- (void)clickBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)createSectionHeaders:(NSArray *)array
{
    NSMutableArray *headers = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        UIView *view = [[UIImageView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = [[ALPHA substringFromIndex:i] substringToIndex:1];
        label.textColor = [UIColor darkGrayColor];
        label.font = [MedGlobal getTinyLittleFont];
        [view addSubview:label];
        //
        [headers addObject:view];
    }
    return headers;
}

- (NSArray *)createSectionHeights:(NSArray *)array
{
    NSMutableArray *heights = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        if ([[array objectAtIndex:i] count] > 0) {
            [heights addObject:@20];
        } else {
            [heights addObject:@0];
        }
    }
    return heights;
}

- (void)setUserList:(NSArray *)array
{
    [userArray addObjectsFromArray:array];
    
    [table setSectionHeader:[self createSectionHeaders:userArray]];
    [table setSectionTitleHeight:[self createSectionHeights:userArray]];
    //
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        [titles addObject:[ALPHA substringWithRange:NSMakeRange(i, 1)]];
    }
    [table setSectionIndexTitles:titles];

    [table setData:userArray];
}

- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_InviteFirend) {
        UserDTO *udto = (UserDTO *)dto;
        if (udto.phones.count == 0) {
            return;
        }
        if (udto.phones.count == 1) {
            [self postInvitewithPhone:[udto.phones objectAtIndex:0]];
        } else {
            NSString *phone1 = nil;
            NSString *phone2 = nil;
            NSString *phone3 = nil;
            [phonesArray removeAllObjects];
            [phonesArray addObjectsFromArray:udto.phones];
            if (udto.phones.count > 2) {
                phone1 = [udto.phones objectAtIndex:0];
                phone2 = [udto.phones objectAtIndex:1];
                phone3 = [udto.phones objectAtIndex:2];
            } else {
                phone1 = [udto.phones objectAtIndex:0];
                phone2 = [udto.phones objectAtIndex:1];
            }
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:phone1,phone2,phone3,nil];
            sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
            [sheet showInView:self.view];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < phonesArray.count) {
        [self postInvitewithPhone:[phonesArray objectAtIndex:buttonIndex]];
    }
}

- (void)postInvitewithPhone:(NSString *)phone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendSMS:[NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址 https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] recipientList:[NSArray arrayWithObjects:phone, nil]];
    });
}

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
