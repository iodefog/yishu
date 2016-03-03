//
//  SettingController.m
//  medtree
//
//  Created by sam on 8/8/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "SettingController.h"
#import "PairCell.h"
#import "PairDTO.h"
#import "AccountHelper.h"
#import "LocalFileController.h"
#import "SettingHeaderView.h"
#import "HelpView.h"
#import "CommonManager.h"
#import "OpenUDID.h"
#import "FeedbackController.h"
#import "FriendRequestController.h"
#import "NewSettingCell.h"
#import "NewForgetPasswordController.h"
#import "UserDTO.h"
#import "InfoAlertView.h"
#import "SDImageCache.h"
#import "MBProgressHUD.h"
#import "MedGlobal.h"
#import "IMUtil.h"
#import "StatisticHelper.h"
#import "RootViewController.h"
#import "SettingNotifcationViewController.H"


#define kSettingControllerClearCacheActionSheetTag 1003

@interface SettingController () <HelpViewDelegate>
{
    NSMutableArray *cellNames;
    NSArray *classNames;
    
    SettingHeaderView   *headerView;
    HelpView            *helpView;
    
    NSString            *downloadLink;
    BOOL                clickVersion;
    BOOL                inHouse;
    
    BOOL                changeEngine;
}

@property (nonatomic, strong)MBProgressHUD *HUD;
@property (nonatomic, strong)UIActionSheet *clearCacheActionSheet;
@property (nonatomic, assign) BOOL showHelpView;

@end

@implementation SettingController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)createTableHeader
{
    headerView = [[SettingHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    [table setTableHeaderView:headerView];
}

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    [self createTableHeader];
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCell:[NewSettingCell class]];
    table.enableHeader = NO;
    
    inHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];

    NSString *networkStr = @"";
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue]) {
        networkStr = @"测试网络";
    } else {
        networkStr = @"线上网络";
    }
    NSString *changeNetStr = [NSString stringWithFormat:@"切换网络(%@)", networkStr];
    
    if (inHouse) {
          cellNames = [NSMutableArray arrayWithObjects: @"用户协议",@"隐私策略",@"新消息通知",@"修改密码",@"清理缓存",@"意见反馈",changeNetStr,@"版本更新",@"给予评价",@"欢迎页",@"退出登录", nil];
    } else {
          cellNames = [NSMutableArray arrayWithObjects: @"用户协议",@"隐私策略",@"新消息通知",@"修改密码",@"清理缓存",@"意见反馈",@"给予评价",@"欢迎页",@"退出登录", nil];
    }
    
    [self getDataFromLocal];
    
    self.showHelpView = NO;
}

- (void)setIsShowHelp:(BOOL)isShow
{
//    helpView.hidden = !isShow;
    if (isShow) {
        self.showHelpView = YES;
        [helpView showHelp];
        [UIView animateWithDuration:0.5 animations:^{
            helpView.alpha = 1;
        }];
        [self.view bringSubviewToFront:helpView];
    } else {
        self.showHelpView = NO;
        [UIView animateWithDuration:0.5 animations:^{
           helpView.alpha = 0;
        }];
    }
}

- (void)createHelpView
{
    if (helpView == nil) {
        helpView = [[HelpView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        helpView.parent = self;
        helpView.alpha = 0;
        [self.view addSubview:helpView];
    }
    [self setIsShowHelp:YES];
}

- (void)createNaviBar
{
    [super createNaviBar];
    [naviBar setTopTitle:@"设置"];
}

- (void)getRevisionUpdate
{
    NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
    [self getRevisionUpdateInfo:^(id JSON) {
        if (JSON != nil) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:JSON];
            NSInteger num = [[dict objectForKey:@"revision"] integerValue];
            if (num > revision) {
                PairDTO *dto = [[[table getData] objectAtIndex:0] objectAtIndex:4];
                dto.isShowRoundView = ![[dict objectForKey:@"isUpdate"] boolValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [table reloadData];
                });
            }
        }
    }];
}

- (void)getRevisionUpdateInfo:(SuccessBlock)success
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_CommonInfo_Degree],@"key":@"revisionUpdate"} success:^(id JSON) {
        NSArray *array = [NSArray arrayWithArray:JSON];
        if (array.count > 0) {
            NSMutableDictionary *inviteDict = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:0]];
            success (inviteDict);
        } else {
            success (nil);
        }
    } failure:^(NSError *error, id JSON) {
        success (nil);
    }];
}

- (void)getDataFromLocal
{
    
    NSMutableArray *allArray = [NSMutableArray array];
    for (int i=0; i<cellNames.count; i++) {
       
        PairDTO *dto = [[PairDTO alloc] init];
        NSString *cell = [cellNames objectAtIndex:i];
        dto.label = cell;
        
        if (i == 0 || i == 1 || i == 2 || i == 3) {
            dto.accessType = 1;
        }

        if (i == cellNames.count - 1) {
           dto.cellType = 1;
        }
        
        [allArray addObject:dto];
    }
    [table setData:[NSMutableArray arrayWithObjects:allArray, nil]];
    if (inHouse) {
        [self getRevisionUpdate];
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    //公用
    switch (index.row) {
        case 0: {
            //用户协议
            LocalFileController *rules = [[LocalFileController alloc] init];
            [self.navigationController pushViewController:rules animated:YES];
             break;
        }
        case 1: {
            //隐私策略
            [self friendRequest];
            break;
        }
        case 2: {
            //新消息通知
            [self newMsgNotice];
            break;
        }
        case 3: {
            //修改密码
            NewForgetPasswordController *modifPass = [[NewForgetPasswordController alloc] init];
            [self.navigationController pushViewController:modifPass animated:YES];
            [modifPass setNaviTitle:@"修改密码"];
            break;
        }
        case 4: {
            //清理缓存
            [self.clearCacheActionSheet showInView:self.view];
            break;
        }
    }
    //企业版
    if (inHouse) {
        switch (index.row) {
            case 5:{
                FeedbackController *feedBack = [[FeedbackController alloc] init];
                [self presentViewController:feedBack animated:YES completion:^{
                    
                }];
                break;
            }
            case 6: {
                [self changeNetworkHost:5];
                break;
            }
            case 7: {
                //版本更新
                [self checkVersion];
                break;
            }
            case 8: {
               // 给与评价
                [self goAppstore];
                break;
            }
            case 9: {
                //欢迎页
                [self createHelpView];
                break;
            }
            case 10: {
                //退出登录
                [self showSheet];
                break;
            }
            default:
                break;
        }


    } else { //appstore版本
        switch (index.row) {
            case 5:{
                FeedbackController *feedBack = [[FeedbackController alloc] init];
                [self presentViewController:feedBack animated:YES completion:^{
                    
                }];
                break;
            }
            case 6: {
                // 给与评价
                [self goAppstore];
                break;
            }
            case 7: {
                //欢迎页
                [self createHelpView];
                break;
            }
            case 8: {
                //退出登录
                [self showSheet];
                break;
            }
            default:
                break;
        }
    }
}

- (void)friendRequest
{
    FriendRequestController *set = [[FriendRequestController alloc] init];
    set.dataDict = @{@"type":[NSNumber numberWithInteger:MethodType_Controller_Privacy],@"userID":@""};
    [self.navigationController pushViewController:set animated:YES];
}

/** 新消息通知 */
- (void)newMsgNotice
{
    SettingNotifcationViewController *vc = [[SettingNotifcationViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goFeedback
{
    FeedbackController *feedback = [[FeedbackController alloc] init];
    [self presentViewController:feedback animated:YES completion:nil];
}

- (void)goAppstore
{
    //跳转Appstore 打分
    NSString *appID = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"AppID"];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSString *path;
    if (version >= 7.0) {
        path = @"itms-apps://itunes.apple.com/app/id";
    } else {
        path = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=";
    }
    NSString *appURL = [NSString stringWithFormat:@"%@%@", path, appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
}

- (void)clickBack
{
    if (self.showHelpView) {
        [self setIsShowHelp:NO];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 更换网络
- (void)changeNetworkHost:(int)index
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL networkStats = [[defaults objectForKey:TESTENVIRONMENT] boolValue];
    networkStats = !networkStats;
    [defaults setObject:@(networkStats) forKey:TESTENVIRONMENT];
    [defaults synchronize];
    changeEngine = true;
    [self clickLogout];
}

- (void)checkVersion
{
    clickVersion = YES;
    //
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSInteger revision = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"revision"] integerValue];
    NSDictionary *param = @{
                            @"os": @"ios",
                            @"version": version,
                            @"revision": [NSString stringWithFormat:@"%@", @(revision)],
                            @"channel": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"channel"],
                            @"device": [OpenUDID value],
                            @"package": @"medtree",
                            };
    [CommonManager checkUpdate:param success:^(id JSON) {
        NSDictionary *info = (NSDictionary *)JSON;
        NSInteger revision2 = [[info objectForKey:@"revision"] integerValue];
        BOOL breaking_change = [[info objectForKey:@"breaking_change"] boolValue];
        NSString *version2 = [info objectForKey:@"version"];
        downloadLink = [info objectForKey:@"download_link"];
        //
        if (revision2 > revision) {
            if (breaking_change) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"请更新最新版本%@！", version2] delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil];
                alert.tag = 1002;
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"有更新版本%@，是否更新？", version2] delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"更新", nil];
                alert.tag = 1001;
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"当前版本%@ 已是最新版本！", version] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alert.tag = 1000;
            [alert show];
        }
        clickVersion = NO;
    } failure:^(NSError *error, id JSON) {
        clickVersion = NO;
    }];
}

- (void)showSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"退出后不会删除历史数据，下次登录依然可以使用本账号。"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"退出登录"
                                              otherButtonTitles:nil, nil];
    sheet.tag = 1004;
    [sheet showInView:self.view];
}

- (void)clickLogout
{
    [[RootViewController shareRootViewController] logout];
    
    if (changeEngine) {
        [AccountHelper tryToChangeEngineSuccess:^(id JSON) {
            changeEngine = false;
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == kSettingControllerClearCacheActionSheetTag) {
        if (buttonIndex == 0) {
            [self clearCache];
        }
    } else if (actionSheet.tag == 1004) {
        if (buttonIndex == 0) {
            [self clickLogout];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            // update
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadLink]];
        } else if (buttonIndex == 0) {

        }
    } else if (alertView.tag == 1002) {
        if (buttonIndex == 0) {
            // update
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadLink]];
        }
    }
}

- (void)clearCache
{
    [self.HUD show:YES];
    [[SDImageCache sharedImageCache] cleanDiskWithCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.HUD.labelText = @"缓存已清除";
            [self.HUD hide:YES];
            self.HUD = nil;
        });
    }];
}

- (MBProgressHUD *)HUD
{
    if (!_HUD) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.removeFromSuperViewOnHide = YES;
        HUD.labelText = @"正在清理缓存";
        [self.view addSubview:HUD];

        _HUD = HUD;
    }
    return _HUD;
}

- (UIActionSheet *)clearCacheActionSheet
{
    if (!_clearCacheActionSheet) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
        actionSheet.tag = kSettingControllerClearCacheActionSheetTag;
        _clearCacheActionSheet = actionSheet;
    }
    return _clearCacheActionSheet;
}

@end
