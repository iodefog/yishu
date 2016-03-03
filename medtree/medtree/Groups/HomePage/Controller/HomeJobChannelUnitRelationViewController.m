//
//  HomeJobChannelUnitRelationViewController.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelUnitRelationViewController.h"
#import "UserDTO.h"
#import "HomeJobChannelUnitRelationTableViewCell.h"
#import "ChannelManager.h"
#import "NewPersonDetailController.h"
#import "FriendRequestController.h"

@interface HomeJobChannelUnitRelationViewController () <MedBaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger startIndex;

@end

@implementation HomeJobChannelUnitRelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataArray = [[NSMutableArray alloc] init];
    
    [self triggerPullToRefresh];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"企业人脉"];
    [self createBackButton];
    
    self.tableView.registerCells = @{ @"UserDTO" : [HomeJobChannelUnitRelationTableViewCell class] };
}

#pragma mark -
#pragma mark - MedBaseTableViewDelegate -

- (void)loadHeader:(MedBaseTableView *)table
{
    self.startIndex = 0;
    
    [self enterpriseRequest];
}

- (void)loadFooter:(MedBaseTableView *)table
{
    [self enterpriseRequest];
}

- (void)clickCell:(UserDTO *)dto index:(NSIndexPath *)index
{
    NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
    detail.userDTO = dto;
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)clickCell:(UserDTO *)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    FriendRequestController *vc =[[FriendRequestController alloc] init];
    vc.dataDict = @{ @"type" : @(MethodType_Controller_Add), @"userID" : ((UserDTO *)dto).userID };
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark -
#pragma mark - request -

- (void)enterpriseRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeJobChannelEnterpriseRelation),
                             @"enterpriseID" : self.enterpriseID,
                             @"from" : @(self.startIndex),
                             @"size" : @(PageSize) };
    [ChannelManager getChannelParam:param success:^(id JSON) {
        [self handleEnterpriseRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
    }];
}

- (void)handleEnterpriseRequest:(NSDictionary *)dic
{
    [self stopLoading];
    
    if ([dic[@"success"] boolValue]) {
        NSArray *array = dic[@"result"];
     
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
        }
        
        for (NSDictionary *dict in array) {
            UserDTO *dto = [[UserDTO alloc] init:dict];
            
            [self.dataArray addObject:dto];
        }
        
        self.enableFooter = (array.count == PageSize);
        
        [self.tableView setData:@[ self.dataArray ] ];
    }
}

@end
