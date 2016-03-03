//
//  MessageJobPushViewController.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MessageJobPushViewController.h"
#import "MessagePushJobCell.h"
#import "SectionSpaceTableViewCell.h"
#import "MessageManager.h"
#import "EmptyDTO.h"
#import "PushJobDetailDTO.h"
#import "UserDTO.h"
#import <InfoAlertView.h>
#import "NSString+Extension.h"
#import "HomeJobChannelIntersetViewController.h"
#import "JobDetailViewController.h"

@interface MessageJobPushViewController ()
{
    NSUInteger  from;
}
@property (nonatomic, strong) NSMutableArray    *dataList;
@property (nonatomic, strong) UIButton          *righButton;
@property (nonatomic, strong) UIImageView       *emptyView;
@property (nonatomic, strong) UIButton          *editButton;

@end

@implementation MessageJobPushViewController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [table registerCells:@{@"PushJobDetailDTO":[MessagePushJobCell class], @"EmptyDTO":[SectionSpaceTableViewCell class]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBackButton];
    [self createRightNavi];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [naviBar setTopTitle:@"求职小助手"];
    
    [self loadData];
}

- (void)loadData
{
    __unsafe_unretained typeof(self) weakSelf = self;
    [MessageManager getData:@{@"method":@(MethodType_Message_Job_Push), @"from":@(from), @"size":@20} success:^(NSDictionary *JSON) {
        if ([JSON[@"success"] boolValue]) {
            UserDTO *user = [[UserDTO alloc] init:[JSON[@"meta"][@"profiles"] firstObject]];
            NSArray *array = JSON[@"result"];
            if (array.count > 0) {
                if (array.count < 20) {
                    table.enableFooter = NO;
                }
                if ([weakSelf.view.subviews containsObject:weakSelf.emptyView]) {
                    [weakSelf.emptyView removeFromSuperview];
                }
                for (NSDictionary *dict in array) {
                    PushJobDetailDTO *dto = [[PushJobDetailDTO alloc] init:dict];
                    dto.user = user;
                    EmptyDTO *emp = [[EmptyDTO alloc] init:@{}];
                    [weakSelf.dataList addObject:@[dto, emp]];
                }
                [table setData:weakSelf.dataList];
            } else {
                if (from == 0) {
                    [weakSelf.view addSubview:weakSelf.emptyView];
                    [weakSelf.emptyView addSubview:weakSelf.editButton];
                    [weakSelf.emptyView makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
                    }];
                }
            }
        } else {
            if (JSON[@"message"]) {
                [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1.5];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)createRightNavi
{
    [naviBar setRightButton:self.righButton];
    [naviBar setRightOffset:15];
    NSDictionary *param = @{@"method":@(MethodType_MessageSetting_Get)};
    [MessageManager getData:param success:^(id JSON) {
        self.righButton.selected = [JSON[@"refuse_job_assistent"] boolValue];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - click
- (void)clickChange
{
    NSDictionary *param = @{@"refuse_job_assistent":@(!self.righButton.selected),
                            @"method":@(MethodType_MessageSetting_Put)};
    [MessageManager setData:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            self.righButton.selected = !self.righButton.selected;
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)clickCell:(PushJobDetailDTO *)dto index:(NSIndexPath *)index
{
    JobDetailViewController *vc = [[JobDetailViewController alloc] init];
    vc.organization = dto.enterpriseName;
    vc.positionId = dto.jobId;
    vc.imageID = dto.enterpriseLogo;
    vc.shareInfo = dto.shareInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickEdit
{
    HomeJobChannelIntersetViewController *vc =[[HomeJobChannelIntersetViewController alloc] init];
    vc.type = HomeJobChannelIntersetViewControllerTypeChoseInterest;

    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - load data
- (void)loadHeader:(BaseTableView *)table
{
    from = 0;
    [self.dataList removeAllObjects];
    [self loadData];
}

- (void)loadFooter:(BaseTableView *)table
{
    from = self.dataList.count;
    [self loadData];
}

#pragma mark - setter & getter
- (NSMutableArray *)dataList
{
    if(!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UIButton *)righButton
{
    if (!_righButton) {
        _righButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_righButton setTitle:@"关闭推送" forState:UIControlStateNormal];
        [_righButton setTitle:@"打开推送" forState:UIControlStateSelected];
        [_righButton setTitle:@"打开推送" forState:UIControlStateSelected|UIControlStateHighlighted];
        _righButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_righButton addTarget:self action:@selector(clickChange) forControlEvents:UIControlEventTouchUpInside];
        _righButton.frame = CGRectMake(0, 0, [@"关闭推送" getStringWithFont:[UIFont systemFontOfSize:16]], 44);
    }
    return _righButton;
}

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.contentMode = UIViewContentModeCenter;
        _emptyView.userInteractionEnabled = YES;
        _emptyView.image = [UIImage imageNamed:@"no_job_push.png"];
    }
    return _emptyView;
}

- (UIButton *)editButton
{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑工作意向" forState:UIControlStateNormal];
        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _editButton.backgroundColor = [ColorUtil getColor:@"365c89" alpha:1.0];
        [_editButton addTarget:self action:@selector(clickEdit) forControlEvents:UIControlEventTouchUpInside];
        CGFloat width = [[_editButton titleForState:UIControlStateNormal] getStringWithFont:[UIFont systemFontOfSize:16]] + 32;
        _editButton.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - width) * 0.5, CGRectGetMaxY([UIScreen mainScreen].bounds) * 0.5 + 50, width, 40);
        _editButton.layer.masksToBounds = YES;
        _editButton.layer.cornerRadius = 2;
    }
    return _editButton;
}

@end
