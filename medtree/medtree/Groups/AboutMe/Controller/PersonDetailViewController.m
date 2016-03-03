//
//  PersonDetailViewController.m
//  medtree
//
//  Created by 边大朋 on 15/12/2.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "PersonDetailViewController.h"
#import "UserDTO.h"
#import "PairDTO.h"
#import "Pair2DTO.h"
#import "BlankCell.h"
#import "NewPersonEditCell.h"
#import "PersonCardInfoCell.h"
#import "ServiceManager.h"
#import "OrganizationDTO.h"
#import "NewCommonPersonCell.h"
#import "NewCommonFriendController.h"
#import "AccountHelper.h"
#import "FooterBar.h"
#import "NewPersonEditViewController.h"
#import "PersonCardInfoDetailCell.h"

@interface PersonDetailViewController ()
{
    NSMutableArray *userInfoArray;
    BOOL isOn;
    BOOL isSelf;
    FooterBar *footerBarView;
}
@end

@implementation PersonDetailViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    userInfoArray = [[NSMutableArray alloc] init];
    [self setupData];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFromNet) name:UserInfoChangeNotification object:nil];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    [naviBar setTopTitle:@"详细资料"];
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table setIsNeedFootView:NO];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCells:@{@"PairDTO":[NewPersonEditCell class],@"Pair2DTO":[BlankCell class],@"UserDTO":[PersonCardInfoDetailCell class],@"OrganizationDTO":[NewCommonPersonCell class]}];
}

- (void)setupFootView
{
    if (isSelf) {
        footerBarView = [[FooterBar alloc] init];
        [self.view addSubview:footerBarView];
        CGSize size = self.view.frame.size;
        footerBarView.frame = CGRectMake(0, size.height - 44, size.width, 44);
        table.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame) - 44);
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:@{@"imageName":@"footer_bar_edit_icon.png", @"title":@"编辑", @"target":self, @"action":@"clickToPersonEditViewController"}];
        [footerBarView setButtonInfo:array];
    }
}

#pragma mark - data handle
- (void)setupData
{
    if (self.udto) {
        self.userID = self.udto.userID;
        [self isSelf];
        [self getDataFromLocal];
    }
    [self getDataFromNet];
}

- (void)getDataFromNet
{
    [ServiceManager getData:[self getParam_FromNet] success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.udto = (UserDTO *)JSON;
            self.userID = self.udto.userID;
            [self isSelf];
            [self getDataFromLocal];
        });
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (NSDictionary *)getParam_FromNet
{
    return @{@"userid": self.userID,@"method": [NSNumber numberWithInteger:MethodType_UserInfo]};
}

- (void)getDataFromLocal
{
    [userInfoArray removeAllObjects];
    {
        [userInfoArray addObject:self.udto];
    }
    if (self.udto.common_friends_count > 0) {
        {
            Pair2DTO *dto2 = [[Pair2DTO alloc] init];
            dto2.title = @"共同好友";
            [userInfoArray addObject:dto2];
        }
        
        PairDTO *dto2 = [[PairDTO alloc] init];
        dto2.key = @"共同好友";
        dto2.cellType = 10;
        dto2.value = [NSString stringWithFormat:@"%zi人",self.udto.common_friends_count];
        [userInfoArray addObject:dto2];
    }
    {
        //工作经历
        NSInteger experienceCount = self.udto.experienceArray.count;
        if (experienceCount > 0) {
            {
                Pair2DTO *dto2 = [[Pair2DTO alloc] init];
                dto2.title = @"工作经历";
                [userInfoArray addObject:dto2];
            }
            for (NSInteger i = 0; i < experienceCount; i++) {
                NSDictionary *dict = [self.udto.experienceArray objectAtIndex:i];
                OrganizationDTO *dto = [[OrganizationDTO alloc] init:@{}];
                dto.key = [dict objectForKey:@"organization"];
                NSArray *departmentArray = [dict objectForKey:@"departments"];
                if (departmentArray.count > 0) {
                    dto.value = [[departmentArray lastObject] objectForKey:@"department"];
                }
                
                dto.value2 = [dict objectForKey:@"title"];
                dto.value3 = [dict objectForKey:@"organization_id"];
                dto.startDate = [dict objectForKey:@"start_time"];
                dto.endDate = [dict objectForKey:@"end_time"];
                dto.cellType = 0;
                if (i == experienceCount - 1) {
                    dto.isLastCell = YES;
                }
                [userInfoArray addObject:dto];
            }
        }
    }
    {
        NSInteger educationCount = self.udto.educationArray.count;
        if (educationCount > 0) {
            {
                Pair2DTO *dto2 = [[Pair2DTO alloc] init];
                dto2.title = @"教育经历";
                [userInfoArray addObject:dto2];
            }
            for (NSInteger i = 0; i < educationCount ; i++) {
                NSDictionary *dict = [self.udto.educationArray objectAtIndex:i];
                OrganizationDTO *dto = [[OrganizationDTO alloc] init:@{}];
                dto.key = [self checkIsNull:[dict objectForKey:@"organization"]];
                NSArray *departmentArray = [dict objectForKey:@"departments"];
                if (departmentArray.count > 0) {
                    dto.value = [[departmentArray lastObject] objectForKey:@"department"];
                }
                
                dto.value2 = [self checkIsNull:[dict objectForKey:@"title"]];
                dto.value3 = [dict objectForKey:@"organization_id"];
                dto.startDate = [dict objectForKey:@"start_time"];
                dto.endDate = [dict objectForKey:@"end_time"];
                dto.cellType = 0;
                if (i == educationCount - 1) {
                    dto.isLastCell = YES;
                }
                [userInfoArray addObject:dto];
            }
        }
    }
    {
        Pair2DTO *dto2 = [[Pair2DTO alloc] init];
        dto2.title = @"其他信息";
        [userInfoArray addObject:dto2];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"兴趣爱好";
        dto.value = self.udto.interest.length > 0 ? self.udto.interest : @"未填写";
        dto.cellType = 2;
        dto.accessType = 1;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"医树号";
        dto.value = self.udto.userID;
        dto.cellType = 3;
        dto.accessType = 1;
        [userInfoArray addObject:dto];
    }
    {
        PairDTO *dto = [[PairDTO alloc] init:@{}];
        dto.key = @"注册日期";
        dto.value = self.udto.regtime;
        dto.cellType = 3;
        dto.accessType = 1;
        [userInfoArray addObject:dto];
    }
    if (self.udto.isFriend) {
        OrganizationDTO *dto = [[OrganizationDTO alloc] init:@{}];
        dto.key = @"设置TA为私密好友";
        dto.cellType = 4;
        NSMutableArray *array = [NSMutableArray arrayWithArray:[self.udto preferences]];
        BOOL isPrivacy = NO;
        for (int i = 0; i < array.count; i ++) {
            NSDictionary *uDict = [array objectAtIndex:i];
            if ([[uDict objectForKey:@"key"] isEqualToString:@"hide_friend"]) {
                isPrivacy = [[uDict objectForKey:@"value"] boolValue];
                break;
            }
        }
        dto.isOn = isPrivacy;
        isOn = isPrivacy;
        [userInfoArray addObject:dto];

    }
    [table setData:[NSArray arrayWithObjects:userInfoArray, nil]];
    [self setupFootView];
}

- (NSString *)checkIsNull:(id)sender
{
    if ((NSObject *)sender == [NSNull null]) {
        return @"未填写";
    } else {
        return sender;
    }
}

- (void)isSelf
{
    isSelf = [AccountHelper getAccount].userID == self.userID ? YES : NO;
}

#pragma mark - cell delegate
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    switch (index.row) {
        case 2:
        {
            NewCommonFriendController *ncf = [[NewCommonFriendController alloc] init];
            [self.navigationController pushViewController:ncf animated:YES];
            [ncf loadInfo:self.userID];
            break;
        }
        
    }
}

#pragma mark 进入编辑页
- (void)clickToPersonEditViewController
{
    NewPersonEditViewController *person = [[NewPersonEditViewController alloc] init];
    [self.navigationController pushViewController:person animated:YES];
    person.parent = self;
    if ([AccountHelper getAccount] != nil) {
        [person setInfo:[AccountHelper getAccount]];
    }
    
}

// 设置隐私处理
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (isSelf) {
        return;
    }
    //隐私时 在此处进行数据上传
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.udto preferences]];
    BOOL isPrivacy = NO;
    for (int i = 0; i < array.count; i ++) {
        NSDictionary *uDict = [array objectAtIndex:i];
        if ([[uDict objectForKey:@"key"] isEqualToString:@"hide_friend"]) {
            isPrivacy = [[uDict objectForKey:@"value"] boolValue];
            break;
        }
    }
    if (isOn != isPrivacy) {
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_FriendsPrivacy],@"key":isOn?@"_hide":@"_show",@"user":self.udto,@"friends_id":self.udto.userID} success:^(id JSON) {
    
        } failure:^(NSError *error, id JSON) {
            
        }];
    }
}

@end

