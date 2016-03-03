//
//  MyCollectPositionViewController.m
//  medtree
//
//  Created by Jiangmm on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyCollectPositionViewController.h"
#import "MyCollectPositionDTO.h"
#import "MyCollectPositionCell.h"
#import "HomeJobChannelUnitJobViewController.h"
#import "ChannelManager.h"
#import "HomeJobChannelUnitAndEmploymentSearchViewController.h"
#import <ColorUtil.h>
#import "HomeJobChannelEmploymentDTO.h"
#import "ServiceManager.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "CollectionJobsView.h"

@interface MyCollectPositionViewController ()<BaseTableViewDelegate, MedBaseTableViewDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger      startIndex;
@property (nonatomic,assign)NSInteger       pageSize;
@property (nonatomic,strong) UIView         *emptyView;
@property (nonatomic,strong) UIImageView    *emptyPostitonImageView;
@property (nonatomic,strong) UIButton       *findPositonBtn;
@property (nonatomic,assign) NSIndexPath    *delIndexPath;
@property (nonatomic,strong) CollectionJobsView *collectionTableView;

@end

@implementation MyCollectPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.startIndex = 0;
    self.pageSize = 10;
    [self triggerPullToRefresh];
}
- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"收藏的职位"];
    [self createBackButton];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.registerCells = @{ @"HomeJobChannelEmploymentDTO" : [MyCollectPositionCell class]};
   
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadFooter:(BaseTableView *)table
{
    [self getDataFromNet];
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self getDataFromNet];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
   
    if ([dto isKindOfClass:[HomeJobChannelEmploymentDTO class]]) {
        HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
        vc.employmentDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - network request -

- (void)getDataFromNet
{
    NSDictionary *params = @{ @"method" : @(MethodType_CollectionJobs),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [ServiceManager getData:params success:^(id JSON) {
       
        [self handleRequest:JSON];
        
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
    }];
}
- (void)handleRequest:(id)json
{
    [self stopLoading];
    NSArray *positonArray = json;
    if (positonArray.count == 0) {
        [self setupView];
    }else{
        [self.emptyView removeFromSuperview];
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
        }
        [self.dataArray addObjectsFromArray:positonArray];
        self.startIndex += positonArray.count;
        self.enableFooter = self.pageSize == positonArray.count;
        [table setData:@[ self.dataArray ]];
    }
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    [self.view addSubview:self.emptyView];
    [self.emptyView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(0);
        make.top.equalTo(64);
    }];
    self.emptyPostitonImageView.frame = CGRectMake((size.width - 170) * 0.5, 120, 170, 125);
    self.findPositonBtn.frame = CGRectMake((size.width - 130) * 0.5, CGRectGetMaxY(self.emptyPostitonImageView.frame) + 30,130, 40);

}

#pragma mark -
#pragma mark - delete Cell -

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    self.delIndexPath = indexPath;
    return YES;
}

- (void)deleteIndex:(NSIndexPath *)indexPath{
    HomeJobChannelEmploymentDTO *dto = self.dataArray[indexPath.row];
    UserDTO *userDTO = [AccountHelper getAccount];
    NSDictionary *dict = @{@"job_id" :(dto.employmentID),
                           @"user_id":userDTO.userID,
                           @"method" : @(MethodType_CollectionJobs_Delete)};

    
    __weak typeof(self) myself = self;
    [ServiceManager setData:dict success:^(id JSON) {
        [myself stopLoading];
        [myself.tableView beginUpdates];
        if (myself.dataArray.count > indexPath.row) {
            [myself.dataArray removeObjectAtIndex:indexPath.row];
        }
        [myself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [myself.tableView endUpdates];

        
    } failure:^(NSError *error, id JSON) {
        [myself stopLoading];
    }];
}

#pragma  mark -
#pragma  mark - event response -

- (void)clickBtn
{
    HomeJobChannelUnitAndEmploymentSearchViewController *vc = [[HomeJobChannelUnitAndEmploymentSearchViewController alloc] init];
    vc.type = HomeJobChannelUnitAndEmploymentSearchViewControllerTypeEmployment;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma  mark - setter and getter-

- (CollectionJobsView *)tableView{
    return self.collectionTableView;
}

- (CollectionJobsView *)collectionTableView{
    if (!_collectionTableView) {
        _collectionTableView = ({
            CollectionJobsView *tableView = [[CollectionJobsView alloc] initWithFrame:CGRectZero
                                                                                style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.parent = self;
            tableView;
        });
    }
    return _collectionTableView;
}

-(UIView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.backgroundColor = [ColorUtil getColor:@"f4f4f7" alpha:1.0];
        _emptyView.contentMode = UIViewContentModeCenter;
        [_emptyView addSubview:self.emptyPostitonImageView];
        [_emptyView addSubview:self.findPositonBtn];
    }
    return _emptyView;
}

- (UIImageView *)emptyPostitonImageView
{
    if (!_emptyPostitonImageView) {
        _emptyPostitonImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.image = GetImage(@"icon_emptyPosition");
            imageView;
        
        });
    }
    return _emptyPostitonImageView;
}
-(UIButton *)findPositonBtn
{
    if (!_findPositonBtn) {
        _findPositonBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [ColorUtil getColor:@"365c8a" alpha:1.0];
            [btn setTitle:@"小跑去找工作" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
    }
    return _findPositonBtn;
}

@end
