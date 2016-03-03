//
//  MateUserTableController.m
//  medtree
//
//  Created by 陈升军 on 15/4/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MateUserTableController.h"
#import "UserDTO.h"
#import "ServiceManager.h"
#import "MateUserCell.h"
#import "PairDTO.h"
#import "MateUserHeaderCell.h"
#import "ColorUtil.h"
#import "ServiceManager.h"
#import "JSONKit.h"
#import "LoginGetDataHelper.h"
#import "LoadingView.h"

#import "InfoAlertView.h"


@interface MateUserTableController ()
{
    UserDTO                 *userDTO;
    NSInteger               pageSize;
    NSMutableArray          *userArray;
    NSMutableArray          *dataArray;
    NSString                *userID;
    
    UIView                  *btnBG;
    UIButton                *overlookButton;
    UIButton                *saveButton;
    UILabel                 *lineLab;
    
    NSInteger               selectNum;
}

@end

@implementation MateUserTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    
    [naviBar setTopTitle:@"确定并邀请"];
    
    userArray = [[NSMutableArray alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    
    pageSize = 10;
    
    table.enableHeader = NO;
    table.enableFooter = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"PairDTO": [MateUserCell class], @"UserDTO": [MateUserHeaderCell class]}];
    
    btnBG = [[UIView alloc] init];
    btnBG.layer.cornerRadius = 4;
    btnBG.layer.masksToBounds = YES;
    btnBG.backgroundColor = [ColorUtil getColor:@"365c8a" alpha:1];
    [self.view addSubview:btnBG];
    
    
    overlookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    overlookButton.backgroundColor = [UIColor clearColor];
    [overlookButton setTitle:@"忽略" forState:UIControlStateNormal];
    [overlookButton setTitleColor:[ColorUtil getColor:@"ffffff" alpha:1] forState:UIControlStateNormal];
    [overlookButton addTarget:self action:@selector(clickOverLook) forControlEvents:UIControlEventTouchUpInside];
    [btnBG addSubview:overlookButton];
    
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton setTitle:@"确定" forState:UIControlStateNormal];
    [saveButton setTitleColor:[ColorUtil getColor:@"ffffff" alpha:1] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
    [btnBG addSubview:saveButton];
    
    lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = [UIColor lightGrayColor];
    [btnBG addSubview:lineLab];
    
    selectNum = 0;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGSize size = self.view.frame.size;
    table.frame = CGRectMake(0, [self getOffset]+44, size.width, size.height-[self getOffset]-44-60);
    btnBG.frame = CGRectMake(10, size.height-55, size.width-20, 50);
    overlookButton.frame = CGRectMake(0, 0, btnBG.frame.size.width/3, 50);
    lineLab.frame = CGRectMake(btnBG.frame.size.width/3, 10, 1, 30);
    saveButton.frame = CGRectMake(btnBG.frame.size.width/3, 0, 2*btnBG.frame.size.width/3, 50);
    dataLoading.frame = CGRectMake(0, (size.height-100)/2, size.width, 100);
}

- (void)clickOverLook
{
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_ConnectionPeer],@"user_id":@"-404",@"contact_id":userDTO.mateID} success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            [LoginGetDataHelper updateMateData:userDTO.mateID user:nil overlook:YES];
            [self clickBack];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
}

- (void)clickSave
{
    if (userArray.count > 0)
    {
        [LoadingView showProgress:YES inView:self.view];
        UserDTO *dto = [userArray objectAtIndex:selectNum];
        [ServiceManager setData:@{@"method":[NSNumber numberWithInt:MethodType_ConnectionPeer],@"user_id":dto.userID,@"contact_id":userDTO.mateID} success:^(id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            if ([[JSON objectForKey:@"success"] boolValue]) {
                [LoginGetDataHelper updateMateData:userDTO.mateID user:dto overlook:NO];
                [self clickBack];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } failure:^(NSError *error, id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
                NSDictionary *result = [JSON objectFromJSONString];
                if ([result objectForKey:@"message"] != nil) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alert show];
                }
            }
        }];
    }
    else
    {
        [InfoAlertView showInfo:@"请选择一个身份" inView:table duration:2.0];
    }
}

- (void)setUserInfo:(UserDTO *)dto
{
    userDTO = dto;
    [table setData:[NSArray arrayWithObjects:[NSArray arrayWithObjects:userDTO, nil], nil]];
    [self getDataFromNet];
}

- (void)getDataFromNet
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInteger:MethodType_UserInfo_SearchName],@"name":[userDTO.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"from":[NSNumber numberWithInteger:0],@"size":[NSNumber numberWithInteger:userDTO.sameNameNum]} success:^(id JSON) {
        if (((NSArray *)JSON).count > 0) {
            [userArray addObjectsFromArray:JSON];
            
            for (int i = 0; i < ((NSArray *)JSON).count; i ++) {
                UserDTO *dto = [JSON objectAtIndex:i];
                PairDTO *pdto = [[PairDTO alloc] init:@{}];
                pdto.key = dto.name;
                pdto.value = [NSString stringWithFormat:@"%@ %@",dto.organization_name,dto.department_name];
                if (i == 0) {
                    pdto.isSelect = YES;
                } else {
                    pdto.isSelect = NO;
                }
                [dataArray addObject:pdto];
            }
            [table setData:[NSArray arrayWithObjects:[NSArray arrayWithObjects:userDTO, nil], dataArray, nil]];
        }
        
    } failure:^(NSError *error, id JSON) {
        [dataLoading showNoData:YES];
        dataLoading.hidden = NO;
    }];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if (index.section == 1) {
        selectNum = index.row;
        UserDTO *udto = [userArray objectAtIndex:index.row];
        userID = udto.userID;
        for (int i = 0; i < dataArray.count; i ++) {
            PairDTO *pdto = [dataArray objectAtIndex:i];
            if (index.row == i) {
                pdto.isSelect = YES;
            } else {
                pdto.isSelect = NO;
            }
        }
        [table setData:[NSArray arrayWithObjects:[NSArray arrayWithObjects:userDTO, nil], dataArray, nil]];
    }
}

@end
