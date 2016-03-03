//
//  RelationSearchViewController.m
//  medtree
//
//  Created by tangshimi on 6/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "RelationSearchViewController.h"
#import "FontUtil.h"
#import "ImageCenter.h"
#import "ColorUtil.h"
#import "RelationPeopleCell.h"
#import "UserDTO.h"
#import "RelationManager.h"
#import "NewPersonDetailController.h"
#import "StatusView.h"

NSString * const kSearchColleagueType  = @"20";
NSString * const kSearchFriendType = @"1";
NSString * const kSearchClassmateType = @"10";
NSString * const kSearchSchoolmateType = @"12";
NSString * const kSearchPeerType = @"22";
NSString * const kSearchFriendOfFriend = @"90";
NSString * const kSearchStranger = @"0";

@interface RelationSearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, assign)NSInteger startIndex;
@property (nonatomic, strong)StatusView *statusView;

@end

@implementation RelationSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.pageSize = 10;
    self.startIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)createUI
{
    [super createUI];
    
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = [ImageCenter getBundleImage:@"whiteColor_naviBar_background_top.png"];
    [naviBar addSubview:self.searchBar];
    
    [table setRegisterCells:@{@"UserDTO": [RelationPeopleCell class]}];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.searchBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44);
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickTable
{
    [self.view endEditing:YES];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *person = [[NewPersonDetailController alloc] init];
    person.parent = self;
    person.userDTO = dto;
    [self.navigationController pushViewController:person animated:YES];
}

- (void)loadHeader:(MedBaseTableView *)table;
{
    self.startIndex = 0;
    [self getDataFromNet];
}

- (void)loadFooter:(MedBaseTableView *)table
{
    [self getDataFromNet];
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.startIndex = 0;
    
    [self.view endEditing:YES];
    
    [self getDataFromNet];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - request -

- (void)getDataFromNet
{
    if (self.startIndex == 0) {
        [self.view addSubview:self.statusView];
        [self.statusView showWithStatusType:StatusViewLoadingStatusType];
    }
    
    [RelationManager getRelationParam:[self param] success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        self.statusView.statusType = StatusViewEmptyStatusType;
    }];
}

- (void)getDataFromLocal
{
    [RelationManager getRelationFromLocalParam:[self param] success:^(id JSON) {
        
    }];
}

- (void)handleRequest:(id)JSON
{
    [self stopLoading];
    if ([JSON[@"success"] boolValue]) {
        NSArray *peopleArray = [JSON objectForKey:@"people"];
        
        if (self.startIndex == 0) {
            if (peopleArray.count == 0) {
                self.statusView.statusType = StatusViewEmptyStatusType;
            } else {
                [self.statusView hide];
            }
        }
        
        self.enableFooter = (peopleArray.count >= self.pageSize);

        if (peopleArray.count == 0) {
            [self.dataArray removeAllObjects];
            [table reloadData];
            self.startIndex = 0;
            return ;
        }
        
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:peopleArray];
        
        self.startIndex += peopleArray.count;
        
        [table setData:@[ self.dataArray ]];
    } else {
        self.startIndex =0;
         self.statusView.statusType = StatusViewEmptyStatusType;
        [self.dataArray removeAllObjects];
        [table reloadData];
    }
}

#pragma mark -
#pragma mark - helper -

- (NSDictionary *)param
{
    NSString *typeString = nil;
    switch (self.type) {
        case RelationSearchViewControllerColleagueType:
            typeString = [NSString stringWithFormat:@"%@", kSearchColleagueType];
            break;
        case RelationSearchViewControllerFriendType:
            typeString = [NSString stringWithFormat:@"%@", kSearchFriendType];
            break;
        case RelationSearchViewControllerClassmateType:
            typeString = [NSString stringWithFormat:@"%@", kSearchClassmateType];
            break;
        case RelationSearchViewControllerSchoolmateType:
            typeString = [NSString stringWithFormat:@"%@", kSearchSchoolmateType];
            break;
        case RelationSearchViewControllerPeerType:
            typeString = [NSString stringWithFormat:@"%@", kSearchPeerType];
            break;
        case RelationSearchViewControllerFriendOfFriendType:
            typeString = [NSString stringWithFormat:@"%@", kSearchFriendOfFriend];
            break;
        case RelationSearchViewControllerStrangerType:
            typeString = [NSString stringWithFormat:@"%@", kSearchStranger];
            break;
        default:
            break;
    }
    
    NSDictionary *dict = @{ @"method" : @(MethodType_Relation_result),
                            @"relation_type" : typeString,
                            @"keyword" : self.searchBar.text,
                            @"from" : @(self.startIndex),
                            @"size" : @(self.pageSize) };
    return dict;
}

#pragma mark -
#pragma mark - setter and getter

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"姓名";
        searchBar.delegate                  = self;
        searchBar.backgroundColor           = [UIColor clearColor];
        searchBar.autoresizesSubviews       = YES;
        searchBar.showsCancelButton         = YES;
        
        for (UIView *view in searchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        
        _searchBar = searchBar;
    }
    
    return _searchBar;
}

- (StatusView *)statusView
{
    if (!_statusView) {
        StatusView *view = [[StatusView alloc] initWithInView:self.view];
        view.removeFromSuperViewWhenHide = YES;
        _statusView = view;
    }
    return _statusView;
}

@end
