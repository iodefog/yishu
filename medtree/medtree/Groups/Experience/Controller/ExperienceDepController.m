//
//  ExperienceDepController.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceDepController.h"
#import "ServiceManager.h"
#import "ExperienceDTO.h"
#import "DepartmentNameDTO.h"
#import "JSONKit.h"
#import "ExperienceCommonCell.h"
#import "ExperienceDepSecondController.h"
#import "ColorUtil.h"
#import "AddDepController.h"
#import "NavigationController.h"
#import "ExperienceDetailController.h"
#import "LoadingView.h"
#import "MedGlobal.h"
#import "TextViewEx.h"
#import "CustomTextField.h"
#import "OrganizationNameDTO.h"

@interface ExperienceDepController ()<UISearchBarDelegate, ExperienceTableViewDelegate, RegisterOrganizationAddViewDelegate>
{
    NSMutableArray *depArray;
    NSString *orgId;
}
@end

@implementation ExperienceDepController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (inputView.hidden == NO) {
        [inputView becomeFirstResponder];
    }
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    searchShowView = [[UISearchBar alloc] init];
    [self createSearchBar:searchShowView Cancel:NO];
    searchShowView.hidden = YES;
    
    [self createCoverView];
    [self createAddView];
    
    [self createSearchTableView];
    [self createBackButton];
    
    [self createUnitDep];
}

- (void)createCoverView
{
    coverView = [[UIView alloc] init];
    
    coverView.alpha = 1;
    coverView.hidden = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [coverView addGestureRecognizer:tap];
    coverView.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    [self.view addSubview:coverView];
}

- (void)createAddView
{
    registerOrganizationAddView = [[RegisterOrganizationAddView alloc] init];
    registerOrganizationAddView.hidden = YES;
    registerOrganizationAddView.parent = self;
    registerOrganizationAddView.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    [self.view addSubview:registerOrganizationAddView];
}

- (void)createSearchTableView
{
    searchTable = [[ExperienceTableView alloc] init];
    searchTable.parent = self;
    searchTable.hidden = YES;
    [self.view addSubview:searchTable];
}

- (void)createSaveBtn
{
    UIButton *saveBtn = [NavigationBar createNormalButton:@"确定" target:self action:@selector(save)];
    [naviBar setRightButton:saveBtn];
}

- (void)createUnitDep
{
    noticeLab = [[UILabel alloc] init];
    noticeLab.hidden = YES;
    noticeLab.font = [MedGlobal getMiddleFont];
    noticeLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    noticeLab.numberOfLines = 0;
    [self.view addSubview:noticeLab];
    
    inputView = [[CustomTextField alloc] init];
    inputView.hidden = YES;
    inputView.backgroundColor = [UIColor whiteColor];
    
    inputView.layer.borderWidth = 0.7;
    inputView.layer.borderColor = [ColorUtil getColor:@"E6E6E5" alpha:1].CGColor;
    inputView.font = [MedGlobal getMiddleFont];
    [self.view addSubview:inputView];
    
    exampleLab = [[UILabel alloc] init];
    exampleLab.hidden = YES;
    exampleLab.numberOfLines = 0;
    exampleLab.font = [MedGlobal getMiddleFont];
    exampleLab.textColor = [ColorUtil getColor:@"555555" alpha:1];
    [self.view addSubview:exampleLab];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNaviTitle];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    [self setupView];
    
    [self getMoreData];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGFloat searchBarH = 24;
    CGFloat naviBarH = CGRectGetMaxY(naviBar.frame);
    if (self.orgType == OrgType_Unit) {
        searchShowView.hidden = NO;
        searchShowView.frame = CGRectMake(0, naviBarH + 6, size.width, searchBarH);
        commonTable.frame = CGRectMake(0, CGRectGetMaxY(searchShowView.frame) + 6, size.width, size.height - (CGRectGetMaxY(searchShowView.frame) + 6));
    } else {
        commonTable.frame = CGRectMake(0, naviBarH, size.width, size.height - naviBarH);
    }
    coverView.frame = CGRectMake(0, naviBarH + 40, size.width, size.height - naviBarH - 40);
    [registerOrganizationAddView bringSubviewToFront:self.view];
    [searchTable bringSubviewToFront:self.view];
    [coverView bringSubviewToFront:self.view];
}

- (void)setupOtherView
{
    CGSize size = self.view.frame.size;
    CGFloat naviBarH = CGRectGetMaxY(naviBar.frame);
    CGFloat space = 15;
    CGSize maxSize = CGSizeMake(size.width - space * 2, MAXFLOAT);
    CGSize noticeSize = [noticeLab.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:noticeLab.font} context:nil].size;
    
    noticeLab.frame = CGRectMake(space, naviBarH + space, size.width - space * 2, noticeSize.height);
    inputView.frame = CGRectMake(-1, CGRectGetMaxY(noticeLab.frame) + space, size.width + 2, 55);
    exampleLab.frame = CGRectMake(space, CGRectGetMaxY(inputView.frame) + space, size.width - space * 2, 50);
}

- (void)createNaviTitle
{
    NSString *title = @"";
    if (self.experienceType == ExperienceType_Work) {
        if (self.orgType == OrgType_School) {
            title = @"选择院系";
        } else if (self.orgType == OrgType_Hospital) {
            title = @"选择科室";
        } else if (self.orgType == OrgType_Unit || self.orgType == OrgType_All) {
            title = @"选择部门";
        }
    } else if (self.experienceType == ExperienceType_Edu) {
        title = @"选择学院";
    }
    [naviBar setTopTitle:title];
}

#pragma mark - RegisterOrganizationAddViewDelegate
- (void)searchViewClickAdd
{
    [self clickTap];
    AddDepController *vc = [[AddDepController alloc] init];
    vc.fromVC = self.fromVC;
    vc.parent = self.fromVC;
    NSString *dep = [registerOrganizationAddView getData];
    vc.depName = dep;
    [registerOrganizationAddView setData:@""];
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if ([searchShowView isEqual:searchBar]) {
        [self clickSearch];
        return NO;
    }
    return YES;
}

#pragma mark - click
- (void)clickSearch
{
    registerOrganizationAddView.hidden = NO;
    searchView.hidden = NO;
    [searchView becomeFirstResponder];
    coverView.hidden = NO;
}

- (void)save
{
    if ([inputView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return;
    }
    DepartmentNameDTO *dto = [[DepartmentNameDTO alloc] init];
    dto.name = inputView.text;
    [self.parent updateInfo:@{@"data":@"department", @"department":dto}];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 数据源
- (void)getMoreData
{
    NSInteger num = 0;
    if (isSearch) {
        num = searchArray.count;
    } else {
        num = dataArray.count;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSNumber numberWithInteger:num] forKey:@"from"];
    [param setValue:@1 forKey:@"level"];
    [self getDepartmentDataWithDict:param];
}

- (void)getDepartmentDataWithDict:(NSMutableDictionary *)dict
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:dict];
    [param setValue:self.organDto.organizationID forKey:@"org_id"];
    NSString *orgName = self.organDto.name;
    orgName = [orgName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [param setValue:orgName forKey:@"org_name"];
    [param setValue:@(self.orgType) forKey:@"org_type"];
    NSInteger userType = (self.experienceType == ExperienceType_Work) ? 7 : 8;
    [param setValue:@(userType) forKey:@"user_type"];
    [param setValue:[NSNumber numberWithInt:20] forKey:@"size"];
    [param setValue:[NSNumber numberWithInt:MethodType_Degree_DepSearch] forKey:@"method"];
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager getData:param success:^(NSArray *JSON) {
        if (JSON.count == 0 && !isSearch && self.experienceType == ExperienceType_Work) {
            [self showDep];
        } else {
            //只有其他（部门时才有搜索添加）
            if (self.orgType == OrgType_Unit) {
                searchShowView.hidden = NO;
            }
            if (isSearch) {
                [searchArray addObjectsFromArray:JSON];
                [searchTable setInfo:JSON];
            } else {
                [dataArray addObjectsFromArray:JSON];
                [commonTable setInfo:JSON];
            }
            [self setupView];
        }
        [LoadingView showProgress:NO inView:self.view];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"网络错误，请重试" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
}

- (void)showDep
{
    [self createSaveBtn];
    
    noticeLab.hidden = NO;
    inputView.hidden = NO;
    exampleLab.hidden = NO;
    
    registerOrganizationAddView.hidden = YES;
    commonTable.hidden = YES;
    searchShowView.hidden = YES;
    coverView.hidden = YES;
    
    [naviBar setTopTitle:@"创建新的部门"];
    noticeLab.text = @"您创建的部门需要您身份认证后，才能直接在该单位的部门列表中显示";
    if (self.departmentName.length > 0) {
        inputView.text = self.departmentName;
        exampleLab.text = @"请填写规范的部门全称 如： “卫生应急办公室”";
    } else {
        inputView.placeholder = @"请填写规范的部门全称";
        exampleLab.text = @"如： “卫生应急办公室”";
    }
    
    [self setupOtherView];
}

#pragma mark - ExperienceTableViewDelegate
- (void)selectTitle:(id)dto
{
    if ([dto isKindOfClass:[DepartmentNameDTO class]]) {
        DepartmentNameDTO *idto = (DepartmentNameDTO *)dto;
        if (!idto.hasChild) { // 没有子部门的时候
            [self.parent updateInfo:@{@"data":@"department", @"department":idto}];
            [self clickBack];
        } else {
            ExperienceDepSecondController *dep = [[ExperienceDepSecondController alloc] init];
            dep.parent = self.parent;
            dep.fromVC = self.fromVC;
            dep.departDto = idto;
            dep.organDto = self.organDto;
            dep.orgType = self.orgType;
//            dep.experienceType = self.experienceType;
            [self.navigationController pushViewController:dep animated:YES];
        }
    }
}

#pragma mark - touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}

@end
