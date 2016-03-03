//
//  HomeJobChannelViewController.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelViewController.h"
#import "SectionSpaceTableViewCell.h"
#import "EmptyDTO.h"
#import "SectionTitleTableViewCell.h"
#import "SectionTitleDTO.h"
#import "HomeJobChannelEmploymentDTO.h"
#import "HomeJobChannelHotEmploymentDTO.h"
#import "HomeJobChannelHotEmploymentEnterpriseTableViewCell.h"
#import "HomeJobChannelIntersetViewController.h"
#import "HomeJobChannelUnitAndEmploymentSearchViewController.h"
#import "HomeJobChannelUnitViewController.h"
#import "HomeJobChannelEmploymentTableViewCell.h"
#import "ChannelManager.h"
#import "UIColor+Colors.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "HomeJobChannelUnitJobViewController.h"
#import "HomeJonChannelGuideView.h"
#import "NavigationBarHeadView.h"
#import "RootViewController.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MyResumeViewController.h"

@interface HomeJobChannelViewController () <MedBaseTableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NavigationBarHeadView *leftBarItem;
@property (nonatomic, strong) UISearchBar *tableViewHeaderView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, copy) UIButton *footerView;

@end

@implementation HomeJobChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNoNetworkImage = YES;
    _dataArray = [[NSMutableArray alloc] init];
    
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [self showLoadingView];
    
    [self getdataFromLocal];
    
    [self triggerPullToRefresh];
    
    [HomeJonChannelGuideView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([AccountHelper getAccount].resumeCount == 0 && [AccountHelper getAccount].lookEmploymentAndEnterpriseCount == 5) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"您还未完善简历，完整的简历可以有更多机会被单位找到哦"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"去完善", nil];
        [alertView show];
    }
}

- (void)createUI
{
    [super createUI];
    
    if (self.title) {
        [naviBar setTopTitle:self.title];
        [self createBackButton];
    } else {
        [naviBar setTopTitle:@"职位"];
        [naviBar setLeftButton:self.leftBarItem];
    }
    [naviBar setRightButton:[NavigationBar createButton:@"意向" type:0 target:self action:@selector(interestButtonAction:)]];
    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.registerCells = @{ @"EmptyDTO" : [SectionSpaceTableViewCell class],
                                      @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                                      @"HomeJobChannelHotEmploymentDTO" : [HomeJobChannelHotEmploymentEnterpriseTableViewCell class],
                                      @"HomeJobChannelEmploymentDTO" : [HomeJobChannelEmploymentTableViewCell class] };
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [AccountHelper getAccount].lookEmploymentAndEnterpriseCount ++;
    if (buttonIndex == 1) {        
        MyResumeViewController *vc = [[MyResumeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getDataFromNet];
}

- (void)loadFooter:(MedBaseTableView *)table
{
    [self getDataFromNet];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    if ([dto isKindOfClass:[SectionTitleDTO class]]) {
        if (index.section == 0) {
            HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
            vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
            vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([dto isKindOfClass:[HomeJobChannelHotEmploymentDetailDTO class]]) {
        HomeJobChannelUnitViewController *vc = [[HomeJobChannelUnitViewController alloc] init];
        vc.enterpriseDTO = dto;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)clickCell:(HomeJobChannelEmploymentDTO *)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[HomeJobChannelEmploymentDTO class]]) {
        HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
        vc.employmentDTO = dto;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
    vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll;
    
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
    
    return NO;
}

#pragma mark -
#pragma mark - response event -

- (void)interestButtonAction:(UIButton *)button
{
    HomeJobChannelIntersetViewController *vc =[[HomeJobChannelIntersetViewController alloc] init];
    vc.type = HomeJobChannelIntersetViewControllerTypeChoseInterest;
    vc.updateBlock = ^{
        [self triggerPullToRefresh];
    };
    
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)buttonAction:(UIButton *)button
{
    HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
    vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - network -

- (void)getDataFromNet
{
    NSDictionary *params = @{ @"method" : @(MethodTypeJobChannelHomePage),
                              @"from" : @(self.startIndex),
                              @"size" : @(PageSize) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        [self hideLoadingView];
    }];
}

- (void)handleRequest:(NSDictionary *)dic
{
    [self stopLoading];
    
    NSArray *employmentArray = dic[@"employment"];
    
    if (self.startIndex == 0) {
        [self hideLoadingView];
        
        [self.dataArray removeAllObjects];
                
        SectionTitleDTO *titleDTO = [[SectionTitleDTO alloc] init];
        titleDTO.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];
        titleDTO.title = @"热招单位";
        titleDTO.showMoreButton = YES;
        titleDTO.moreButtonTitle = @"查看全部";
        titleDTO.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
        titleDTO.hideFooterLine = YES;
        
        [self.dataArray addObject:@[ titleDTO ]];
        
        if ([dic[@"hotEmploymentEnterprise"] count] > 0) {
            HomeJobChannelHotEmploymentDTO *dto = [[HomeJobChannelHotEmploymentDTO alloc] init];
            dto.enterpriseArray = dic[@"hotEmploymentEnterprise"];

            [self.dataArray addObject:@[ dto ]];
        }
        
        SectionTitleDTO *titleDTO1 = [[SectionTitleDTO alloc] init];
        titleDTO1.verticalViewColor = [UIColor colorFromHexString:@"#3dd3e0"];
        titleDTO1.title = @"推荐职位";
        titleDTO1.showMoreButton = YES;
        titleDTO1.moreButtonTitle = @"查看全部";
        titleDTO1.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
        titleDTO1.hideFooterLine = YES;
        
        [self.dataArray addObject:@[ titleDTO1 ]];
    }
    
    [self.dataArray addObject:employmentArray];
    
    self.showNoMorelogo = employmentArray.count == PageSize ? YES : NO;
    
    [self.tableView setData:self.dataArray];
}

- (void)getdataFromLocal
{
    NSDictionary *params = @{ @"method" : @(MethodTypeJobChannelHomePage),
                              @"from" : @(0),
                              @"size" : @(PageSize) };
    
    [ChannelManager getChannelFromLocalParam:params success:^(id JSON) {
        if (JSON) {
            [self handleRequest:JSON];
        }
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UISearchBar *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = ({
            UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 45)];
            searchBar.placeholder               = @"搜索";
            searchBar.delegate                  = self;
            searchBar.backgroundColor           = [UIColor colorFromHexString:@"#e8e8e8"];
            searchBar.autoresizesSubviews       = YES;
            
            for (UIView *view in searchBar.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                    [[view.subviews objectAtIndex:0] removeFromSuperview];
                    break;
                }
            }
            searchBar;
        });
    }
    return _tableViewHeaderView;
}

- (UIButton *)footerView
{
    if (!_footerView) {
        _footerView = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, GetScreenWidth, 40);
            [button setTitle:@"查看更多" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _footerView;
}

- (NavigationBarHeadView *)leftBarItem
{
    if (!_leftBarItem) {
        _leftBarItem = ({
            NavigationBarHeadView *headView = [[NavigationBarHeadView alloc] init];
            headView.clickBlock = ^{
                [[RootViewController shareRootViewController] showLeftSideMenuViewController];
            };
            headView;
        });
    }
    return _leftBarItem;
}

@end
