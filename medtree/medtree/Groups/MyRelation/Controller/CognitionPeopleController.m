//
//  CognitionPeopleController.m
//  medtree
//
//  Created by 陈升军 on 15/3/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CognitionPeopleController.h"
#import "NewMateFriendCell.h"
#import "ServiceManager.h"
#import "UserDTO.h"
#import "OperationHelper.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "NewPersonDetailController.h"
#import "MateUserTableController.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "FriendRequestController.h"
#import "CognitionPeopleCell.h"
#import "MayKnowPeopleCell.h"
#import <JSONKit.h>
#import "UIColor+Colors.h"
#import "AddDegreeController.h"

@interface CognitionPeopleController ()<MFMessageComposeViewControllerDelegate, BaseTableViewDelegate>

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UIButton *inviteButton;

@end

@implementation CognitionPeopleController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startIndex = 0;
    self.pageSize = 10;
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self triggerPullToRefresh];
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"可能认识的人"];
    [self createBackButton];
    
    table.deleteButtonTitle = @"忽略";
    table.backgroundColor = [UIColor clearColor];
    [table setRegisterCells:@{ @"UserDTO" : [MayKnowPeopleCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadFooter:(BaseTableView *)table1
{
    [self getSuggest];
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getSuggest];
}

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)deleteData:(UserDTO *)dto
{
    NSDictionary *params = @{ @"method" : @(MethodType_UserInfo_IgnoreUser), @"user_id" : dto.userID};
    [ServiceManager setData:params success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
    person.userDTO = (UserDTO *)dto;
    person.parent = self;
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_InviteFirend) {
        [self postInvitewithPhone:@""];
    } else if ([action integerValue] == ClickAction_MateUser) {
        MateUserTableController *user = [[MateUserTableController alloc] init];
        [self.navigationController pushViewController:user animated:YES];
        [user setUserInfo:dto];
    } else if ([action integerValue] == ClickAction_FirendAdd) {        
        FriendRequestController *request = [[FriendRequestController alloc] init];
        request.dataDict = @{@"type":[NSNumber numberWithInt:MethodType_Controller_Add],@"userID":((UserDTO *)dto).userID};
        request.updateBlock = ^ {
            if (self.updateBlock) {
                self.updateBlock(index.row);
            }
        };
        [self presentViewController:request animated:YES completion:^{
            
        }];
    }
}

#pragma mark -
#pragma mark - network -

- (void)getSuggest
{
    NSDictionary *params = @{ @"method" : @(MethodType_DegreeInfo_Suggest),
                              @"from" : @(self.startIndex),
                              @"size": @(self.pageSize) };
    
    [ServiceManager getData:params success:^(id JSON) {
        [self stopLoading];
        NSMutableArray *array = [NSMutableArray arrayWithArray:JSON];
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
        }
        
        [self.dataArray addObjectsFromArray:array];
        self.startIndex += array.count;
        [table setData:@[ self.dataArray ]];
        self.enableFooter = (array.count == self.pageSize);
        
        if (self.dataArray.count == 0) {
            [self.view addSubview:self.emptyView];
            [self.emptyView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.centerX);
                make.centerY.equalTo(self.view.centerY).offset(-60);
            }];
            
            [self.view addSubview:self.inviteButton];
            [self.inviteButton makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view.centerX);
                make.top.equalTo(self.emptyView.bottom).offset(30);
                make.width.equalTo(@100);
            }];
        } else {
            [self.emptyView removeFromSuperview];
            [self.inviteButton removeFromSuperview];
        }
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)postInvitewithPhone:(NSString *)phone
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendSMS:[NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址  https://medtree.cn/release/?package=medtree",[[AccountHelper getAccount] userID]] recipientList:[NSArray arrayWithObjects:phone, nil]];
    });
}

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
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

#pragma mark -
#pragma mark - response event -

- (void)inviteButtonAction:(UIButton *)button
{
    AddDegreeController *degree = [[AddDegreeController alloc] init];
    [self.navigationController pushViewController:degree animated:YES];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"relation_may_know_people_empty.png");
            imageView;
        });
    }
    return _emptyView;
}

- (UIButton *)inviteButton
{
    if (!_inviteButton) {
        _inviteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"邀请好友" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorFromHexString:@"#777777"] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.cornerRadius = 8;
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(inviteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _inviteButton;
}

@end
