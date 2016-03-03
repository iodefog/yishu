//
//  ExperienceDetailController.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceDetailController.h"
#import "NewBtnView.h"
#import "UserDTO.h"
#import "FontUtil.h"
#import "ColorUtil.h"
#import "ImageCenter.h"
#import "AccountHelper.h"
#import "InfoAlertView.h"
#import "RegisterSelectTimeController.h"
#import "ServiceManager.h"
#import "TitleType.h"
#import "AddDepController.h"
#import "NavigationController.h"
#import "CommonHelper.h"
#import "ExperienceLoactionController.h"
#import "ExperienceDepController.h"
#import "DateUtil.h"
#import "ExperienceTitleController.h"
#import "LoadingView.h"
#import "AddTitleController.h"
#import "CommonCell.h"
// dto
#import "ExperienceDTO.h"
#import "OrganizationNameDTO.h"
#import "ProvinceDTO.h"
#import "DepartmentNameDTO.h"
#import "TitleDTO.h"

#define CHCellHeight 70

@interface ExperienceDetailController ()<NewBtnViewDelegate, ExperienceSearchDelegate, RegisterSelectTimeControllerDelegate, CommonCellDelegate>
{
    UserDTO                     *userDTO;
    NSMutableArray              *oraniztionArray;
    
    NewBtnView                  *footerView;
    BOOL                        isCurrent;
    
    /** 内容包装 */
    UIScrollView                *contentView;
    /** 单位 */
    CommonCell                  *organCell;
    /** 部门 */
    CommonCell                  *departmentCell;
    /** 职称 */
    CommonCell                  *titleCell;
    /** 时间 */
    CommonCell                  *durationCell;
    /** cell data list */
    NSArray                     *cells;
    /** 组织Dto */
    OrganizationNameDTO         *organDto;
    /** 部门Dto */
    DepartmentNameDTO           *departDto;
    /** 职称Dto */
    TitleDTO                    *titleDto;
    /** 时间 */
    NSString                    *startDate;
    NSString                    *endDate;
}

@end

@implementation ExperienceDetailController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [self createLeftBtn];
    [self initView];
}

- (void)createLeftBtn
{
    UIButton *leftButton = [NavigationBar createNormalButton:@"关闭" target:self action:@selector(clickClose)];
    [naviBar setLeftButton:leftButton];
}

- (void)initView
{
    self.view.backgroundColor = [ColorUtil getColor:@"F4F4F7" alpha:1];
    
    contentView = [[UIScrollView alloc] init];
    contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:contentView];
    
    organCell = [CommonCell commoncell];
    organCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:organCell];
    
    departmentCell = [CommonCell commoncell];
    departmentCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:departmentCell];
    
    titleCell = [CommonCell commoncell];
    titleCell.textFieldInteractionEnabled = NO;
    [contentView addSubview:titleCell];
    
    durationCell = [CommonCell commoncell];
    durationCell.textFieldInteractionEnabled = NO;
    durationCell.showMedLine = NO;
    durationCell.showFootLine = YES;
    [contentView addSubview:durationCell];
    
    cells = @[organCell, departmentCell, titleCell, durationCell];
    
    int offset = 2;
    for (int i = 0; i < cells.count; i ++) {
        CommonCell *cell = cells[i];
        cell.delegate = self;
        cell.tag = i + offset;
    }
    
    footerView = [[NewBtnView alloc] initWithFrame:CGRectZero];
    footerView.parent = self;
    [contentView addSubview:footerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [footerView setInfo:@"保存并返回"];
    [self setupView];
    [self setupData];
    if (self.comeFrom == ExperienceDetailControllerComeFrom_Default) {
        [self createLeftBtn];
    } else if (self.comeFrom == ExperienceDetailControllerComeFrom_Resume) {
        UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png"
                                                  selectedImage:@"btn_back_click.png"
                                                         target:self
                                                         action:@selector(clickClose)];
        [naviBar setLeftButton:backButton];
    }
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGFloat contentViewY = CGRectGetMaxY(naviBar.frame);
    contentView.frame = CGRectMake(0, contentViewY, size.width, size.height - contentViewY);
    CGFloat cellH = CHCellHeight;
    [cells enumerateObjectsUsingBlock:^(CommonCell *cell, NSUInteger idx, BOOL *stop) {
        CGFloat cellY = cellH * idx;
        cell.frame = CGRectMake(0, cellY, size.width, cellH);
    }];
    
    footerView.frame = CGRectMake(0, CGRectGetMaxY(durationCell.frame) + 30, self.view.frame.size.width, 55);
    CGFloat maxHeight = CGRectGetMaxY(footerView.frame);
    CGSize contentSize = CGSizeZero;
    if (maxHeight < size.height) {
        contentSize = CGSizeMake(size.width, maxHeight);
    } else {
        contentSize = CGSizeMake(size.width, maxHeight + 80);
    }
    contentView.contentSize = contentSize;
}

- (void)setupData
{
    NSString *title = @"";
    
    organCell.showNextImg = YES;
    departmentCell.showNextImg = YES;
    titleCell.showNextImg = YES;
    durationCell.showNextImg = YES;
    if (self.experienceDto) {
        organCell.text = self.experienceDto.org;
        organCell.showNextImg = !(self.experienceDto.experienceCertStatus == CertificationStatusType_Pass || self.experienceDto.experienceCertStatus == CertificationStatusType_Wait);
        departmentCell.text = self.experienceDto.department.name;
        departmentCell.showNextImg = !(self.experienceDto.experienceCertStatus == CertificationStatusType_Pass || self.experienceDto.experienceCertStatus == CertificationStatusType_Wait);
        titleCell.text = self.experienceDto.title;
        durationCell.text = [self covertStartDate:self.experienceDto.startDate endDate:self.experienceDto.endDate];
    }
    
    if (self.experienceType == ExperienceType_Work) {
        title = @"工作经历";
        organCell.title = @"工作单位";
        departmentCell.title = @"科室/部门";
        titleCell.title = @"职称/职务";
        durationCell.title = @"工作时间";
    } else if (self.experienceType == ExperienceType_Edu) {
        title = @"教育经历";
        organCell.title = @"学校";
        departmentCell.title = @"院系";
        titleCell.title = @"学历";
        durationCell.title = @"时间";
    }
    [naviBar setTopTitle:title];
}

#pragma mark - ExperienceSearchDelegate
- (void)updateInfo:(NSDictionary *)dict
{
    if ([[dict objectForKey:@"data"] isEqualToString:@"title"]) {   // 职位
        titleDto = dict[@"title"];
        titleCell.text = titleDto.title;
    } else if ([[dict objectForKey:@"data"] isEqualToString:@"organization"]) {   // 组织机构
        organDto = dict[@"organization"];
        organCell.text = organDto.name;
        
        //重置科室／时间
        departmentCell.text = @"";
        durationCell.text = @"";
        titleCell.text = @"";
        titleDto = nil;
        departDto = nil;
        startDate = @"";
        endDate = @"";
    } else if ([[dict objectForKey:@"data"] isEqualToString:@"department"]) { //  部门
        NSMutableArray *depArray = [[NSMutableArray alloc] init];
        departDto = dict[@"department"];
        departmentCell.text = departDto.name;
        [depArray addObject:@{@"department_id":departDto.departmentID.length > 0 ? departDto.departmentID : @"", @"department":departDto.name}];
        if (departDto.parent_id.length > 0) { // 有两级目录
            [depArray addObject:@{@"department_id":departDto.parent_id,@"department":departDto.parent_name}];
        }
    }
}

#pragma mark - private
- (NSString *)covertStartDate:(NSString *)start endDate:(NSString *)end
{
    NSString *experienceInterval = @"";
    if (start.length > 0 || end.length > 0) {
        start = [CommonHelper getDateWithStringToMonth:start];
        if (end.length == 0) {
            end = @"至今";
        } else {
            end = [CommonHelper getDateWithStringToMonth:end];
        }
        experienceInterval = [NSString stringWithFormat:@"%@-%@" ,start, end];
    }
    return experienceInterval;
}

- (void)showNotice:(NSString *)notice
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:notice delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}

//当机构为手动添加类型为单位时，去手动添加科室
- (void)gotoAddView
{
    AddDepController *vc = [[AddDepController alloc] init];
    vc.fromVC = self;
    vc.depName = departDto.name;
    vc.parent = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - RegisterSelectTimeControllerDelegate
- (void)updateTime:(NSDictionary *)dict
{
    startDate = [dict objectForKey:@"start"];
    endDate = [dict objectForKey:@"end"];
    if ((NSObject *)[dict objectForKey:@"end"] == [NSNull null] || [[dict objectForKey:@"end"] length] == 0) {
        durationCell.text = [NSString stringWithFormat:@"%@--至今",[dict objectForKey:@"start"]];
    } else {
        durationCell.text = [NSString stringWithFormat:@"%@--%@",[dict objectForKey:@"start"],[dict objectForKey:@"end"]];
    }
}

#pragma mark - click
- (void)clickClose
{
    if (self.comeFrom == ExperienceDetailControllerComeFrom_Default) {
        [self dismissViewControllerAnimated:YES completion:^{
            [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
            [FontUtil setBarFontColor:[UIColor whiteColor]];
        }];
    } else if (self.comeFrom == ExperienceDetailControllerComeFrom_Resume) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)btnClickSave
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    NSString *msg = @"";
    
    if (self.experienceType == ExperienceType_Work) {
        if(organDto.name.length == 0) {
            msg = @"请选择医院/单位/学校";
        } else if (departDto.name.length == 0) {
            msg = @"请选择部门/科室";
        } else if (titleDto.title.length == 0) {
            msg = @"请选择职称";
        } else if (startDate.length == 0 && endDate.length == 0) {
            msg = @"请填写时间";
        }
    } else {
        if (organDto.name.length == 0) {
            msg = @"请选择学校";
        }else if (departDto.name.length == 0) {
            msg = @"请选择专业";
        }else if (titleDto.title.length == 0) {
            msg = @"请选择学位/学历";
        } else if (startDate.length == 0 && endDate.length == 0) {
            msg = @"请填写时间";
        }
    }
    if (msg.length == 0) {
        if ([_actionType isEqualToString:@"update"]) {
            [dict setValue:self.experienceDto.experienceId forKey:@"id"];
        }
        [dict setValue:organDto.province.name forKey:@"province"];
        [dict setValue:@(organDto.type) forKey:@"org_type"];
        
        [dict setValue:@(self.experienceType) forKey:@"experience_type"];
        [dict setValue:((organDto.organizationID.length > 0) ? organDto.organizationID : @"") forKey:@"organization_id"];
        [dict setValue:organDto.name forKey:@"organization"];
        
        NSMutableArray *depArray = [[NSMutableArray alloc] init];
        if (departDto.parent_name.length > 0) {
            [depArray addObject:@{@"department_id":departDto.parent_id,@"department":departDto.parent_name}];
        }
        [depArray addObject:@{@"department_id":departDto.departmentID.length > 0 ? departDto.departmentID : @"",@"department":departDto.name}];
        
        [dict setValue:depArray forKey:@"departments"];
        
        [dict setValue:titleDto.title forKey:@"title"];
        
        NSString *startTime = startDate;
        startTime = [startTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
        startTime = [NSString stringWithFormat:@"%@-01-01 00:00:00",startTime];
        [dict setValue:startTime forKey:@"start_time"];
        
        if (endDate.length == 0) {
            [dict setValue:@"" forKey:@"end_time"];
        } else {
            NSString *endTime = endDate;
            endTime = [endTime stringByReplacingOccurrencesOfString:@"." withString:@"-"];
            endTime = [NSString stringWithFormat:@"%@-01-01 00:00:00",endTime];
            [dict setValue:endTime forKey:@"end_time"];
        }
        [dict setValue:@(isCurrent) forKey:@"is_current"];
        [dict setValue:@(titleDto.titleType) forKey:@"title_type"];
        
        [dict setValue:[NSNumber numberWithInt:([_actionType isEqualToString:@"update"] ? MethodType_UserInfo_UpadteExperience : MethodType_UserInfo_AddExperience)] forKey:@"method"];
        
        [LoadingView showProgress:YES inView:self.view];

        __unsafe_unretained typeof(self) weakSelf = self;
        [ServiceManager setData:dict success:^(NSDictionary *JSON) {
            if ([[JSON objectForKey:@"success"] boolValue]) {
                self.view.userInteractionEnabled = YES;
                [LoadingView showProgress:NO inView:self.view];
                
                NSDictionary *experience = JSON[@"result"];
                UserDTO *udto = [AccountHelper getAccount];
                if (weakSelf.experienceType == ExperienceType_Edu) {
                    if ([_actionType isEqualToString:@"update"]) {
                        [udto.educationArray replaceObjectAtIndex:_parentCellIndex withObject:experience];
                    } else {
                        [udto.educationArray addObject:experience];
                    }
                } else {
                    if ([_actionType isEqualToString:@"update"]) {
                        [udto.experienceArray replaceObjectAtIndex:_parentCellIndex withObject:experience];
                    } else {
                        [udto.experienceArray addObject:experience];
                    }
                }
                
                [udto setOrganization_id:weakSelf.experienceDto.organization_id];
                [UserManager checkUser:udto];
                [AccountHelper setAccount:udto];
                if ([self.parent respondsToSelector:@selector(reloadParent:)]){
                    [self.parent reloadParent:udto];
                }
                [self clickClose];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                [alert show];
            }
        } failure:^(NSError *error, id JSON) {
            [LoadingView showProgress:NO inView:self.view];
            self.view.userInteractionEnabled = YES;
        }];
    } else {
          [InfoAlertView showInfo:msg inView:self.view duration:1];
    }
}

#pragma mark - CommonCellDelegate
- (void)clickCell:(CommonCell *)cell
{
    NSInteger tag = cell.tag;
    switch (tag) {
        case CommonCellType_Organ:
            [self chooseOrgin];
            break;
        case CommonCellType_Department:
            [self chooseDepart];
            break;
        case CommonCellType_Duration:
            [self chooseTime];
            break;
        case CommonCellType_Title:
            [self chooseTitle];
            break;
    }
}

#pragma mark ----------
#pragma mark 选择机构
- (void)chooseOrgin
{
    if (self.experienceDto.experienceCertStatus == CertificationStatusType_Pass) {
        [self showNotice:(self.experienceType == ExperienceType_Work) ? @"认证过的工作经历不可更改，若想更改，请联系医树小助手": @"认证过的教育经历不可更改，若想更改，请联系医树小助手"];
        return;
    } else if (self.experienceDto.experienceCertStatus == CertificationStatusType_Wait) {
        [self showNotice:(self.experienceType == ExperienceType_Work) ? @"认证中的工作经历不可更改，若想更改，请联系医树小助手": @"认证中的教育经历不可更改，若想更改，请联系医树小助手"];
        return;
    }
    
    ExperienceLoactionController *location = [[ExperienceLoactionController alloc] init];
    location.expType = self.experienceType;
    location.fromVC = self;
    location.orgType = (self.experienceType == ExperienceType_Work) ? OrgType_All : OrgType_School;
    [self.navigationController pushViewController:location animated:YES];
}

#pragma mark 选择部门
- (void)chooseDepart
{
    if (self.experienceDto.experienceCertStatus == CertificationStatusType_Pass) {
        if (self.experienceType == ExperienceType_Work) {
            [self showNotice:(organDto.type == OrgType_Unit) ? @"所在部门已认证无法修改": @"所在科室已认证无法修改"];
        } else if (self.experienceType == ExperienceType_Edu) {
            [self showNotice:@"所在院系已认证无法修改"];
        }
        return;
    }
    if (self.experienceDto.experienceCertStatus == CertificationStatusType_Wait) {
        if (self.experienceType == ExperienceType_Work) {
            [self showNotice:(organDto.type == OrgType_Unit) ? @"认证中的部门不可修改": @"认证中的科室不可修改"];
        } else if (self.experienceType == ExperienceType_Edu) {
            [self showNotice:@"认证中的院系不可修改"];
        }
        return;
    }
    
    if (organDto.name.length == 0) {
        NSString *msg = (self.experienceType == ExperienceType_Work) ? @"请选择工作单位" : @"请选择学校";
        [InfoAlertView showInfo:msg inView:self.view duration:1];
        return;
    }

    if (organDto.type == OrgType_Unit && organDto.organizationID.length == 0) {
        [self gotoAddView];
    } else {
        ExperienceDepController *dep = [[ExperienceDepController alloc] init];
        dep.parent = self;
        dep.orgType = (OrgType)organDto.type;
        dep.experienceType = self.experienceType;
        dep.organDto = organDto;
        dep.fromVC = self;
        dep.departmentName = departDto.name;
        [self.navigationController pushViewController:dep animated:YES];
    }
}

#pragma mark 选择学历、职务
- (void)chooseTitle
{
    if (self.experienceType == ExperienceType_Work) {
        if (organDto.name.length == 0) {
            [InfoAlertView showInfo:@"请选择工作单位" inView:self.view duration:1];
            return;
        }
    } else if (self.experienceType == ExperienceType_Edu) {
        if (organDto.name.length == 0) {
            [InfoAlertView showInfo:@"请选择学校" inView:self.view duration:1];
            return;
        }
    }
    if (organDto.type == OrgType_Unit && self.experienceType == ExperienceType_Work) {
        AddTitleController *add = [[AddTitleController alloc] init];
        add.fromVC = self;
        add.titleName = titleDto.title;
        add.parent = self;
        [self.navigationController pushViewController:add animated:YES];
    } else {
        ExperienceTitleController *titleVC = [[ExperienceTitleController alloc] init];
        titleVC.experienceType = self.experienceType;
        titleVC.orgType = (OrgType)organDto.type;
        titleVC.titleDto = titleDto;
        titleVC.parent = self;
        [self.navigationController pushViewController:titleVC animated:YES];
    }
}

#pragma mark 选择时间
- (void)chooseTime
{
    if (self.experienceType == ExperienceType_Work) {
        if (organDto.name.length == 0) {
            [InfoAlertView showInfo:@"请选择工作单位" inView:self.view duration:1];
            return;
        }
    } else if (self.experienceType == ExperienceType_Edu) {
        if (organDto.name.length == 0) {
            [InfoAlertView showInfo:@"请选择学校" inView:self.view duration:1];
            return;
        }
    }
    RegisterSelectTimeController *time = [[RegisterSelectTimeController alloc] init];
    time.parent = self;
    time.startTime = startDate;
    time.endTime = endDate;
    time.userType = [AccountHelper getAccount].user_type;
    time.orgType = organDto.type;
    time.experienceType = self.experienceType;
    time.birthday = [AccountHelper getAccount].birthYear;
    [self.navigationController pushViewController:time animated:YES];
}

#pragma mark - setter & getter
- (void)setExperienceDto:(ExperienceDTO *)experienceDto
{
    _experienceDto = experienceDto;
    // 组织机构
    organDto = [[OrganizationNameDTO alloc] init];
    organDto.organizationID = experienceDto.organization_id;
    organDto.type = experienceDto.orgType;
    organDto.name = experienceDto.org;
    // 部门
    departDto = experienceDto.department;
    // 职称
    titleDto = [[TitleDTO alloc] init];
    titleDto.title = experienceDto.title;
    titleDto.titleType = (Title_Type)experienceDto.title_type;
    // 时间
    startDate = experienceDto.startDate;
    endDate = experienceDto.endDate;
}

@end
