//
//  MyFriendsViewController.m
//  medtree
//
//  Created by tangshimi on 6/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "ImageCenter.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "RelationPeopleCell.h"
#import "RelationManager.h"
#import "RelationSearchViewController.h"
#import "StatusView.h"

NSInteger const kMyFriendRelationType = 1;

@interface MyFriendsViewController ()

@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign)NSInteger startIndex;
@property (nonatomic, assign)NSInteger pageSize;
@property (nonatomic, strong)StatusView *statusView;

@end

@implementation MyFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray  =[[NSMutableArray alloc] init];
    self.startIndex = 0;
    self.pageSize = 10;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)createUI
{
    [super createUI];
    [FontUtil setBtnTitleFontColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [FontUtil setBarFontColor:[UIColor blackColor]];

    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = [ImageCenter getBundleImage:@"whiteColor_naviBar_background_top.png"];
    
    [naviBar setTopTitle:@"我的好友"];
    
    [table registerCells:@{ @"UserDTO" : [RelationPeopleCell class] }];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.enableHeader = YES;
    
    UIButton *closeButton = [NavigationBar createNormalButton:@"关闭"
                                                       target:self
                                                       action:@selector(closeButtonAction:)];
    [naviBar setLeftButton:closeButton];
    
    [self getDataFromLocal];
    [self getFriendListFromNet];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getFriendListFromNet];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getFriendListFromNet];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    [self dismissViewControllerAnimated:NO completion:nil];
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark - request -

- (void)getFriendListFromNet
{
    if (self.startIndex == 0) {
        [self.view addSubview:self.statusView];
        [self.statusView showWithStatusType:StatusViewLoadingStatusType];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param setObject:@(kMyFriendRelationType) forKey:@"relation_type"];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
        
    [RelationManager getRelationParam:param success:^(id JSON) {
        [self handleFriendListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)handleFriendListRequest:(id)JSON
{
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    if (peopleArray.count == 0) {
        self.statusView.statusType = StatusViewEmptyStatusType;
    } else {
        [self.statusView hide];
    }
    
    table.enableFooter = (peopleArray.count >= self.pageSize);
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:peopleArray];
    
    self.startIndex += peopleArray.count;
    
    [table setData:@[ self.dataArray ]];
}

- (void)getDataFromLocal
{
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setObject:@(MethodType_Relation_result) forKey:@"method"];
    [param setObject:@(kMyFriendRelationType) forKey:@"relation_type"];
    [param setObject:@(self.startIndex) forKey:@"from"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    
    [RelationManager getRelationFromLocalParam:param success:^(id JSON) {
        [self handleLocalRequest:JSON];
    }];
}

- (void)handleLocalRequest:(id)JSON
{
    NSArray *peopleArray = [JSON objectForKey:@"people"];
    
    if (peopleArray.count == 0) {
        self.statusView.statusType = StatusViewEmptyStatusType;
    } else {
        [self.statusView hide];
    }
    
    if (peopleArray.count == 0) {
        return ;
    }
    
    table.enableFooter = NO;
    [table setData:@[ peopleArray ]];
}

#pragma mark -
#pragma mark - response event -

- (void)closeButtonAction:(UIButton *)button
{
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
