//
//  NewPersonIdentificationController.m
//  medtree
//
//  Created by 陈升军 on 15/4/4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewPersonIdentificationController.h"
#import "ServiceManager.h"
#import "CertificationDTO.h"
#import "UserType.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "NewPersonIdentificationCell.h"
#import "NewPersonIdentificationDetailController.h"
#import "CertificationStatusType.h"
#import "VerifyController.h"
#import "ExperienceDTO.h"


@interface NewPersonIdentificationController () <IdentificationDetailDelegate, UIAlertViewDelegate>
{
    NSMutableArray              *certificationArray;
    NSIndexPath                 *selectIndex;
    CertificationDTO            *certificationDTO;
}

@end

@implementation NewPersonIdentificationController

#pragma mark - UI

- (void)createUI
{
    [super createUI];
    [self createBackButton];
    
    [naviBar setTopTitle:@"身份认证"];
    
    certificationArray = [[NSMutableArray alloc] init];
    
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    table.enableHeader = NO;
    table.enableFooter = NO;
    [table registerCells:@{@"CertificationDTO" : [NewPersonIdentificationCell class]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userChanged) name:UserInfoChangeCertificatedNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

#pragma mark - noti
- (void)userChanged
{
    [self loadData];
}

#pragma mark - 数据源
- (void)loadData
{
    [self loadDataFromLocal];
    [self loadDataFromDB];
    [self loadDataFromNet];
}

- (void)loadDataFromLocal
{
    if (certificationArray.count > 0) {
        [certificationArray removeAllObjects];
    }
    
    for (int i = 0; i < 6; i ++) {
        CertificationDTO *dto = [[CertificationDTO alloc] init:@{}];
        dto.status = 0;
        if (i < 3) {
            dto.userType = 2+i; //  医生, 护士
        } else if (i < 5 && i > 2) {
            dto.userType = 4+i;  // 其他医务人员, 卫生行政/医学教科研人员, 医学学生
        } else {
            dto.userType = UserTypes_AlwaysBecome;
        }
        [certificationArray addObject:dto];
    }
    [table setData:[NSArray arrayWithObjects:certificationArray, nil]];
}

- (void)loadDataFromDB
{
    
}

- (void)loadDataFromNet
{
    [ServiceManager getData:@{@"method":[NSNumber numberWithInt:MethodType_UserInfo_UserCertification]} success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            if ([JSON objectForKey:@"result"]) {
                NSDictionary *dict = [JSON objectForKey:@"result"];
                
                for (int i = 0; i < certificationArray.count; i ++) {
                    CertificationDTO *dto = [certificationArray objectAtIndex:i];
                    dto.status = [[dict objectForKey:[NSString stringWithFormat:@"%zi",dto.userType]] integerValue];
                }
                [table setData:[NSArray arrayWithObjects:certificationArray, nil]];
            }
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - IdentificationDetailDelegate
- (void)updateData:(NSArray *)array
{
    for (int i = 0; i < array.count; i ++) {
        CertificationDTO *dto = [array objectAtIndex:i];
        for (int j = 0; j < certificationArray.count; j ++) {
            CertificationDTO *cdto = [certificationArray objectAtIndex:j];
            if (cdto.userType == dto.userType) {
                [certificationArray replaceObjectAtIndex:j withObject:dto];
                break;
            }
        }
    }
    [table setData:[NSArray arrayWithObjects:certificationArray, nil]];
}

#pragma mark - IdentificationDetailDelegate
- (void)updateCertificationArray:(CertificationDTO *)dto
{
    for (int j = 0; j < certificationArray.count; j ++) {
        CertificationDTO *cdto = [certificationArray objectAtIndex:j];
        if (cdto.userType == dto.userType) {
            cdto.status = dto.status;
//            [certificationArray replaceObjectAtIndex:j withObject:dto];
            break;
        }
    }
    [table setData:@[certificationArray]];
}

#pragma mark - BaseTableViewDelegate
- (void)clickCell:(CertificationDTO *)dto index:(NSIndexPath *)index
{
    certificationDTO = dto;
    if (self.experienceDto) {
        switch (self.experienceDto.experienceType) {
            case ExperienceType_Edu: {
                if (index.row != 4) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"教育经历只能认证学生" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                break;
            }
            case ExperienceType_Work: {
                if (index.row == 4) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"工作经历不能认证学生" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                break;
            }
        }
        
        if (dto.status == CertificationStatusType_Pass || dto.status == CertificationStatusType_Wait) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否重新认证" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag = 10000;
            [alert show];
        } else {
            [self pushToIdentificationDetail];
        }
    } else {
        if (dto.status == CertificationStatusType_Pass || dto.status == CertificationStatusType_Wait) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否重新认证" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            alert.tag = 10000;
            [alert show];
        } else {
            [self pushToIdentificationDetail];
        }
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10000) {
        if (buttonIndex == 1) {
            [self pushToIdentificationDetail];
        }
    }
}

#pragma mark - private
- (void)pushToIdentificationDetail
{
    VerifyController *vc = [[VerifyController alloc] init];
    vc.certifDto = certificationDTO;
    vc.experienceDto = self.experienceDto;
    vc.delegate = self;
    vc.fromVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
