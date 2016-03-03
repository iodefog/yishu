//
//  MyCareerViewController.m
//  medtree
//  我的职场
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyCareerViewController.h"
#import "Pair2DTO.h"
#import "MyCareerCell.h"
#import "MyResumeViewController.h"
#import "MyConcernEnterpriseViewController.h"
#import "MyCollectPositionViewController.h"
@interface MyCareerViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation MyCareerViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    [self setupData];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"我的职场"];
    [self createBackButton];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    table.enableHeader = NO;
    [table registerCells:@{@"Pair2DTO":[MyCareerCell class]}];
}

- (void)setupData
{
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init:@{}];
        dto.title = @"收藏的职位";
        [dataArray addObject:dto];
    }
    {
        Pair2DTO *dto = [[Pair2DTO alloc] init:@{}];
        dto.title = @"我的个人简历";
        [dataArray addObject:dto];
    }
    [table setData:[NSArray arrayWithObjects:dataArray, nil]];
}

#pragma mark - BaseTableViewDelegate
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    UIViewController *vc;
    if (index.row == 0) {
        vc = [[MyCollectPositionViewController alloc] init];
    }
    if (index.row == 1) {
        vc = [[MyResumeViewController alloc] init];

    }
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
