//
//  AddDegreeController.m
//  medtree
//
//  Created by 无忧 on 14-10-10.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "AddDegreeController.h"
#import "ImageTextFieldView.h"
#import "ColorUtil.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "ImagePairView.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "LoadingView.h"
#import "AccountHelper.h"
#import "FileUtil.h"
#import "ImageCenter.h"
#import "NearPeopleController.h"
#import "PersonQRCardController.h"
#import "QRCardController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "NewPersonDetailController.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "MateFriendsController.h"
#import "NewPersonEditViewController.h"
#import "MedGlobal.h"
#import "HomePageCommonCell.h"
#import "PairDTO.h"
#import "MedShareManager.h"

@interface AddDegreeController () <ZXingQRCardDelegate, MFMessageComposeViewControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate,UISearchBarDelegate>
{
    ImageTextFieldView        *phoneOrEmailField;
    UILabel                   *myMedtreeNum;
    
    ImagePairView             *imageTextView1;
    UILabel                   *title1;
    ImagePairView             *imageTextView2;
    UILabel                   *title2;
    ImagePairView             *imageTextView3;
    ImagePairView             *imageTextView4;
    ImagePairView             *imageTextView5;
//    ZXingQRCard               *readerView;
    UIScrollView              *scroll;
    UISearchBar               *searchView;
    UILabel                   *line;
    
}

@end

@implementation AddDegreeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}

- (void)createUI
{
    [super createUI];

    [naviBar setTopTitle:@"拓展人脉"];
    
    [self createBackButton];
    [self createSearchBar];
    [self setTable];
}

- (void)createSearchBar
{
    searchView = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchView.autocorrectionType        = UITextAutocorrectionTypeNo;
    searchView.placeholder               = @"搜索TA的手机号/医树号";
    searchView.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    searchView.delegate                  = self;
    searchView.backgroundColor           = [UIColor clearColor];
    searchView.alpha                     = 1;
    searchView.userInteractionEnabled    = YES;
    searchView.autoresizesSubviews       = YES;
    searchView.showsCancelButton         = NO;
    searchView.backgroundColor = [ColorUtil getColor:@"E7E8EA" alpha:1];
    line = [[UILabel alloc] init];
    line.backgroundColor = [ColorUtil getColor:@"DADADD" alpha:1];
    [searchView addSubview:line];
    
    [self.view addSubview:searchView];
    for (UIView *view in searchView.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

- (void)setTable
{
    table.enableHeader = NO;
    table.enableFooter = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"PairDTO": [HomePageCommonCell class]}];
    
    [self loadCellData];
}

- (void)loadCellData
{
    NSMutableArray *cells = [NSMutableArray array];
    NSArray *title = [NSArray arrayWithObjects:@"邀请好友", @"发现医学好友", @"雷达加好友", @"扫描二维码", nil];
    
    NSArray *images = [NSArray arrayWithObjects:@"home_find_yaoqing.png", @"home_relation_address.png", @"home_find_leida.png", @"home_find_saomiao.png", nil];
    
    for (int i = 0; i < title.count; i ++) {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = [title objectAtIndex:i];
        dto.imageName = [images objectAtIndex:i];
        [cells addObject:dto];
    }
    [table setData:[NSArray arrayWithObjects:cells, nil]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [ClickUtil event:@"contacts_expandContacts_search_view" attributes:nil];
    
    if (searchBar.text.length > 0) {
        [self becomeFirstResponder];
        [self searchUserInfo:searchBar.text];
    } else {
        [InfoAlertView showInfo:@"请填写查找条件" inView:self.view duration:1];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGSize size = self.view.frame.size;
    CGFloat searchBarH = 30;
    searchView.frame = CGRectMake(0, [self getOffset]+44, size.width, searchBarH+10);
    line.frame = CGRectMake(0, CGRectGetHeight(searchView.frame)-0.5, size.width, 0.5);
    table.frame = CGRectMake(0, CGRectGetMaxY(searchView.frame), size.width, size.height-[self getOffset]-44-searchBarH-10);
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if (index.row == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"邀请好友" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机通讯录邀请", @"其他邀请", nil];
        sheet.tag = 10012;
        [sheet showInView:self.view];
        
        [ClickUtil event:@"contacts_expandContacts_invitefriend_view" attributes:nil];
    } else if (index.row == 1) {
        MateFriendsController *phone = [[MateFriendsController alloc] init];
        phone.isDismiss = NO;
        [self.navigationController pushViewController:phone animated:YES];
        
        [ClickUtil event:@"contacts_expandContacts_findmedfriend_view" attributes:nil];
    } else if (index.row == 2) {
        NearPeopleController *near = [[NearPeopleController alloc] init];
        [self.navigationController pushViewController:near animated:YES];
        
        [ClickUtil event:@"contacts_expandContacts_radaradd_view" attributes:nil];
    } else if (index.row == 3) {
        QRCardController *card = [[QRCardController alloc] init];
        [self presentViewController:card animated:YES completion:nil];
        card.parent = self;
        [card startQRCard];
        
        [ClickUtil event:@"contacts_expandContacts_scan2Dbarcode_view" attributes:nil];
    }
}

- (void)showMyQRCard
{
    PersonQRCardController *card = [[PersonQRCardController alloc] init];
    [self.navigationController pushViewController:card animated:YES];
}

- (void)hiddenZXingQRCard
{
    
}

- (void)showInfoAlert:(NSString *)info
{
    [InfoAlertView showInfo:info inView:self.view duration:1];
}

- (void)setQRCode:(NSString *)code
{
    [self checkCardInfo:code];
}

- (void)checkCardInfo:(NSString *)cardInfo
{
    if (cardInfo.length > 0) {
        
    } else {
        return;
    }
    if ([cardInfo rangeOfString:@"https://medtree.cn/release/?package=medtree&uid="].location !=NSNotFound) {
        NSArray *array = [cardInfo componentsSeparatedByString:@"&"];
        NSString *userID = [array objectAtIndex:1];
        userID = [userID stringByReplacingOccurrencesOfString:@"uid=" withString:@""];
        [self searchUserInfo:userID];
    } else {
        [InfoAlertView showInfo:@"不是本系统所用二维码" inView:self.view duration:1];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cardInfo]];
    }
}

- (void)textFieldBecomeFirstResponderWithTag:(NSInteger)tag
{
    
}

- (void)searchUserInfo:(NSString *)userID
{
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_Search],@"userInfo":userID} success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        NSDictionary *dict = [JSON objectForKey:@"result"];
        if (dict == nil) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            UserDTO *dto = [[UserDTO alloc] init:JSON];
            NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
            [self.navigationController pushViewController:detail animated:YES];
            detail.userDTO = dto;
            detail.parent = self;
        }
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
//        [self showErrorAlert:JSON];
        [InfoAlertView showInfo:@"未找到账号信息" inView:self.view duration:1];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 10012) {
        NSString *message = [NSString stringWithFormat:@"我正在用医树，既可以做职业发展还可以管理自己的人脉，你也试试。注册时请在邀请人处填写我的医树号:%@，我们就能加为好友了。下载地址 https://m.medtree.cn/user/register?uid=%@", [[AccountHelper getAccount] userID], [[AccountHelper getAccount] userID]];
        if (buttonIndex == 1) {
            [[MedShareManager sharedInstance] showInView:self.view text:message];
        } else if (buttonIndex == 0) {            
            [self sendSMS:message recipientList:@[]];
        }
    }
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
