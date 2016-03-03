//
//  ExperienceListController.m
//  medtree
//
//  Created by 边大朋 on 15/6/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceListController.h"

#import "ExperienceDTO.h"
#import "ExperienceCell.h"
#import "NewBtnCell.h"
#import "NewBtnView.h"
#import "UserDTO.h"
#import "Pair2DTO.h"
#import "DepartmentNameDTO.h"
#import "ExperienceDetailController.h"
#import "NavigationController.h"
#import "UserManager.h"
#import "AccountHelper.h"
#import "ServiceManager.h"
#import "DeleteListTableView.h"
#import "NewPersonIdentificationDetailController.h"
#import "CertificationDTO.h"
#import "NewPersonIdentificationController.h"


@interface ExperienceListController ()<NewBtnViewDelegate>
{
    NewBtnView                  *footerView;
    DeleteListTableView         *tableView;
    NSIndexPath                 *delIndexPath;
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ExperienceListController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    tableView = [[DeleteListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.parent = self;
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    tableView.enableHeader = NO;
    tableView.enableFooter = NO;
    [tableView setIsNeedFootView:NO];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerCells:@{@"ExperienceDTO": [ExperienceCell class],@"Pair2DTO": [NewBtnCell class]}];
    
    footerView = [[NewBtnView alloc] init];
    footerView.parent = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    
    tableView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
    
    NSString *title = (self.experienceType == ExperienceType_Edu) ? @"教育经历" : @"工作经历";
    
    [naviBar setTopTitle:title];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    NSArray *experienceArray = (self.experienceType == ExperienceType_Edu) ? [AccountHelper getAccount].educationArray : [AccountHelper getAccount].experienceArray;
    for (NSDictionary *dict in experienceArray) {
        ExperienceDTO *dto = [[ExperienceDTO alloc] init:dict];
        dto.isShowVerify = self.fromResume;
        [self.dataArray addObject:dto];
    }
    
    NSString *title = (self.experienceType == ExperienceType_Edu) ? @"教育经历" : @"工作经历";
    if (self.dataArray.count < 10) {
        Pair2DTO *pdto = [[Pair2DTO alloc] init];
        pdto.title = [NSString stringWithFormat:@"添加%@", title];
        [self.dataArray addObject:pdto];
    }
    
    [tableView setData: [NSArray arrayWithObjects:self.dataArray, nil]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.fromResume) {
        if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
            [self.parent updateInfo:@{@"experience":@(self.experienceType)}];
        }
    }
}

#pragma mark - BaseTableViewDelegate
- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if ([action integerValue] == ExperienceAction_GoToCert) {
        ExperienceDTO *experienceDto = (ExperienceDTO *)dto;
        if (self.fromVerify) { // 返回
            if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
                [self.parent updateInfo:@{@"organization_name":experienceDto.org,
                                          @"experience_id":experienceDto.experienceId,
                                          @"dep":experienceDto.department.name,
                                          @"title":experienceDto.title}];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else { // 身份选择
            NewPersonIdentificationController *vc = [[NewPersonIdentificationController alloc] init];
            vc.experienceDto = experienceDto;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else { // add
        ExperienceDetailController *vc = [[ExperienceDetailController alloc] init];
        vc.actionType = @"add";
        vc.parent = self.parent;
        vc.experienceType = self.experienceType;
        vc.comeFrom = ExperienceDetailControllerComeFrom_Default;
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:vc];
        navi.navigationBarHidden = YES;
        [self presentViewController:navi animated:YES completion:nil];
    }
}

//click for update
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[ExperienceDTO class]]) {
        ExperienceDTO *experienceDto = (ExperienceDTO *)dto;
        ExperienceDetailController *vc = [[ExperienceDetailController alloc] init];
        vc.actionType = @"update";
        vc.comeFrom = ExperienceDetailControllerComeFrom_Default;
        vc.parentCellIndex = index.row;
        vc.experienceType = self.experienceType;
        vc.experienceDto = experienceDto;
        NavigationController *navi = [[NavigationController alloc] initWithRootViewController:vc];
        navi.navigationBarHidden = YES;
        [self presentViewController:navi animated:YES completion:nil];
    }
    
}

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    if (self.fromVerify) {
        return NO;
    }
    tableView.edto = [self.dataArray objectAtIndex:indexPath.row];
    delIndexPath = indexPath;
    __block BOOL isHaveAddBtn = NO;
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[Pair2DTO class]]) {
            isHaveAddBtn = YES;
            *stop = YES;
        }
    }];
    if (!isHaveAddBtn) {
        return YES;
    } else {
        if (indexPath.row == self.dataArray.count-1) {
            return NO;
        } else {
            return YES;
        }
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_DeleteExperience],@"id":((ExperienceDTO *)tableView.edto).experienceId} success:^(id JSON) {
        
        tableView.isCanDel = YES;
        [tableView tableView:tableView commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:delIndexPath];
        tableView.isCanDel = NO;
        
        BOOL isSuccess = [[JSON objectForKey:@"success"] boolValue];
        if (isSuccess) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UserInfoChangeNotification object:nil];
        }
        
        if (self.dataArray.count < 10) {
            __block BOOL isHaveAddBtn = NO;
            [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[Pair2DTO class]]) {
                    isHaveAddBtn = YES;
                    *stop = YES;
                }
            }];
            if (!isHaveAddBtn) {
                Pair2DTO *pdto = [[Pair2DTO alloc] init];
                pdto.title = [NSString stringWithFormat:@"添加%@", naviBar.title];
                [self.dataArray addObject:pdto];
                [tableView reloadData];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - setter & getter
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end

