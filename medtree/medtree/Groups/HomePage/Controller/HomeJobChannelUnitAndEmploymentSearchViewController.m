//
//  HomeJobChannelSearchViewController.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitAndEmploymentSearchViewController.h"
#import "HomeJobChannelIntersetViewController.h"
#import "HomeJobChannelUnitTableViewCell.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"
#import "HomeJobChannelEmploymentDTO.h"
#import "HomeJobChannelEmploymentTableViewCell.h"
#import "ChannelManager.h"
#import "HomeJobChannelUnitViewController.h"
#import "HomeJobChannelUnitJobViewController.h"
#import "PairDTO.h"
#import "HomeJobChannelSearchHistoryTableViewCell.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "StatusView.h"
#import "MyResumeViewController.h"
#import "HomeJobChannelSearchEmptyView.h"

static const CGFloat kFilterViewSpace = 55;
static NSString *const kHistorySearchKey = @"historySearchKey";

@interface HomeJobChannelUnitAndEmploymentSearchViewController () <UISearchBarDelegate, MedBaseTableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIView *tableViewHeaderView;
@property (nonatomic, strong) UIButton *filterButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, copy) NSDictionary *filterParams;
@property (nonatomic, strong) NavigationController *filterViewController;
@property (nonatomic, strong) StatusView *statusView;
@property (nonatomic, strong) HomeJobChannelSearchEmptyView *emptyView;

@end

@implementation HomeJobChannelUnitAndEmploymentSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blackBackgroundView.frame = self.view.bounds;
    self.blackBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.emptyView.frame = CGRectMake(0, 64, GetScreenWidth, GetScreenHeight - 64);
    
    _dataArray = [[NSMutableArray alloc] init];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(panGestureAction:)];
    [self.blackBackgroundView addGestureRecognizer:panGesture];
    
    if (self.type != HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        [self triggerPullToRefresh];
    } else {
        [self loadSearchHistory];
        
        self.enableHeader = NO;
        self.enableFooter = NO;
    }
    
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment ||
        self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb ||
        self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        [AccountHelper getAccount].lookEmploymentAndEnterpriseCount ++;
    }    
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
    
    self.searchBar.frame = CGRectMake(30, 5, GetScreenWidth - 30 - 65, 34);
    [naviBar setTopView:self.searchBar];
    
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit) {
        self.searchBar.placeholder = @"搜单位";
        [naviBar setRightButton:[NavigationBar createNormalButton:@"筛选" target:self action:@selector(filterButtonAction:)]];
        [self createBackButton];
    } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment ||
               self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb) {
        self.searchBar.placeholder = @"搜职位";
        [naviBar setRightButton:[NavigationBar createNormalButton:@"筛选" target:self action:@selector(filterButtonAction:)]];
        [self createBackButton];
    } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        self.searchBar.placeholder = @"搜索单位、职位";//@"多个关键字以“空格”隔开，搜企业搜职位";
        self.tableView.tableHeaderView = self.tableViewHeaderView;
        [naviBar setLeftButton:[NavigationBar createButton:@"取消" type:0 target:self action:@selector(cancleButtonAction:)]];
    }
    
    self.tableView.registerCells = @{ @"HomeJobChannelHotEmploymentDetailDTO" : [HomeJobChannelUnitTableViewCell class],
                                      @"HomeJobChannelEmploymentDTO" : [HomeJobChannelEmploymentTableViewCell class],
                                      @"PairDTO" : [HomeJobChannelSearchHistoryTableViewCell class] };
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [AccountHelper getAccount].lookEmploymentAndEnterpriseCount ++;
    if (buttonIndex == 1) {        
        MyResumeViewController *vc = [[MyResumeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - MedBaseTableViewDelegate -

- (void)loadHeader:(MedBaseTableView *)table
{
    self.startIndex = 0;
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit) {
        [self enterpriseRequest];
    } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment ||
               self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb ||
               self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        [self employmentRequest];
    }
}

- (void)loadFooter:(MedBaseTableView *)table
{
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit) {
        [self enterpriseRequest];
    } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment ||
               self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb ||
               self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        [self employmentRequest];
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[HomeJobChannelHotEmploymentDetailDTO class]]) {
        HomeJobChannelUnitViewController *vc = [[HomeJobChannelUnitViewController alloc] init];
        vc.enterpriseDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dto isKindOfClass:[HomeJobChannelEmploymentDTO class]]) {
        HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
        vc.employmentDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([dto isKindOfClass:[PairDTO class]]) {
        PairDTO *pdto = dto;
        self.searchBar.text = pdto.label;

        self.enableHeader = YES;
        [self triggerPullToRefresh];
    }
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.enableHeader = YES;
    [self triggerPullToRefresh];
    
    [self.view endEditing:YES];
    
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        NSString *key = [NSString stringWithFormat:@"%@%@", [AccountHelper getAccount].userID, kHistorySearchKey];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *historySearchArray = [[userDefault objectForKey:key] mutableCopy];
        if (!historySearchArray) {
            historySearchArray = [NSMutableArray new];
        }
        
        [historySearchArray addObject:searchBar.text];
        
        [userDefault setObject:historySearchArray forKey:key];
        [userDefault synchronize];
    }
}

#pragma mark -
#pragma mark - response event -

- (void)cancleButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)filterButtonAction:(UIButton *)button
{
    [self showFilterViewController];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.view];
    [panGesture setTranslation:CGPointZero inView:self.view];
    
    NavigationController *nvc = self.childViewControllers.firstObject;
    CGFloat centerX = nvc.view.center.x;
    
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGPoint center = CGPointMake(centerX + translation.x, self.view.center.y);
        
        if (center.x - GetScreenWidth / 2.0 >= kFilterViewSpace / 2.0) {
            nvc.view.center = center;
        }
    } else if (panGesture.state == UIGestureRecognizerStateEnded ||
               panGesture.state == UIGestureRecognizerStateCancelled) {
        CGFloat halfWidth = (GetScreenWidth - kFilterViewSpace) / 2.0;
        CGFloat originalCenterX = self.view.center.x + kFilterViewSpace / 2.0;
        if (centerX - originalCenterX < halfWidth) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                nvc.view.frame = CGRectMake(kFilterViewSpace , 0, GetScreenWidth - kFilterViewSpace, GetScreenHeight);
            } completion:nil];
        } else {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                nvc.view.frame = CGRectMake(GetScreenWidth, 0, GetScreenWidth, GetScreenHeight);
            } completion:^(BOOL finished) {
                [nvc.view removeFromSuperview];
                [self.blackBackgroundView removeFromSuperview];
                
                [nvc popToRootViewControllerAnimated:NO];
            }];
        }
    }
}

- (void)showFilterViewController
{
    [self.view addSubview:self.blackBackgroundView];
    [self.view addSubview:self.filterViewController.view];
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.filterViewController.view.frame = CGRectMake(kFilterViewSpace , 0, GetScreenWidth - kFilterViewSpace, GetScreenHeight);
    } completion:nil];
}

- (void)hideFileterViewController
{
    NavigationController *nvc = self.childViewControllers.firstObject;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        nvc.view.frame = CGRectMake(GetScreenWidth, 0, GetScreenWidth, GetScreenHeight);
    } completion:^(BOOL finished) {
        [nvc.view removeFromSuperview];
        [self.blackBackgroundView removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark - network request -

- (void)enterpriseRequest
{
    if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
        if (self.searchBar.text.length == 0) {
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:  @(MethodTypeJobChannelEnterprise) forKey:@"method"];
    [params setObject: @(self.startIndex) forKey:@"from"];
    [params setObject: @(PageSize) forKey:@"size"];
    if (self.searchBar.text.length > 0) {
        [params setObject:self.searchBar.text forKey:@"keyWord"];
    }
    
    if (self.filterParams) {
        [params addEntriesFromDictionary:self.filterParams];
    }
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        [self stopLoading];
    }];
}

- (void)employmentRequest
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:  @(MethodTypeJobChannelEmployment) forKey:@"method"];
    [params setObject: @(self.startIndex) forKey:@"from"];
    [params setObject: @(PageSize) forKey:@"size"];
    if (self.searchBar.text.length > 0) {
        [params setObject:self.searchBar.text forKey:@"keyWord"];
    }
    
    if (self.filterParams) {
        [params addEntriesFromDictionary:self.filterParams];
    }

    if (self.enterpriseID) {
        [params setObject:self.enterpriseID forKey:@"enterprise_id"];
    }
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        [self stopLoading];
    }];
}

- (void)handleRequest:(NSDictionary *)dic
{
    [self stopLoading];
    
    if (self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = nil;
    }
    
    NSArray *array = dic[@"resultArray"];
    
    for (HomeJobChannelEmploymentDTO *dto in array) {
        if (self.enterpriseID) {
            dto.isFromWeb = YES;
        }
    }
    
    if (self.startIndex == 0) {
        if (self.dataArray.count == 0) {
            [self hideLoadingView];
        }
        
        [self.dataArray removeAllObjects];
        
        if (array.count > 0 && ![naviBar rightButton]) {
            [naviBar setRightButton:[NavigationBar createNormalButton:@"筛选" target:self action:@selector(filterButtonAction:)]];
        }
        
        if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit) {
            if (array.count == 0 ) {
                [self.view addSubview:self.statusView];
                [self.statusView showWithStatusType:StatusViewEmptyStatusType];
            } else {
                [self.statusView hide];
            }
        } else {
            if (array.count == 0) {
                [self.view addSubview:self.emptyView];
            } else {
                [self.emptyView removeFromSuperview];
            }
        }
    }
    [self.dataArray addObjectsFromArray:array];
    self.startIndex += array.count;
    
    self.enableFooter = (array.count == PageSize);
    
    [self.tableView setData:@[ self.dataArray ]];
}

- (void)loadSearchHistory
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *historySearchArray = [userDefault arrayForKey:[NSString stringWithFormat:@"%@%@", [AccountHelper getAccount].userID, kHistorySearchKey]];
    
    for (NSString *historyKey in historySearchArray) {
        PairDTO *dto = [[PairDTO alloc] init];
        dto.label = historyKey;
        [self.dataArray insertObject:dto atIndex:0];
    }
    
    [self.tableView setData:@[ self.dataArray ]];
}

#pragma mark -
#pragma mark - setter and getter -

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = ({
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            searchBar.delegate = self;
            
            for (UIView *view in searchBar.subviews) {
                if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                    [[view.subviews objectAtIndex:0] removeFromSuperview];
                    break;
                }
            }
            searchBar;
        });
    }
    return _searchBar;
}

- (UIButton *)filterButton
{
    if (!_filterButton) {
        _filterButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"筛选" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(filterButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _filterButton;
}

- (UIView *)blackBackgroundView
{
    if (!_blackBackgroundView) {
        _blackBackgroundView =  ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            view;
        });
    }
    return _blackBackgroundView;
}

- (UIView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 100)];
            
            UILabel *tipLable = [[UILabel alloc] init];
            tipLable.textColor = [UIColor grayColor];
            tipLable.font = [UIFont systemFontOfSize:13];
            tipLable.numberOfLines = 0;
            [tipLable sizeToFit];
            
            NSString *string = @"多个关键字以“空格”隔开,搜单位搜职位,例如：想要搜索北京协和医院的外科职位,可在搜索框内输入“北京协和医院 外科”";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:8];

            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, string.length)];
            tipLable.attributedText = attributedString;
            
            [view addSubview:tipLable];
            
            UILabel *searchLabel = [[UILabel alloc] init];
            searchLabel.textColor = [UIColor grayColor];
            searchLabel.font = [UIFont systemFontOfSize:13];
            searchLabel.text = @"历史搜索记录";
            [view addSubview:searchLabel];
            
            [tipLable makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(10);
                make.right.equalTo(-15);
                make.left.equalTo(15);
            }];
            
            [searchLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(tipLable.bottom).offset(15);
                make.left.equalTo(15);
                make.bottom.equalTo(0);
            }];
            
            view;
        });
    }
    return _tableViewHeaderView;
}

- (NavigationController *)filterViewController
{
    if (!_filterViewController) {
        _filterViewController = ({
            HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
            if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeUnit) {
                vc.type = HomeJobChannelIntersetViewControllerTypeUnitFilter;
            } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment ||
                       self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeAll) {
                vc.type = HomeJobChannelIntersetViewControllerTypeEmploymentFilter;
            } else if (self.type == HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmploymentFromWeb) {
                vc.type = HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb;
            }
            
            __weak __typeof(self) weakSelf = self;
            vc.closeBlock = ^{
                __strong __typeof(self) strongSelf = weakSelf;
                [strongSelf hideFileterViewController];
            };
            
            vc.sureBlock = ^(NSDictionary *param) {
                __strong __typeof(self) strongSelf = weakSelf;
                strongSelf.filterParams = param;
                [strongSelf triggerPullToRefresh];
                [strongSelf hideFileterViewController];
            };
            
            NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
            nvc.navigationBarHidden = YES;
            nvc.view.frame = CGRectMake(kFilterViewSpace + 30, 0, GetScreenWidth - kFilterViewSpace, GetScreenHeight);
            
            [self addChildViewController:nvc];
            
            UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(panGestureAction:)];
            [nvc.view addGestureRecognizer:panGesture];
            
            nvc;
        });
    }
    return _filterViewController;
}

- (StatusView *)statusView
{
    if (!_statusView) {
        _statusView = ({
            StatusView *view = [[StatusView alloc] initWithInView:self.view];
            view.removeFromSuperViewWhenHide = YES;
            view;
        });
    }
    return _statusView;
}

- (HomeJobChannelSearchEmptyView *)emptyView
{
    if (!_emptyView) {
        _emptyView = ({
            HomeJobChannelSearchEmptyView *view = [[HomeJobChannelSearchEmptyView alloc] initWithFrame:CGRectZero];
            view;
        });
    }
    return _emptyView;
}

@end
