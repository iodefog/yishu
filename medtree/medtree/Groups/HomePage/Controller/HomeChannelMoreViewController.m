//
//  HomeChannelMoreViewController.m
//  medtree
//
//  Created by tangshimi on 11/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelMoreViewController.h"
#import "HomeChannelMoreTableViewCell.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "ChannelManager.h"
#import <InfoAlertView.h>
#import "HomeChannelMyInterestViewController.h"
#import "HomeJobChannelIntersetViewController.h"
#import "HomeChannelViewController.h"
#import "HomeJobChannelViewController.h"
#import "NewPersonIdentificationController.h"

@interface HomeChannelMoreViewController () <BaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger startIndex;

@end

@implementation HomeChannelMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    self.startIndex = 0;
    [self triggerPullToRefresh];
    [self showLoadingView];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"频道"];
    
    [self createBackButton];
    
    [self.tableView setRegisterCells:@{ @"HomeRecommendChannelDetailDTO" : [HomeChannelMoreTableViewCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(MedBaseTableView *)table
{
    self.startIndex = 0;
    [self channelMoreRequest];
}

- (void)loadFooter:(MedBaseTableView *)table
{
    [self channelMoreRequest];
}

- (void)clickCell:(HomeRecommendChannelDetailDTO *)dto index:(NSIndexPath *)index
{
    [ClickUtil event:@"homepage_open_channel" attributes:@{@"channel_id":dto.channelID, @"title":dto.channelName}];
    
    if (dto.canEnter) {
        if (dto.channelHaveTags && !dto.alreadySetTags) {
            if (dto.type == HomeRecommendChannelDetailDTOTypeNormalChannel || dto.type == HomeRecommendChannelDetailDTOTypeUnKnow) {
                HomeChannelMyInterestViewController *vc = [[HomeChannelMyInterestViewController alloc] init];
                vc.updateBlock = ^ {
                    dto.alreadySetTags = YES;
                    self.dataArray[index.row] = dto;
                };
                vc.channelDatailDTO = dto;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (dto.type == HomeRecommendChannelDetailDTOTypeJobChannel) {
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeChoseInterest;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if (dto.type == HomeRecommendChannelDetailDTOTypeNormalChannel || dto.type == HomeRecommendChannelDetailDTOTypeUnKnow) {
                HomeChannelViewController *channelVC = [[HomeChannelViewController alloc] init];
                channelVC.channelDetailDTO = dto;
                channelVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:channelVC animated:YES];
            } else if (dto.type == HomeRecommendChannelDetailDTOTypeJobChannel) {
                HomeJobChannelViewController *vc = [[HomeJobChannelViewController alloc] init];
                vc.title = dto.channelName;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        [InfoAlertView showInfo:@"认证身份后才可以进入哦！" inView:self.view duration:1];
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
            NewPersonIdentificationController *identification = [[NewPersonIdentificationController alloc] init];
            identification.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:identification animated:YES];
            [identification loadData];
        });
    }
}

#pragma mark -
#pragma mark - request -

- (void)channelMoreRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeChannelMoreChannel),
                             @"channel_type" : @(1),
                             @"from" : @(self.startIndex),
                             @"size" : @(PageSize) };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        [self handleChannelMoreRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        [self hideLoadingView];
    }];
}

- (void)handleChannelMoreRequest:(NSDictionary *)dict
{
    [self stopLoading];
    [self hideLoadingView];
    if (!dict[@"success"]) {
        return;
    }
    
    NSArray *channelArray = dict[@"channelArray"];
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    
    self.startIndex += channelArray.count;
    self.enableFooter = (channelArray.count == PageSize);
    
    [self.dataArray addObjectsFromArray:channelArray];
    [self.tableView setData:@[ self.dataArray ]];
}

@end
