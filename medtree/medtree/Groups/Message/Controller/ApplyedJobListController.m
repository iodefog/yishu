//
//  ApplyedJobListController.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "ApplyedJobListController.h"
// view
#import "SectionSpaceTableViewCell.h"
#import "HomeJobChannelUnitAndEmploymentSearchViewController.h"
#import "PopUpListView.h"
#import "ApplyedJobCell.h"
#import "JobPopupListViewCell.h"
#import "DeliverResumeRecorderController.h"
#import <InfoAlertView.h>
// manager
#import "JobManager.h"
// dto
#import "NSString+Extension.h"
#import "JobApplyDTO.h"
#import "EmptyDTO.h"

@interface ApplyedJobListController () <PopupListViewDelegate>
{
    int             _pageIndex; // 分页
    ApplyResult     _resultStatus;
}

@property (nonatomic, strong) NSMutableArray    *dataList;
@property (nonatomic, strong) PopupListView     *popView;
@property (nonatomic, strong) NSArray           *infoArray;
@property (nonatomic, strong) UIImageView       *emptyView;
@property (nonatomic, strong) UIButton          *findJobButton;

@end

@implementation ApplyedJobListController

- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    [self createRightButton];
    [naviBar setTopTitle:@"职位备忘"];
    
    [table registerCells:@{@"JobApplyDTO":[ApplyedJobCell class],
                           @"EmptyDTO":[SectionSpaceTableViewCell class]}];
    table.tableFooterView = [[UIView alloc] init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)createRightButton
{
    UIButton *rightButton = [NavigationBar createRightButton:@"筛选" target:self action:@selector(clickFilter)];
    [naviBar setRightButton:rightButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _resultStatus = ApplyResultAll;
    [self loadData];
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
}

- (void)setupData
{
    
}

- (void)setupView
{
    
}

#pragma mark - load data
- (void)loadData
{
    __unsafe_unretained typeof(self) weakSelf = self;
    [JobManager getData:@{@"method":@(MethodTypeJobDeliverys), @"status":@(_resultStatus)} success:^(NSDictionary *JSON) {
        if ([JSON[@"success"] boolValue]) {
            if ([JSON[@"result"] count] > 0) {
                [weakSelf.emptyView removeFromSuperview];
                [weakSelf.dataList removeAllObjects];
                for (NSDictionary *dict in JSON[@"result"]) {
                    EmptyDTO *empty = [[EmptyDTO alloc] init];
                    JobApplyDTO *dto = [[JobApplyDTO alloc] init:dict];
                    [weakSelf.dataList addObject:@[empty, dto]];
                }
                [table setData:weakSelf.dataList];
            } else {
                [weakSelf.view addSubview:weakSelf.emptyView];
                [weakSelf.emptyView addSubview:weakSelf.findJobButton];
                [weakSelf.emptyView makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
                }];
            }
        } else {
            if (JSON[@"message"]) {
                [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1.0];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)loadHeader:(BaseTableView *)table
{
    _pageIndex = 0;
    [self loadData];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self loadData];
}

#pragma mark - click
- (void)clickFilter
{
    [self.popView showAtPoint:CGPointMake(GetScreenWidth - 75, 64) inView:self.view];
}

- (void)clickFindJob
{
    HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
    vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PopupListViewDelegate -

- (CGSize)contentSizeOfPopupListView:(PopupListView *)listView
{
    return CGSizeMake(120, 352);
}

- (NSInteger)numberOfItemsOfPopupListView:(PopupListView *)listView
{
    return 8;
}

- (CGFloat)popupListView:(PopupListView *)listView cellHeightAtIndex:(NSInteger)index
{
    return 44;
}

- (void)popupListView:(PopupListView *)listView didSelectedAtIndex:(NSInteger)index
{
    _resultStatus = (ApplyResult)[self.infoArray[index][@"resultStatus"] integerValue];
    [table setData:@[@[]]];
    [self loadData];
}

- (Class)cellClassOfPopuoListView:(PopupListView *)listView
{
    return [JobPopupListViewCell class];
}

- (NSDictionary *)popuplistView:(PopupListView *)listView infoDictionaryAtIndex:(NSInteger)index
{
    return self.infoArray[index];
}

#pragma mark - BaseTableDelegate
- (void)clickCell:(JobApplyDTO *)dto index:(NSIndexPath *)index
{
    dto.checked = YES;
    //[table reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    DeliverResumeRecorderController *vc = [[DeliverResumeRecorderController alloc] init];
    vc.organization = dto.organization;
    vc.applyID = dto.applyID;
    vc.positionId = dto.positionId;
    vc.imageID = dto.avater;
    vc.shareInfo = dto.welfare;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - setter & getter
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (PopupListView *)popView
{
    if (!_popView) {
        _popView = ({
            PopupListView *view = [[PopupListView alloc] initWithArrowType:PopupListViewArrowTypeRight];
            view.delegate = self;
            view;
        });
    }
    return _popView;
}

- (NSArray *)infoArray
{
    if (!_infoArray) {
        _infoArray = @[ @{@"resultStatus" : @(ApplyResultAll), @"title" : @"全部"},
                        @{@"resultStatus" : @(ApplyResultAuditionAccess), @"title" : @"面试通过" },
                        @{@"resultStatus" : @(ApplyResultInviteAudition), @"title" : @"邀约面试" },
                        @{@"resultStatus" : @(ApplyResultAuditionFailure), @"title" : @"面试未通过" },
                        @{@"resultStatus" : @(ApplyResultChecking), @"title" : @"简历查阅中" },
                        @{@"resultStatus" : @(ApplyResultDeliver), @"title" : @"简历已投递" },
                        @{@"resultStatus" : @(ApplyResultResumeFailure), @"title" : @"简历未通过"},
                        @{@"resultStatus" : @(ApplyResultInviteDelivery), @"title": @"特别邀请", @"hideSeparation" : @YES} ];
    }
    return _infoArray;
}

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.contentMode = UIViewContentModeCenter;
        _emptyView.userInteractionEnabled = true;
        _emptyView.image = [UIImage imageNamed:@"no_applyed_job"];
    }
    return _emptyView;
}

- (UIButton *)findJobButton
{
    if (!_findJobButton) {
        _findJobButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_findJobButton setTitle:@"小跑去找工作" forState:UIControlStateNormal];
        [_findJobButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _findJobButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _findJobButton.backgroundColor = [ColorUtil getColor:@"365c89" alpha:1.0];
        [_findJobButton addTarget:self action:@selector(clickFindJob) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = [[_findJobButton titleForState:UIControlStateNormal] getStringWithFont:[UIFont systemFontOfSize:16]] + 32;
        _findJobButton.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width) * 0.5, CGRectGetMaxY([UIScreen mainScreen].bounds) * 0.5 + 50, width, 40);
        _findJobButton.layer.masksToBounds = YES;
        _findJobButton.layer.cornerRadius = 2;
    }
    return _findJobButton;
}

@end
