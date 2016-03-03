//
//  MyConcernEnterpriseViewController.m
//  medtree
//
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "MyConcernEnterpriseViewController.h"
#import "MyConcernEnterpriseCell.h"
#import "PairDTO.h"
#import "ServiceManager.h"
#import "LoadingView.h"
#import "DeleteListTableView.h"
#import "EnterpriseDTO.h"

@interface MyConcernEnterpriseViewController ()
{
    NSMutableArray *dataArray;
    NSInteger from;
    NSInteger size;
    DeleteListTableView *tableView;
    NSIndexPath *delIndexPath;
}
@end

@implementation MyConcernEnterpriseViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
    from = 0;
    size = 10;
    [self setupData];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"我关注的企业"];
    [self createBackButton];
    
    tableView = [[DeleteListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.enableHeader = NO;
    tableView.enableFooter = NO;
    tableView.parent = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    [tableView registerCells:@{@"EnterpriseDTO":[MyConcernEnterpriseCell class]}];
}

#pragma mark - data handle
- (void)setupData
{
    NSDictionary *param = @{@"from":@(from),@"size":@(size),@"method":@(MethodType_ConcernEnterprise)};
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager getData:param success:^(id JSON) {
        NSArray *resultArray = JSON;
        [dataArray addObjectsFromArray:resultArray];
        [table setData:@[dataArray]];
        
        from += resultArray.count;
        table.enableFooter = (resultArray.count == size);
        [LoadingView showProgress:NO inView:self.view];
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
    }];
}

#pragma mark delete handle
- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    tableView.edto = [dataArray objectAtIndex:indexPath.row];
    delIndexPath = indexPath;
    return YES;
}

#pragma mark AlertViewDelegate delete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [ServiceManager setData:@{@"method":@(MethodType_ConcernEnterprise_Delete),@"id":((EnterpriseDTO *)tableView.edto).enterpriseId} success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            tableView.isCanDel = YES;
            [tableView tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:delIndexPath];
            tableView.isCanDel = NO;
            [tableView reloadData];
        }
    } failure:^(NSError *error, id JSON) {
    }];
}

@end
