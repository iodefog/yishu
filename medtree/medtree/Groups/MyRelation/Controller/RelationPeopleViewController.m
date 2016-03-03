//
//  RelationPeopleViewController.m
//  medtree
//
//  Created by tangshimi on 6/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationPeopleViewController.h"
#import "RelationPeopleCell.h"
#import "FontUtil.h"
#import "UIColor+Colors.h"
#import "RelationSearchViewController.h"
#import "NavigationController.h"
#import "UserDTO.h"
#import "NewPersonDetailController.h"
#import "RelationManager.h"
#import "AnnotationViewController.h"
#import "AddDegreeController.h"
#import "AccountHelper.h"
#import "ImageCenter.h"
#import "MapTransitionAnimation.h"
#import "InfoAlertView.h"

@interface RelationPeopleViewController () <UIAlertViewDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *leftBackButton;
@property (nonatomic, strong) UIButton *rightMapButton;
@property (nonatomic, assign) BOOL isChangeStyle;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, assign) BOOL isShowMap;
@property (nonatomic, strong) UIButton *expandRelationButton;
@property (nonatomic, strong) MapTransitionAnimation *mapTransitionAnimation;
@property (nonatomic, strong) UIImageView *emptyView;

@end

@implementation RelationPeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hideNoNetworkImage = YES;
    
    self.isShowMap = NO;
    self.dataArray = [[NSMutableArray alloc] init];
    self.locationArray = [[NSMutableArray alloc] init];
    self.pageSize = 10;
    self.startIndex = 0;
    
    self.mapTransitionAnimation = [[MapTransitionAnimation alloc] init];
    
    if (self.type == RelationPeopleViewControllerFriendType) {
        [naviBar setTopTitle:[self navBarTitle]];
    } else {
        [naviBar setTopTitle:self.topTitle];
    }
    
    if (self.navigationController.viewControllers.count > 2) {
        self.leftBackButton.frame = CGRectMake(40, 0, 40, 44);
        [naviBar setLeftButtons:@[[self createBackButton], self.leftBackButton]];
    }
    
    if (self.type == RelationPeopleViewControllerClassmateType) {
        [self changeStyle];
        [self showRelationSearchGuideView];
    }
    
    if (!(self.type == RelationPeopleViewControllerClassmateType ||
          self.type == RelationPeopleViewControllerSchoolmateType ||
          self.type == RelationPeopleViewControllerFriendType)) {
        self.rightMapButton.hidden = YES;
    } else {
        self.isShowMap = YES;
    }
    
    if (self.type == RelationPeopleViewControllerFriendType) {
        [naviBar addSubview:self.expandRelationButton];
        self.expandRelationButton.frame = CGRectMake(GetScreenWidth - 100, 0, 44, 44);
    }
    
    [self getDataFromLocal];
    [self getDataFromNet];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];

}

- (void)createUI
{
    [super createUI];
    
    [self createBackButton];

    [naviBar setRightButton:self.rightMapButton];
    
    statusBar.backgroundColor = [UIColor blackColor];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorFromHexString:@"F4F4F7"];
    
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table setRegisterCells:@{ @"UserDTO": [RelationPeopleCell class] }];
    
    self.searchBar.placeholder = @"姓名";
    
    self.dataEmptyView = self.emptyView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.isChangeStyle) {
        self.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.searchBar.frame));
        table.frame = CGRectMake(0,
                                 CGRectGetMaxY(self.searchBar.frame),
                                 CGRectGetWidth(self.view.frame),
                                 CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.searchBar.frame));
    }
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    RelationSearchViewController *relationSearchVC = [[RelationSearchViewController alloc] init];
    relationSearchVC.type = [self relationSearchViewControllerType];
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:relationSearchVC];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
    
    return NO;
}

#pragma mark -
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        AddDegreeController *degree = [[AddDegreeController alloc] init];
        [self.navigationController pushViewController:degree animated:YES];
    }
}

#pragma mark -
#pragma mark - UINavigationControllerDelegate -

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    switch (operation) {
        case UINavigationControllerOperationPush:
            self.mapTransitionAnimation.type = MapTransitionAnimationPushType;
            self.mapTransitionAnimation.complete = nil;
            return [toVC isKindOfClass:[AnnotationViewController class]] ? self.mapTransitionAnimation : nil;
        case UINavigationControllerOperationPop: {
            self.mapTransitionAnimation.type = MapTransitionAnimationPopType;
            __weak __typeof(self) weak_self = self;
            self.mapTransitionAnimation.complete = ^{
                weak_self.navigationController.delegate = nil;
            };
            return [fromVC isKindOfClass:[AnnotationViewController class]] ? self.mapTransitionAnimation : nil;
        }
        default:
            return nil;
    }
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
    person.parent = self;
    person.userDTO = dto;
    [self.navigationController pushViewController:person animated:YES];
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getDataFromNet];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getDataFromNet];
}

#pragma mark -
#pragma mark - response event -

- (void)leftBackButtonAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightMapButtonAction:(UIButton *)button
{
    self.navigationController.delegate = self;
    AnnotationViewController *vc = [[AnnotationViewController alloc] init];
    vc.param = self.params;
    [vc setAnnotation:self.locationArray];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)expandRelationButtonAction:(UIButton *)button
{
    AddDegreeController *degree = [[AddDegreeController alloc] init];
    [self.navigationController pushViewController:degree animated:YES];
}

#pragma mark -
#pragma mark - request -

- (void)getDataFromNet
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param addEntriesFromDictionary:self.params];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    
    if (self.isShowMap) {
        [param setObject:@"true" forKey:@"fetch_org_details"];
    }
    
    [RelationManager getRelationParam:param success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        if ([table getData].count == 0) {
            [self showDataEmptyView];
        } else {
            [self hideDataEmptyView];
        }
    }];
}

- (void)getDataFromLocal
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param addEntriesFromDictionary:self.params];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    
    if (self.isShowMap) {
        [param setObject:@"true" forKey:@"fetch_org_details"];
    }

    [RelationManager getRelationFromLocalParam:param success:^(id JSON) {
        [self handleLocalRequest:JSON];
    }];
}

- (void)handleRequest:(id)JSON
{
    [self stopLoading];
    if ([[JSON objectForKey:@"success"] integerValue] != kRequestSuccessCode) {
        [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:2];
        return;
    }
    
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    NSArray *locationArray = [JSON objectForKey:@"meta"];
    
    self.enableFooter = (peopleArray.count >= self.pageSize);
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
        [self.locationArray removeAllObjects];
        
        if (self.type == RelationPeopleViewControllerClassmateType) {
            if (peopleArray.count == 0) {
                [self showAlertView];
            }
        } else {
            if (peopleArray.count == 0) {
                [self showDataEmptyView];
            } else {
                [self hideDataEmptyView];
            }
        }
    }
    [self.dataArray addObjectsFromArray:peopleArray];
    [self.locationArray addObjectsFromArray:locationArray];

    self.startIndex += peopleArray.count;

    [table setData:@[ self.dataArray ]];
}

- (void)handleLocalRequest:(id)JSON
{
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    NSArray *locationArray = [JSON objectForKey:@"meta"];
    
    if (peopleArray.count == 0) {
        return ;
    }
    
    self.enableFooter = NO;
    
    [self.locationArray addObjectsFromArray:locationArray];
    
    [table setData:@[ peopleArray ]];
}

#pragma mark -
#pragma mark - helper -

- (NSString *)navBarTitle
{
    NSString *title = nil;
    switch (self.type) {
        case RelationPeopleViewControllerColleagueType:
            title = @"同事";
            break;
        case RelationPeopleViewControllerPeerType:
            title = @"同行";
            break;
        case RelationPeopleViewControllerClassmateType:
            title = @"同学";
            break;
        case RelationPeopleViewControllerSchoolmateType:
            title = @"校友";
            break;
        case RelationPeopleViewControllerFriendType:
            title = @"好友";
            break;
        case RelationPeopleViewControllerFriendOfFriendType:
            title = @"好友的好友";
            break;
        default:
            break;
    }
    return title;
}

- (void)changeStyle
{
    naviBar.hidden = YES;
    statusBar.hidden = YES;
    
    self.isChangeStyle = YES;
    
    [self.view layoutIfNeeded];
}

- (RelationSearchViewControllerType)relationSearchViewControllerType
{
    RelationSearchViewControllerType searchType;
    switch (self.type) {
        case RelationPeopleViewControllerClassmateType:
            searchType = RelationSearchViewControllerClassmateType;
            break;
        case RelationPeopleViewControllerSchoolmateType:
            searchType = RelationSearchViewControllerSchoolmateType;
            break;
        case RelationPeopleViewControllerColleagueType:
            searchType = RelationSearchViewControllerColleagueType;
            break;
        case RelationPeopleViewControllerPeerType:
            searchType = RelationSearchViewControllerPeerType;
            break;
        case RelationPeopleViewControllerFriendType:
            searchType = RelationSearchViewControllerFriendType;
            break;
        case RelationPeopleViewControllerFriendOfFriendType:
            searchType = RelationSearchViewControllerFriendOfFriendType;
            break;
        default:
            break;
    }
    return searchType;
}

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"亲，看来您是您同学中第一个来到医树的小伙伴，试试邀请Ta们吧"
                                                       delegate:self
                                              cancelButtonTitle:@"稍后再说"
                                              otherButtonTitles:@"拓展人脉", nil];
    [alertView show];
}

- (void)showRelationSearchGuideView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstOpen = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@relationSearch", [AccountHelper getAccount].userID]] boolValue];
    
    if (!isFirstOpen) {
        [userDefaults setObject:@(YES) forKey:[NSString stringWithFormat:@"%@relationSearch", [AccountHelper getAccount].userID]];
        [userDefaults synchronize];
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIButton *)leftBackButton
{
    if (!_leftBackButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.frame = CGRectMake(0, 0, 80, 44);
        [button addTarget:self action:@selector(leftBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _leftBackButton = button;
    }
    return _leftBackButton;
}

- (UIButton *)rightMapButton
{
    if (!_rightMapButton) {
        _rightMapButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"myrelation_map.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(rightMapButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = CGRectMake(0, 0, 65, 44);
            button;
        });
    }
    return _rightMapButton;
}

- (UIButton *)expandRelationButton
{
    if (!_expandRelationButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:GetImage(@"myrelation_expand_relation.png") forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(expandRelationButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
        
        _expandRelationButton = button;
        
    }
    return _expandRelationButton;
}

- (void)setTopTitle:(NSString *)topTitle
{
    if (!topTitle) {
        return;
    }
    
    _topTitle = nil;
    _topTitle = topTitle;
    [naviBar setTopTitle:topTitle];
}

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"relation_empty.png");
            imageView;
        });
    }
    return _emptyView;
}

@end
