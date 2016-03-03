//
//  MyIntegralViewController.m
//  medtree
//
//  Created by 陈升军 on 15/4/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "AccountHelper.h"
#import "MyIntegralHeaderView.h"
#import "MyIntegralCell.h"
#import "PairDTO.h"
#import "UrlParsingHelper.h"
#import "UserManager.h"
#import <JSONKit.h>
#import <InfoAlertView.h>

@interface MyIntegralViewController () <BaseTableViewDelegate>
{
    MyIntegralHeaderView        *headerView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray new];
    
    [self pointRequest];
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"我的积分"];
    [self createBackButton];
    
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.enableHeader = NO;

    headerView = [[MyIntegralHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*200/375)];
    [table setTableHeaderView:headerView];
    
    [table registerCells:@{@"PairDTO": [MyIntegralCell class]}];
    
    [AccountHelper getUser_Access_token:^(id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(PairDTO *)dto index:(NSIndexPath *)index
{
    [UrlParsingHelper operationUrl:dto.value controller:self title:dto.key];
}

#pragma mark -
#pragma mark - request -

- (void)pointRequest
{
    [UserManager getPointSuccess:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            [self.dataArray  removeAllObjects];
            
            NSDictionary *dic = JSON[@"result"];
            NSInteger integral = [dic[@"balance"] integerValue];
            NSDictionary *dict = dic[@"url_detail"];
            for (NSString *title in dict.allKeys) {
                PairDTO *dto = [[PairDTO alloc] init];
                dto.key = title;
                dto.value = dict[title];
                [self.dataArray addObject:dto];
            }
            
            [table setData:@[ self.dataArray ]];
            [headerView setInfo:integral];
        }
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
    }];
}

@end
