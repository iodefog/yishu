//
//  EventController.m
//  medtree
//
//  Created by sam on 9/3/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "EventViewController.h"
#import "ServiceManager.h"
#import "EventManager.h"
#import "EventDTO.h"
#import "GetDataLoadingView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "EventTableViewCell.h"
#import "EventFeedViewController.h"
#import "UrlParsingHelper.h"

@interface EventViewController ()

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation EventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.startIndex = 0;
    self.pageSize = 10;
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [self triggerPullToRefresh];
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"医树活动"];
    [self createBackButton];
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table setRegisterCells:@{ @"EventDTO" : [EventTableViewCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self eventListRequest];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self eventListRequest];
}

- (void)clickCell:(EventDTO *)dto index:(NSIndexPath *)index
{
    if (dto.event_type == EventActivityType) {
        EventFeedViewController *vc = [[EventFeedViewController alloc] init];
        vc.eventDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (dto.event_type == EventConferenceType) {
        [UrlParsingHelper operationUrl:dto.url controller:self title:dto.title];
    }
}

#pragma mark -
#pragma mark - network -

- (void)eventListRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeEventList),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    [EventManager getData:params success:^(id JSON) {
        [self handleEventListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
    }];
}

- (void)handleEventListRequest:(id)json
{
    [self stopLoading];
    
    NSArray *eventArray = json;
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:eventArray];
    self.startIndex += eventArray.count;
    
    self.enableFooter = self.pageSize == eventArray.count;
    
    [table setData:@[ self.dataArray ]];
}

@end
