//
//  ExperienceLoactionController.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceLoactionController.h"
#import "ExperienceCommonCell.h"
#import "ServiceManager.h"
#import "JSONKit.h"
#import "DegreeManager.h"
#import "AddOrgController.h"
#import "NavigationController.h"
#import "ExperienceOrgController.h"
#import "ExperienceDetailController.h"
#import "LoadingView.h"
#import "ProvinceDTO.h"

@interface ExperienceLoactionController ()
{
    NSMutableArray          *dataArray;
    NSInteger               fromNum;
    NSMutableDictionary     *userDict;
}
@end

@implementation ExperienceLoactionController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table setIsNeedFootView:NO];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor clearColor];
    [table registerCell:[ExperienceCommonCell class]];
    
    dataArray = [[NSMutableArray alloc] init];
    
    [naviBar setTopTitle:@"请选择地区"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
}

#pragma mark - 数据源
- (void)setOrgType:(OrgType)orgType
{
    _orgType = orgType;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:@(orgType) forKey:@"org_type"];
    [data setObject:[NSNumber numberWithInteger:MethodType_Degree_LocationSearch] forKey:@"method"];
    [data setObject:[NSNumber numberWithInteger:fromNum] forKey:@"from"];
    [data setObject:[NSNumber numberWithInteger:50] forKey:@"size"];
    [self getData:data];
}

- (void)getData:(NSDictionary *)dict
{
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager getData:dict success:^(NSArray *JSON) {
        [LoadingView showProgress:NO inView:self.view];
        [dataArray addObjectsFromArray:JSON];
        [table setData:@[dataArray]];
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
}

#pragma mark - click
- (void)clickCell:(ProvinceDTO *)dto index:(NSIndexPath *)index
{
    if (dto.count == 0) {
        [self gotoAddViewWithDto:dto];
    } else {
        ExperienceOrgController *org = [[ExperienceOrgController alloc] init];
        org.fromVC = self.fromVC;
        org.parent = self.fromVC;
        org.experienceType = _expType;
        org.province = dto;
        org.orgType = self.orgType;
        org.userType = self.userType;
        [self.navigationController pushViewController:org animated:YES];
    }
}

#pragma mark - private
//点击其他按钮去手动添加
- (void)gotoAddViewWithDto:(ProvinceDTO *)dto
{
    AddOrgController *vc = [[AddOrgController alloc] init];
    vc.province = dto;
    vc.expType = _expType;
    vc.userType = self.userType;
    vc.fromVC = self.fromVC;
    vc.parent = self.fromVC;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
