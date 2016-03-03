//
//  AboutMeViewController.m
//  medtree
//
//  Created by tangshimi on 6/2/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "AboutMeViewController.h"
#import "PairDTO.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "NewPersonIdentificationController.h"
#import "FriendFeedViewController.h"
#import "PersonQRCardController.h"
#import "MyIntegralViewController.h"
#import "SettingController.h"
#import "NewPersonEditViewController.h"
#import "UserManager.h"
#import "AboutMeHeaderView.h"
#import "AboutMeTableViewCell.h"
#import "RootViewController.h"
#import "NewPersonDetailController.h"
#import "MyCareerViewController.h"

#define HideSelf [[RootViewController shareRootViewController] hideLeftSideMenuViewController];

static NSString *const tableViewCellIdentifier = @"tableViewCellIdentifier";

@interface AboutMeViewController () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AboutMeHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.headerView];
    
    self.headerView.frame = CGRectMake(0, 0, 273, 150);
    self.tableView.frame = CGRectMake(0, 150, 273, CGRectGetHeight(self.view.frame));
    
    [self loadTableViewData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userChangedAction:)
                                                 name:UserInfoChangeNotification
                                               object:nil];
}

#pragma mark -
#pragma mark - loadData -

- (void)loadTableViewData
{
    self.dataArray = [NSMutableArray new];
    NSArray *celTitleArray = @[ @"编辑资料", @"身份认证", @"我的积分",@"我的职场", @"设置" ];
    NSArray *cellImageArray = @[ @"my_edit_info.png",
                                 @"my_identification.png",
                                 @"my_integral.png",
                                 @"icon_career.png",
                                 @"my_setting.png" ];

    UserDTO *userDTO = [AccountHelper getAccount];
    
    for (NSUInteger i = 0; i < celTitleArray.count; i ++) {
        PairDTO *dto = [[PairDTO alloc] init:nil];
        dto.key = celTitleArray[i];
        if (i == 1) { //身份认证
            if (userDTO.is_certificated) {
                dto.value = @"已认证";
            } else {
                dto.value = @"立即认证";
            }
        }
        dto.imageName = cellImageArray[i];
        [self.dataArray addObject:dto];
    }
    
    [self.tableView reloadData];

}
#pragma mark -
#pragma mark - UITableViewDeleage and UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutMeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier
                                                                 forIndexPath:indexPath];
    [cell setInfo:self.dataArray[indexPath.row] indexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HideSelf
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        NewPersonEditViewController *person = [[NewPersonEditViewController alloc] init];
        [self.navigationController pushViewController:person animated:YES];
        person.parent = self;
        if ([AccountHelper getAccount] != nil) {
            [person setInfo:[AccountHelper getAccount]];
        }
    } else if (indexPath.row == 1) {
        NewPersonIdentificationController *identification = [[NewPersonIdentificationController alloc] init];
        [self.navigationController pushViewController:identification animated:YES];
    } else if (indexPath.row == 2) {
        MyIntegralViewController *integral = [[MyIntegralViewController alloc] init];
        [self.navigationController pushViewController:integral animated:YES];
    }else if (indexPath.row == 3) {
        MyCareerViewController *career = [[MyCareerViewController alloc] init];
        [self.navigationController pushViewController:career animated:YES];
    } else if (indexPath.row == 4) {        
        SettingController *sc = [[SettingController alloc] init];
        [self.navigationController pushViewController:sc animated:YES];
    }
}

#pragma mark -
#pragma mark - response event -

- (void)userChangedAction:(NSNotification *)notification
{
    NSDictionary *params = @{@"method" : @(MethodType_UserInfo), @"userid" : [[AccountHelper getAccount] userID]};
    [ServiceManager getData:params success:^(id JSON) {
        [self loadTableViewData];
    } failure:nil];
}

#pragma mark -
#pragma mark - setter and getter -

- (AboutMeHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            __typeof(self) __weak weakSelf = self;
            AboutMeHeaderView *headerView = [[AboutMeHeaderView alloc] initWithFrame:CGRectMake(0, 0, 273, 150)];
            headerView.clickHeadBlock = ^{
                HideSelf
                
                __typeof(self) __strong strongSelf = weakSelf;
                NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
                [strongSelf.navigationController pushViewController:person animated:YES];
                person.parent = strongSelf;
                if ([AccountHelper getAccount] != nil) {
                    person.userDTO = [AccountHelper getAccount];
                }
            };
            
            headerView.clickQRCodeBlock = ^{
                HideSelf
                PersonQRCardController *webCard = [[PersonQRCardController alloc] init];
                [weakSelf.navigationController pushViewController:webCard animated:YES];
            };
            
            headerView;
        });
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            [tableView registerClass:[AboutMeTableViewCell class] forCellReuseIdentifier:tableViewCellIdentifier];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView;
        });
    }
    return _tableView;
}

@end
