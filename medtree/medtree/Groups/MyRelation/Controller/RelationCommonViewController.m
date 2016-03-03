//
//  RelationCommonViewController.m
//  medtree
//
//  Created by tangshimi on 6/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationCommonViewController.h"
#import "UIColor+Colors.h"
#import "RelationCommonCell.h"
#import "FontUtil.h"
#import "ImageCenter.h"
#import "RelationPeopleViewController.h"
#import "RelationSearchViewController.h"
#import "NavigationController.h"
#import "RelationSchoolmateCommonViewController.h"
#import "RelationManager.h"
#import "AnnotationViewController.h"
#import "RelationDTO.h"
#import "UserDTO.h"
#import "RelationPeopleCell.h"
#import "NewPersonDetailController.h"
#import "MapTransitionAnimation.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "InfoAlertView.h"
#import "AddDegreeController.h"

NSString * const kRelationColleagueType  = @"20";
NSString * const kRelationFriendType = @"1";
NSString * const kRelationClassmateType = @"10";
NSString * const kRelationSchoolmateType = @"12";
NSString * const kRelationPeerType = @"22";
NSString * const kRelationFriendOfFriend = @"90";

@interface RelationCommonViewController () <UISearchBarDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *leftBackButton;
@property (nonatomic, strong) UIButton *rightMapButton;
@property (nonatomic, assign) BOOL isChangeStyle;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isAlreadySetTitle;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, assign) BOOL isShowMap;
@property (nonatomic, strong) MapTransitionAnimation *mapTransitionAnimation;
@property (nonatomic, strong) UIImageView *emptyView;

@end

@implementation RelationCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hideNoNetworkImage = YES;
    self.isShowMap = NO;
    self.startIndex = 0;
    self.pageSize = 10;
    self.dataArray = [[NSMutableArray alloc] init];
    self.locationArray = [[NSMutableArray alloc] init];
    self.mapTransitionAnimation = [[MapTransitionAnimation alloc] init];
    
    [naviBar setTopTitle:[self navBarTitle]];
    
    if (self.navigationController.viewControllers.count > 3) {
        self.leftBackButton.frame = CGRectMake(40, 0, 40, 44);
        [naviBar setLeftButtons:@[[self createBackButton], self.leftBackButton]];
    }
    
    if (self.type == RelationCommonViewControllerSchoolmateGradeType ) {
        [self changeStyle];
    }
    
    if (self.type != RelationCommonViewControllerSchoolmateMajorType &&
        self.type != RelationCommonViewControllerFriendOfFriendHospitalType) {
        self.rightMapButton.hidden = YES;
    } else {
        self.isShowMap = YES;
    }

    if (self.params && self.dataArray.count == 0) {
        [self getDataFromLocal];
        [self getDataFromNet];
    }
    
    if (!self.params) {
        if ([self isFirstGradeRelationCommonViewController]) {
            self.params = [self firstGradeRelationCommonViewControllerParams];
        }
        [self getDataFromLocal];
        [self getDataFromNet];
    }
}

- (void)createUI
{
    [super createUI];
    
    statusBar.backgroundColor = [UIColor blackColor];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    self.view.backgroundColor = [UIColor colorFromHexString:@"F4F4F7"];
    
    [self createBackButton];
    
    [naviBar setRightButton:self.rightMapButton];
    
    [table setRegisterCells:@{ @"RelationDTO": [RelationCommonCell class], @"UserDTO" : [RelationPeopleCell class] }];
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
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    [self getDataFromNet];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getDataFromNet];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[RelationDTO class]]) {
        RelationDTO *relationDTO = dto;
        
        if ([[self nextGradeViewControllerClassName] isEqualToString:@"RelationCommonViewController"]) {
            RelationCommonViewController *relationCommonVC = [[RelationCommonViewController alloc] init];
            relationCommonVC.type = [self nextGradeRelationCommonViewControllerType];
            relationCommonVC.params = [self nextGradeViewControllerParamsWithSelectedParam:relationDTO.name];
            relationCommonVC.navigationTitle = relationDTO.name;
            [self.navigationController pushViewController:relationCommonVC animated:YES];
        } else if ([[self nextGradeViewControllerClassName] isEqualToString:@"RelationPeopleViewController"]) {
            RelationPeopleViewController *relationPeopleVC = [[RelationPeopleViewController alloc] init];
            relationPeopleVC.type = [self nextRelationPeopleViewControllerType];
            relationPeopleVC.params = [self nextGradeViewControllerParamsWithSelectedParam:relationDTO.name];
            relationPeopleVC.topTitle = relationDTO.name;
            [self.navigationController pushViewController:relationPeopleVC animated:YES];
        } else if ([[self nextGradeViewControllerClassName] isEqualToString:@"RelationSchoolmateCommonViewController"]) {
            RelationSchoolmateCommonViewController *vc = [[RelationSchoolmateCommonViewController alloc] init];
            vc.type = [self nextRelationSchoolmateCommonViewControllerType];
            vc.params =  [self nextGradeViewControllerParamsWithSelectedParam:relationDTO.name];
            vc.selectedIndex = 0;
            vc.totalPeopleNumber = self.totalPeopleNumber;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if ([dto isKindOfClass:[UserDTO class]]) {
        NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
        person.parent = self;
        person.userDTO = dto;
        [self.navigationController pushViewController:person animated:YES];
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

#pragma marl -
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
            
            __weak __typeof(self) weakSelf = self;
            self.mapTransitionAnimation.complete = ^{
                weakSelf.navigationController.delegate = nil;
            };
            return [fromVC isKindOfClass:[AnnotationViewController class]] ? self.mapTransitionAnimation : nil;
        }
        default:
            return nil;
    }
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
#pragma mark - response event -

- (void)leftBackButtonAction:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightMapButtonAction:(UIButton *)button
{
    self.navigationController.delegate = self;
    
    AnnotationViewController *vc = [[AnnotationViewController alloc] init];
    [vc setAnnotation:self.locationArray];
    vc.param = self.params;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - request -

- (void)getDataFromNet
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
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

- (void)handleRequest:(id)JSON
{
    [self stopLoading];
    
    if ([[JSON objectForKey:@"success"] integerValue] != kRequestSuccessCode) {
        [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:2];
        return;
    }
    
    if (self.type == RelationCommonViewControllerColleagueHospitalType ||
        self.type == RelationCommonViewControllerSchoolmateGradeType) {
        if (self.totalPeopleNumber != [[JSON objectForKey:@"total"] integerValue]) {
            [self showAlertViewTip:self.type];
        }
    }

    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    NSArray *facetArray = [JSON objectForKey:@"facets"];
    
    NSArray *loactionArray = [JSON objectForKey:@"meta"];
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
        [self.locationArray removeAllObjects];
        if (facetArray.count == 0) {
            [self.dataArray addObjectsFromArray:peopleArray];
            self.enableFooter = (peopleArray.count >= self.pageSize);
        }
    }
    
    if (self.startIndex == 0) {
        if (peopleArray.count == 0 && facetArray.count == 0) {
            self.showNoMorelogo = NO;
            
            [self showDataEmptyView];
            if (self.type == RelationCommonViewControllerColleagueHospitalType || self.type == RelationCommonViewControllerPeerCityType) {
                [self showExpandRelationAlertViewTip:self.type];
            }
        } else {
            [self hideDataEmptyView];
        }
    }
    
    [self.dataArray addObjectsFromArray:facetArray];
    [self.locationArray addObjectsFromArray:loactionArray];
    
    if (facetArray.count == 0) {
        self.startIndex += peopleArray.count;
    }
    
    [table setData:@[ self.dataArray ]];
}

- (void)getDataFromLocal
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
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

- (void)handleLocalRequest:(id)JSON
{
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    NSArray *facetArray = [JSON objectForKey:@"facets"];
    
    NSArray *locationArray = [JSON objectForKey:@"meta"];
    
    self.enableFooter = NO;
    
    if (peopleArray.count == 0 && facetArray.count == 0) {
        [self showDataEmptyView];
    } else {
        [self hideDataEmptyView];
    }
    
    if (facetArray.count == 0) {
        if (peopleArray.count > 0) {
            [table setData:@[ peopleArray ]];
        }
    } else {
        [table setData:@[ facetArray ]];
    }
    
    [self.locationArray addObjectsFromArray:locationArray];
}

#pragma mark -
#pragma mark - help -

- (NSString *)nextGradeViewControllerClassName
{
    NSString *className = nil;
    switch (self.type) {
        case RelationCommonViewControllerSchoolmateGradeType:
        case RelationCommonViewControllerSchoolmateAcademicYearType:
        case RelationCommonViewControllerColleagueHospitalType:
        case RelationCommonViewControllerColleagueFirstGradeDepartmentType:
        case RelationCommonViewControllerPeerCityType:
        case RelationCommonViewControllerPeerHospitalType:
        case RelationCommonViewControllerFriendOfFriendHospitalType:
        case RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType:
        case RelationCommonViewControllerMapFirstGradeDepartmentType:
            className = [NSString stringWithUTF8String:object_getClassName([RelationCommonViewController class])];
            break;
        case RelationCommonViewControllerSchoolmateMajorType:
        case RelationCommonViewControllerColleagueSecondGradeDepartmentType:
        case RelationCommonViewControllerPeerFirstGradeDepartmentType:
        case RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType:
        case RelationCommonViewControllerMapSecondGradeDepartmentType:
            className = [NSString stringWithUTF8String:object_getClassName([RelationPeopleViewController class])];
            break;
        case RelationCommonViewControllerClassmateSchoolType:
        case RelationCommonViewControllerSchoolmateSchoolType:
            className = [NSString stringWithUTF8String:object_getClassName([RelationSchoolmateCommonViewController class])];
            break;
        default:
            break;
    }
    return className;
}

- (RelationCommonViewControllerType)nextGradeRelationCommonViewControllerType
{
    RelationCommonViewControllerType nextGradetype;
    switch (self.type) {
        case RelationCommonViewControllerSchoolmateSchoolType:
            nextGradetype = RelationCommonViewControllerSchoolmateGradeType;
            break;
        case RelationCommonViewControllerSchoolmateGradeType:
            nextGradetype = RelationCommonViewControllerSchoolmateAcademicYearType;
            break;
        case RelationCommonViewControllerSchoolmateAcademicYearType:
            nextGradetype = RelationCommonViewControllerSchoolmateMajorType;
            break;
        case RelationCommonViewControllerColleagueHospitalType:
            nextGradetype = RelationCommonViewControllerColleagueFirstGradeDepartmentType;
            break;
        case RelationCommonViewControllerColleagueFirstGradeDepartmentType:
            nextGradetype = RelationCommonViewControllerColleagueSecondGradeDepartmentType;
            break;
        case RelationCommonViewControllerPeerCityType:
            nextGradetype = RelationCommonViewControllerPeerHospitalType;
            break;
        case RelationCommonViewControllerPeerHospitalType:
            nextGradetype = RelationCommonViewControllerPeerFirstGradeDepartmentType;
            break;
        case RelationCommonViewControllerFriendOfFriendHospitalType:
            nextGradetype = RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType;
            break;
        case RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType:
            nextGradetype = RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType;
            break;
        case RelationCommonViewControllerMapFirstGradeDepartmentType:
            nextGradetype = RelationCommonViewControllerMapSecondGradeDepartmentType;
            break;
        default:
            break;
    }
    return nextGradetype;
}

- (RelationPeopleViewControllerType)nextRelationPeopleViewControllerType
{
    RelationPeopleViewControllerType nextGradeType;
    switch (self.type) {
        case RelationCommonViewControllerClassmateSchoolType:
            nextGradeType = RelationPeopleViewControllerClassmateType;
            break;
        case RelationCommonViewControllerSchoolmateMajorType:
            nextGradeType = RelationPeopleViewControllerSchoolmateType;
            break;
        case RelationCommonViewControllerColleagueSecondGradeDepartmentType:
            nextGradeType = RelationPeopleViewControllerColleagueType;
            break;
        case RelationCommonViewControllerPeerFirstGradeDepartmentType:
            nextGradeType = RelationPeopleViewControllerPeerType;
            break;
        case RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType:
            nextGradeType = RelationPeopleViewControllerFriendOfFriendType;
            break;
        case RelationCommonViewControllerMapSecondGradeDepartmentType:
            nextGradeType = RelationPeopleViewControllerMapType;
            break;
        default:
            break;
    }
    return nextGradeType;
}

- (RelationSchoolmateCommonViewControllerType)nextRelationSchoolmateCommonViewControllerType
{
    RelationSchoolmateCommonViewControllerType type;
    switch (self.type) {
        case RelationCommonViewControllerClassmateSchoolType:
            type = RelationSchoolmateCommonViewControllerClassmatePeopleType;
            break;
        case RelationCommonViewControllerSchoolmateSchoolType:
            type = RelationSchoolmateCommonViewControllerSchoolmateGradeType;
            break;
        case RelationCommonViewControllerSchoolmateGradeType:
            type = RelationSchoolmateCommonViewControllerSchoolmateAcademicYearType;
            break;
        case RelationCommonViewControllerSchoolmateAcademicYearType:
            type = RelationSchoolmateCommonViewControllerSchoolmateMajorType;
            break;
        case RelationCommonViewControllerSchoolmateMajorType:
            type = RelationSchoolmateCommonViewControllerSchoolmatePeopleType;
            break;
        default:
            break;
    }
    return type;
}

- (RelationSearchViewControllerType)relationSearchViewControllerType
{
    RelationSearchViewControllerType searchType;
    switch (self.type) {
        case RelationCommonViewControllerClassmateSchoolType:
            searchType = RelationSearchViewControllerClassmateType;
            break;
        case RelationCommonViewControllerSchoolmateSchoolType:
        case RelationCommonViewControllerSchoolmateGradeType:
        case RelationCommonViewControllerSchoolmateAcademicYearType:
        case RelationCommonViewControllerSchoolmateMajorType:
            searchType = RelationSearchViewControllerSchoolmateType;
            break;
        case RelationCommonViewControllerColleagueHospitalType:
        case RelationCommonViewControllerColleagueFirstGradeDepartmentType:
        case RelationCommonViewControllerColleagueSecondGradeDepartmentType:
            searchType = RelationSearchViewControllerColleagueType;
            break;
        case RelationCommonViewControllerPeerCityType:
        case RelationCommonViewControllerPeerHospitalType:
        case RelationCommonViewControllerPeerFirstGradeDepartmentType:
            searchType = RelationSearchViewControllerPeerType;
            break;
        case RelationCommonViewControllerFriendOfFriendHospitalType:
        case RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType:
        case RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType:
            searchType = RelationSearchViewControllerFriendOfFriendType;
            break;
        default:
            break;
    }
    return searchType;
}

- (BOOL)isFirstGradeRelationCommonViewController
{
    if (self.type == RelationCommonViewControllerSchoolmateSchoolType ||
        self.type == RelationCommonViewControllerColleagueHospitalType ||
        self.type == RelationCommonViewControllerPeerCityType ||
        self.type == RelationCommonViewControllerFriendOfFriendHospitalType) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary *)firstGradeRelationCommonViewControllerParams
{
    NSDictionary *params = nil;
    switch (self.type) {
        case RelationCommonViewControllerSchoolmateSchoolType:
            params = @{ @"relation_type" : kRelationSchoolmateType, @"facet" : @"org_name" };
            break;
        case RelationCommonViewControllerClassmateSchoolType:
            params = @{ @"relation_type" : kRelationClassmateType, @"facet" : @"org_name" };
            break;
        case RelationCommonViewControllerColleagueHospitalType:
            params = @{ @"relation_type" : kRelationColleagueType, @"facet" : @"org_name" };
            break;
        case RelationCommonViewControllerPeerCityType:
            params = @{ @"relation_type" : kRelationPeerType, @"facet" : @"city" };
            break;
        case RelationCommonViewControllerFriendOfFriendHospitalType:
            params = @{ @"relation_type" : kRelationFriendOfFriend, @"facet" : @"org_name" };
            break;
        default:
            break;
    }
    return params;
}

- (NSDictionary *)nextGradeViewControllerParamsWithSelectedParam:(NSString *)paramString
{
    NSDictionary *params = nil;
    switch (self.type) {
        case RelationCommonViewControllerClassmateSchoolType:
            params = @{ @"relation_type" : kRelationClassmateType, @"org_name" : paramString };
        case RelationCommonViewControllerSchoolmateSchoolType:
            params = @{ @"relation_type" : kRelationSchoolmateType,
                        @"facet" : @"exp_start_year",
                        @"org_name" : paramString };
            break;
        case RelationCommonViewControllerSchoolmateGradeType:
            params = @{ @"relation_type" : kRelationSchoolmateType,
                                @"facet" : @"first_dept_name",
                             @"org_name" : self.params[@"org_name"],
                       @"exp_start_year" : paramString };
            break;
        case RelationCommonViewControllerSchoolmateAcademicYearType:
            params = @{ @"relation_type" : kRelationSchoolmateType,
                                @"facet" : @"second_dept_name",
                             @"org_name" : self.params[@"org_name"],
                       @"exp_start_year" : self.params[@"exp_start_year"],
                      @"first_dept_name" : paramString };
            break;
        case RelationCommonViewControllerSchoolmateMajorType:
            params = @{ @"relation_type" : kRelationSchoolmateType,
                             @"org_name" : self.params[@"org_name"],
                       @"exp_start_year" : self.params[@"exp_start_year"],
                      @"first_dept_name" : self.params[@"first_dept_name"],
                     @"second_dept_name" : paramString };
            break;
        case RelationCommonViewControllerColleagueHospitalType:
            params = @{ @"relation_type" : kRelationColleagueType,
                                @"facet" : @"first_dept_name",
                             @"org_name" : paramString };
            break;
        case RelationCommonViewControllerColleagueFirstGradeDepartmentType:
            params = @{ @"relation_type" : kRelationColleagueType,
                                @"facet" : @"second_dept_name",
                             @"org_name" : self.params[@"org_name"],
                      @"first_dept_name" : paramString };
            break;
        case RelationCommonViewControllerColleagueSecondGradeDepartmentType:
            params = @{ @"relation_type" : kRelationColleagueType,
                             @"org_name" : self.params[@"org_name"],
                      @"first_dept_name" : self.params[@"first_dept_name"],
                     @"second_dept_name" : paramString };
            break;
        case RelationCommonViewControllerPeerCityType:
            params = @{ @"relation_type" : kRelationPeerType, @"facet" : @"org_name", @"city" : paramString };
            break;
        case RelationCommonViewControllerPeerHospitalType:
            params = @{ @"relation_type" : kRelationPeerType,
                                @"facet" : @"first_dept_name",
                                 @"city" : self.params[@"city"] ,
                             @"org_name" : paramString };
            break;
        case RelationCommonViewControllerPeerFirstGradeDepartmentType:
            params = @{ @"relation_type" : kRelationPeerType,
                                 @"city" : self.params[@"city"],
                             @"org_name" : self.params[@"org_name"],
                      @"first_dept_name" : paramString };
            break;
        case RelationCommonViewControllerFriendOfFriendHospitalType:
            params = @{ @"relation_type" : kRelationFriendOfFriend,
                        @"facet" : @"first_dept_name",
                        @"org_name" : paramString };
            break;
        case RelationCommonViewControllerFriendOfFriendFirstGradeDepartmentType:
            params = @{ @"relation_type" : kRelationFriendOfFriend,
                        @"facet" : @"second_dept_name",
                        @"org_name" : self.params[@"org_name"],
                        @"first_dept_name" : paramString };
            break;
        case RelationCommonViewControllerFriendOfFriendSecondGradeDepartmentType:
            params = @{ @"relation_type" : kRelationFriendOfFriend,
                        @"org_name" : self.params[@"org_name"],
                        @"first_dept_name" : self.params[@"first_dept_name"],
                        @"second_dept_name" : paramString };
            break;            
        case RelationCommonViewControllerMapFirstGradeDepartmentType:
            params = @{ @"relation_type" : self.params[@"relation_type"],
                                @"facet" : @"second_dept_name",
                             @"org_name" : self.params[@"org_name"],
                      @"first_dept_name" : paramString };
            break;
        case RelationCommonViewControllerMapSecondGradeDepartmentType:
            params = @{ @"relation_type" : self.params[@"relation_type"],
                             @"org_name" : self.params[@"org_name"],
                      @"first_dept_name" : self.params[@"first_dept_name"],
                     @"second_dept_name" : paramString };
        default:
            break;
    }
    return params;
}

- (void)setTopTitle:(NSString *)title
{
    [naviBar setTopTitle:title];
    self.isAlreadySetTitle = YES;
}

- (NSString *)navBarTitle
{
    NSString *title = nil;
    
    switch (self.type) {
        case RelationCommonViewControllerColleagueHospitalType:
            title = @"同事";
            break;
        case RelationCommonViewControllerPeerCityType:
            title = @"同行";
            break;
        case RelationCommonViewControllerSchoolmateSchoolType:
            title = @"校友";
            break;
        case RelationCommonViewControllerFriendOfFriendHospitalType:
            title = @"好友的好友";
            break;
        default:
            title = self.navigationTitle;
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

- (void)showAlertViewTip:(RelationCommonViewControllerType)type
{
    NSString *message = nil;
    
    switch (type) {
        case RelationCommonViewControllerColleagueHospitalType:
            message = @"您有同事在不同的单位跟您有过交集，不会被计入总数哦~";
            break;
        case RelationCommonViewControllerSchoolmateGradeType:
            message = @"您有同学在不同的学校跟您有过交集，不会被计入总数哦~";
            break;
        default:
            break;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@", [AccountHelper getAccount].userID, message];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:key] boolValue] == YES) {
        return;
    }
    [userDefault setObject:@(YES) forKey:key];
    [userDefault synchronize];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)showExpandRelationAlertViewTip:(RelationCommonViewControllerType)type
{
    NSString *message = nil;
    switch (type) {
        case RelationCommonViewControllerColleagueHospitalType:
            message = @"亲，看来您是您同事中第一个来到医树的小伙伴，试试邀请Ta们吧";
            break;
        case RelationCommonViewControllerPeerCityType:
            message = @"亲，看来您是您同行中第一个来到医树的小伙伴，试试邀请Ta们吧";
            break;
        default:
            break;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"稍后再说"
                                              otherButtonTitles:@"拓展人脉", nil];
    [alertView show];
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
