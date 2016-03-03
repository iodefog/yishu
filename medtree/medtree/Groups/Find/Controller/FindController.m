//
//  FindController.m
//  medtree
//
//  Created by 无忧 on 14-8-29.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FindController.h"
#import "EventViewController.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "EventDTO.h"
#import "FindDTO.h"
#import "FindTableViewCell.h"
#import "FindManager.h"
#import "RootViewController.h"
#import "NavigationBarHeadView.h"
#import "EmptyDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "UIColor+Colors.h"
#import "FindEventTableViewCell.h"
#import "EventFeedViewController.h"
#import "UrlParsingHelper.h"
#import "FindGuideView.h"

@interface FindController () <MedBaseTableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NavigationBarHeadView *leftBarItem;

@end

@implementation FindController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.hideNoNetworkImage = YES;

    self.dataArray = [[NSMutableArray alloc] init];

    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoChangeNotificationAction:)
                                                 name:UserInfoChangeNotification
                                               object:nil];
    
    [self showLoadingView];

    [self getFindInfoFromLocal];

    [self triggerPullToRefresh];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"发现"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    [naviBar setLeftButton:self.leftBarItem];
    
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    
    [table setRegisterCells:@{ @"EmptyDTO" : [SectionSpaceTableViewCell class],
                               @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                               @"FindDTO" : [FindTableViewCell class],
                               @"EventDTO" : [FindEventTableViewCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(MedBaseTableView *)table
{
    [self getFindInfoFromNet];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[EventDTO class]]) {
        EventDTO *eventDTO = (EventDTO *)dto;
        if (eventDTO.event_type == EventActivityType) {
            EventFeedViewController *vc = [[EventFeedViewController alloc] init];
            vc.eventDTO = dto;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (eventDTO.event_type == EventConferenceType) {
            [UrlParsingHelper operationUrl:eventDTO.url controller:self title:eventDTO.title];
        }
    } else  if ([dto isKindOfClass:[FindDTO class]] ){
        FindDTO *findDTO = dto;
        [UrlParsingHelper operationUrl:findDTO.webURL controller:self title:findDTO.title];
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    if ([action integerValue] == SectionTitleTableViewCellClickTypeLookMore) {
        EventViewController *vc = [[EventViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - loadData -

- (void)getFindInfoFromNet
{
    [FindManager getFindParam:@{ @"method" : @(MethodTypeFindPage) } success:^(id JSON) {
        [self handleFindInfo:JSON];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        [self stopLoading];
    }];
}

- (void)getFindInfoFromLocal
{
    [FindManager getFindFromLocalParam:@{ @"method" : @(MethodTypeFindPage) } success:^(id JSON) {
        if (JSON) {
            [self handleFindInfo:JSON];
        }
    }];
}

- (void)handleFindInfo:(id)json
{
    [self stopLoading];
    [self hideLoadingView];
    
    if (![json[@"success"] boolValue]) {
        return;
    }
    
    [self.dataArray removeAllObjects];
    
    NSArray *eventArray = [NSArray arrayWithArray:json[@"event"]];
    NSArray *discoverArray = [NSArray arrayWithArray:json[@"discover"]];
    if (eventArray.count > 0) {
        NSMutableArray *sectionArray = [NSMutableArray new];
        
        EmptyDTO *emptyDTO1 = [[EmptyDTO alloc] init];
        SectionTitleDTO *titleDTO = [[SectionTitleDTO alloc] init];
        titleDTO.title = @"活动推荐";
        titleDTO.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];
        titleDTO.showMoreButton = YES;
        
        EmptyDTO *emptyDTO2 = [[EmptyDTO alloc] init];
        
        [sectionArray addObject:emptyDTO1];
        [sectionArray addObject:titleDTO];
        [sectionArray addObjectsFromArray:eventArray];
        [sectionArray addObject:emptyDTO2];
        
        [self.dataArray addObject:sectionArray];
        
        if (self.isViewLoaded && self.view.window) {
            [FindGuideView showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    
    if (discoverArray.count > 0) {
        [self.dataArray addObject:discoverArray];
    }
    [table setData:self.dataArray];
}

#pragma mark -
#pragma mark - response event -

- (void)userInfoChangeNotificationAction:(NSNotification *)notification
{
    [self triggerPullToRefresh];
}

#pragma mark -
#pragma mark - setter and geter -

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
