//
//  AddressBookController.m
//  medtree
//
//  Created by sam on 9/25/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "AddressBookController.h"
#import "AddressBookCell.h"
#import "ContactUtil.h"
#import "ContactInfo.h"
#import "LoadingView.h"
#import "UserDTO.h"
#import "MedGlobal.h"
#import "ColorUtil.h"
#import "InfoAlertView.h"
#import "AccountHelper.h"
#import "OperationHelper.h"
#import <MessageUI/MFMessageComposeViewController.h>

@interface AddressBookController () <UIActionSheetDelegate, MFMessageComposeViewControllerDelegate>

@end

@implementation AddressBookController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"通讯录"];
    [self createBackButton];
    //
    phonesArray = [[NSMutableArray alloc] init];
    sectionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < ALPHA.length; i++) {
        [sectionArray addObject:[NSMutableArray array]];
    }
    //
    table.enableHeader = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCell:[AddressBookCell class]];
}

- (void)loadData
{
    [self getContactInfo];
}

- (void)getContactInfo
{
    if (ABAddressBookRequestAccessWithCompletion) {
        // on iOS 6
        CFErrorRef err;
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            // ABAddressBook doesn't gaurantee execution of this block on main thread, but we want our callbacks to be
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"没有权限访问通讯录！\n\n如果需要打开通讯录权限，请点击：设置->通用->还原->还原位置与隐私" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    [alert show];
                });
            } else {
                [self getAllContacts];
            }
        });
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getAllContacts];
        });
    }
}

- (void)getAllContacts
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [LoadingView showProgress:YES inView:self.view];
    });
    //
    [ContactUtil getAllContacts:YES process:^(id info, NSInteger idx, NSInteger total) {
        ContactInfo *ci = (ContactInfo *)info;
        for (int i=0; i<ci.phones.count; i++) {
            NSString *phone = [ci.phones objectAtIndex:i];
            [ci.phones replaceObjectAtIndex:i withObject:[ContactUtil formatPhone:phone]];
        }
        [ContactUtil addContact:ci sectionArray:sectionArray];
        contactCount++;
        dispatch_async(dispatch_get_main_queue(), ^{

        });
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self putToTable];
    });
}

- (void)putToTable
{
    for (int i=0; i<sectionArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        NSArray *array2 = [sectionArray objectAtIndex:i];
        for (int j=0; j<array2.count; j++) {
            ContactInfo *ci = (ContactInfo *)[array2 objectAtIndex:j];
            [array addObject:[self convertUser:ci]];
        }
        [sectionArray replaceObjectAtIndex:i withObject:array];
    }
    [LoadingView showProgress:NO inView:self.view];
    //
    [[self getTable] setSectionHeader:[self createSectionHeaders:sectionArray]];
    [[self getTable] setSectionTitleHeight:[self createSectionHeights:sectionArray]];
    //
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        [titles addObject:[ALPHA substringWithRange:NSMakeRange(i, 1)]];
    }
    [[self getTable] setSectionIndexTitles:titles];
    //
    [[self getTable] setData:sectionArray];
}

- (BaseTableView *)getTable
{
    return table;
}

- (UserDTO *)convertUser:(ContactInfo *)ci
{
    UserDTO *dto = [[UserDTO alloc] init];
    dto.name = ci.name;
    NSDictionary *dict = @{@"name": ci.name, @"phones": ci.phones};
    [dto parse2:dict];
    //
    NSMutableString *phones = [NSMutableString string];
    for (int i=0; i<ci.phones.count; i++) {
        [phones appendString:[ci.phones objectAtIndex:i]];
        [phones appendString:@" "];
    }
    //
    dto.desc = phones;
    dto.extendData = ci;
    return dto;
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
