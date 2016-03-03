//
//  FriendListController.m
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FriendListController.h"
#import "PersonCell.h"
#import "ServiceManager.h"
#import "UserDTO.h"
#import "ContactInfo.h"
#import "ContactUtil.h"
#import "AccountHelper.h"
#import "LoadingView.h"
#import "UserManager.h"
#import "DB+Public.h"
#import "FriendListCell.h"
#import "ColorUtil.h"
#import "LoginGetDataHelper.h"
#import "NewPersonDetailController.h"
#import "AddDegreeController.h"
#import "NavigationController.h"
#import "RelationSearchViewController.h"

@interface FriendListController () <UISearchBarDelegate>
{
    UILabel         *titleLab;
}

@end

@implementation FriendListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"我的好友"];
    [self createBackButton];
    
    [self.view addSubview:self.searchBar];
//    UIButton *rightButton = [NavigationBar createNormalButton:@"同步" target:self action:@selector(clickSync)];
//    [naviBar setRightButton:rightButton];

    sectionArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < ALPHA.length; i++) {
        [sectionArray addObject:[NSMutableArray array]];
    }

    table.enableHeader = YES;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCell:[FriendListCell class]];
    
    titleLab = [[UILabel alloc] init];
    titleLab.text = @"还没有好友哦，快去添加您的好友吧";
    titleLab.hidden = YES;
    titleLab.numberOfLines = 0;
    titleLab.textColor = [ColorUtil getColor:@"363636" alpha:1];
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    
    [self setRightBarView];
}

- (void)setRightBarView
{
//    [self createRightToolBarView];
//    NSDictionary *dict = @{@"imgNormal":@"toolBar_btn_add_person.png",@"imgLight":@"toolBar_btn_add_person_click.png",@"target":self,@"action":@"clickAdd"};
//    NSArray *array = [NSArray arrayWithObjects:dict, nil];
//    [rightBarView setInfo:array];
}

- (void)clickAdd
{
    AddDegreeController *degree = [[AddDegreeController alloc] init];
    [self.navigationController pushViewController:degree animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    self.searchBar.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), CGRectGetWidth(self.view.frame), 44);
    table.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.searchBar.frame));
    titleLab.frame = CGRectMake(20, size.height*0.38, size.width-40, 40);
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeLoading) name:GetFriendDataOverNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFriend:) name:AddFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriend:) name:DeleteFriendNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(denyFriend:) name:DenyFriendNotification object:nil];
}

- (void)closeLoading
{
    [LoadingView showProgress:NO inView:self.view];
    [self loadData];
}

- (NSDictionary *)getParam_FromLocal
{
    return @{@"method": [NSNumber numberWithInteger:MethodType_FriendList_Local], @"from": [NSNumber numberWithInt:0], @"size": [NSNumber numberWithInteger:10000]};
}

- (NSDictionary *)getParam_FromNet
{
    if ([LoginGetDataHelper getfriendDataIsOver]) {
        [LoadingView showProgress:YES inView:self.view];
        [LoginGetDataHelper getFriendData];
    }
    return @{};
}

- (void)parseData:(id)JSON
{
    NSArray *datas = (NSArray *)[JSON objectForKey:@"data"];
    if (datas.count == 0) {
        titleLab.hidden = NO;
    } else {
        titleLab.hidden = YES;
    }
    if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FriendList_Local) {
//        if (datas.count == 0) {
//            [self requestData];
//        }
    } else if ([[JSON objectForKey:@"method"] integerValue] == [self getMethodType_Net]) {
        [UserManager deleteFriendListFromLocal:@{@"type": [NSNumber numberWithInteger:RelationType_Friend]} success:^(id JSON) {

        } failure:^(NSError *error, id JSON) {
            
        }];
    }
    [sectionArray removeAllObjects];
    for (int i = 0; i < ALPHA.length; i++) {
        [sectionArray addObject:[NSMutableArray array]];
    }

    for (int i=0; i<datas.count; i++) {
        UserDTO *dto = [datas objectAtIndex:i];
//        [UserManager checkUser:dto];
        //
        if ([dto.userID isEqualToString:[[AccountHelper getAccount] userID]]) {
            continue;
        }
        //
        NSMutableString *phones = [NSMutableString string];
        for (int i=0; i<dto.phones.count; i++) {
            [phones appendString:[dto.phones objectAtIndex:i]];
            [phones appendString:@" "];
        }
        dto.desc = phones;
        //
        ContactInfo *ci = [[ContactInfo alloc] init];
        ci.name = dto.name;
        ci.reverse1 = dto.userID;
        NSIndexPath *indexPath = [ContactUtil addContact:ci sectionArray:sectionArray];
        [[sectionArray objectAtIndex:indexPath.section] replaceObjectAtIndex:indexPath.row withObject:dto];
    }

    [table setSectionHeader:[self createSectionHeaders:sectionArray]];
    [table setSectionTitleHeight:[self createSectionHeights:sectionArray]];
    //
    NSMutableArray *titles = [NSMutableArray array];
    for (int i=0; i<ALPHA.length; i++) {
        [titles addObject:[ALPHA substringWithRange:NSMakeRange(i, 1)]];
    }
    [[self getTable] setSectionIndexTitles:titles];

    //
    [table setData:sectionArray];
    if ([[JSON objectForKey:@"method"] integerValue] == [self getMethodType_Net]) {
        [LoadingView showProgress:NO inView:self.view];
    }

}

- (void)parseDataError:(id)JSON
{
    [LoadingView showProgress:NO inView:self.view];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    detail.userDTO = dto;
    detail.parent = self;
//    [detail setIsFriend:YES];
}

- (void)clickSync
{
    [LoadingView showProgress:YES inView:self.view];
    [self requestData];
}

- (void)loadData
{
    if ([LoginGetDataHelper getfriendDataIsOver]) {
        [LoadingView showProgress:NO inView:self.view];
    } else {
        if ([LoginGetDataHelper getfriendDataIsError]) {
            [LoadingView showProgress:YES inView:self.view];
            [LoginGetDataHelper getFriendData];
        } else {
            [LoadingView showProgress:NO inView:self.view];
        }
    }
    [self getDataFromLocal];
    //
//    [self requestData];
}

- (NSInteger)getMethodType_Net
{
    return MethodType_FriendList;
}

- (void)addFriend:(NSNotification*)notification
{
//    UserDTO *dto = (UserDTO *)notification.object;
//    NSLog(@"addFriend %@", dto);
    [self loadData];
}

- (void)deleteFriend:(NSNotification*)notification
{
//    UserDTO *dto = (UserDTO *)notification.object;
//    NSLog(@"deleteFriend %@", dto);
    [self loadData];
}

- (void)denyFriend:(NSNotification*)notification
{
//    UserDTO *dto = (UserDTO *)notification.object;
//    NSLog(@"denyFriend %@", dto);
    [self loadData];
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    RelationSearchViewController *relationSearchVC = [[RelationSearchViewController alloc] init];
    relationSearchVC.type = RelationSearchViewControllerFriendType;
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:relationSearchVC];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
    
    return NO;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"搜索";
        searchBar.delegate                  = self;
        searchBar.backgroundColor           = [UIColor clearColor];
        searchBar.autoresizesSubviews       = YES;
        searchBar.showsCancelButton         = NO;
        
        for (UIView *view in searchBar.subviews) {
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        
        _searchBar = searchBar;
    }
    
    return _searchBar;
}

@end
