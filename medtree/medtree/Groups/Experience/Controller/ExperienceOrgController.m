//
//  ExperienceOrgController.m
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceOrgController.h"
#import "SearchBarEx.h"
#import "OrganizationNameDTO.h"
#import "RegisterOrganizationButtonView.h"
#import "ColorUtil.h"
#import "DepartmentNameDTO.h"
#import "ExperienceDetailController.h"
#import "RegisterController.h"
#import "InfoAlertView.h"
#import "DegreeManager.h"
#import "RegisterOrganizationAddView.h"
#import "MedGlobal.h"
#import "AddOrgController.h"
#import "NavigationController.h"
#import "ExperienceDTO.h"
#import "JSONKit.h"
#import "ProvinceDTO.h"
#import "ImproveController.h"

@interface ExperienceOrgController ()<RegisterOrganizationButtonViewDelegate, ExperienceTableViewDelegate, RegisterOrganizationAddViewDelegate>
{
    UISearchBar                     *searchShowView;
    NSInteger                       showOrgDataIndex;
    BOOL                            isShowSelectBtn;
    /** 选择组织类型选择view */
    RegisterOrganizationButtonView  *buttonView;
    
    ExperienceTableView             *hospitalTable;
    ExperienceTableView             *unitTable;
    ExperienceTableView             *schoolTable;
    
    NSMutableArray                  *hospitArray;
    NSMutableArray                  *schoolArray;
    NSMutableArray                  *unitArray;
}

@end

@implementation ExperienceOrgController

- (void)initConfig
{
    hospitArray = [[NSMutableArray alloc] init];
    schoolArray = [[NSMutableArray alloc] init];
    unitArray = [[NSMutableArray alloc] init];
    
    isSearch = NO;
    
    [self createBarView];
    [self createTablesView];
}

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"请选择"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    
    [self initConfig];
    
    [self createBackButton];
    [self createBarView];
    [self createTablesView];
    
    searchShowView = [[UISearchBar alloc] init];
    [self createSearchBar:searchShowView Cancel:NO];
    [self createCoverView];
    [self createAddView];
    
    typeTitle = @"organization";
    [self createSearchView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupData];
    [self setupView];
    
    if (self.experienceType == ExperienceType_Work) {
        [self clickButtonIdx:0];
    } else {
        [self clickButtonIdx:1];
    }
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    CGFloat height = 40;
    CGFloat searchBarH = 24;
    CGFloat searchBgH = searchBarH + 6 * 2;
    
    if (isShowSelectBtn ||(self.experienceType != ExperienceType_Edu && [self.fromVC isKindOfClass:[ExperienceDetailController class]])) {
        buttonView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, height);
        searchShowView.frame = CGRectMake(0, CGRectGetMaxY(buttonView.frame) + 6, size.width, searchBarH);
    } else {
        searchShowView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame) + 6, size.width, searchBarH);
    }
    
    CGFloat hosptialTableY = CGRectGetMaxY(searchShowView.frame) + 6;
    
    if ([self.fromVC isKindOfClass:[RegisterController class]] && self.orgType == OrgType_Hospital) { // 注册里的医生
        hospitalTable.frame = CGRectMake(0, hosptialTableY, size.width, size.height - hosptialTableY);
    } else {
        hospitalTable.frame = CGRectMake(0, hosptialTableY, size.width, size.height-CGRectGetMaxY(naviBar.frame) - height - searchBgH);
    }
    
    if (self.experienceType == ExperienceType_Edu) {
        schoolTable.frame = CGRectMake(0, hosptialTableY, size.width, size.height - hosptialTableY);
    } else if (self.experienceType == ExperienceType_Work) {
        schoolTable.frame = hospitalTable.frame;
    }
    unitTable.frame = hospitalTable.frame;
    coverView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame) + 40, size.width, size.height-CGRectGetMaxY(naviBar.frame) - 40);
    
    [registerOrganizationAddView bringSubviewToFront:self.view];
    [searchTable bringSubviewToFront:self.view];
    [coverView bringSubviewToFront:self.view];
}

- (void)setupData
{
    if (self.orgType == OrgType_Unit || self.orgType == OrgType_All) {
        isShowSelectBtn = YES;
    }
    
    if (self.orgType == OrgType_Hospital) {
        showOrgDataIndex = 0;
    } else if (self.orgType == OrgType_School) {
        showOrgDataIndex = 1;
    } else if (self.orgType == OrgType_Unit) {
        showOrgDataIndex = 2;
    }
    
    searchShowView.placeholder = @"搜索|添加";
    NSString *title = @"";
    if ([self.fromVC isKindOfClass:[RegisterController class]] || [self.fromVC isKindOfClass:[ImproveController class]]) {
        if (self.orgType == OrgType_Hospital) {
            title = @"选择医院";
            searchView.placeholder = @"搜索|添加医院";
            
            buttonView.hidden = YES;
            searchView.hidden = YES;
            
            schoolTable.hidden = YES;
            hospitalTable.hidden = NO;
            unitTable.hidden = YES;
        } else if (self.orgType == OrgType_School) {
            title = @"选择学校";
            searchView.placeholder = @"搜索|添加学校";
            
            buttonView.hidden = YES;
            searchView.hidden = YES;
            
            schoolTable.hidden = NO;
            hospitalTable.hidden = YES;
            unitTable.hidden = YES;
        } else if (self.orgType == OrgType_Unit || self.orgType == OrgType_All) {
            title = @"选择单位";
            searchView.placeholder = @"搜索|添加单位";
            
            buttonView.hidden = NO;
            searchView.hidden = YES;
            
            schoolTable.hidden = YES;
            hospitalTable.hidden = NO;
            unitTable.hidden = YES;
        }
    } else if ([self.fromVC isKindOfClass:[ExperienceDetailController class]]) {
        if (self.experienceType == ExperienceType_Edu) {
            title = @"选择学校";
            searchView.placeholder = @"搜索|添加学校";
            
            buttonView.hidden = YES;
            searchView.hidden = YES;
            
            schoolTable.hidden = NO;
            hospitalTable.hidden = YES;
            unitTable.hidden = YES;
        } else {
            title = @"选择单位";
            searchView.placeholder = @"搜索|添加单位";
            
            buttonView.hidden = NO;
            searchView.hidden = YES;
            
            schoolTable.hidden = YES;
            hospitalTable.hidden = NO;
            unitTable.hidden = YES;
        }
    }
    [naviBar setTopTitle:title];
}

- (void)createCoverView
{
    coverView = [[UIView alloc] init];
    
    coverView.alpha = 1;
    coverView.hidden = YES;
    coverView.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    [self.view addSubview:coverView];
}

- (void)createBarView
{
    buttonView = [[RegisterOrganizationButtonView alloc] init];
    buttonView.parent = self;
    buttonView.hidden = YES;
    [self.view addSubview:buttonView];
}

- (void)createTablesView
{
    hospitalTable = [[ExperienceTableView alloc] init];
    hospitalTable.parent = self;
    hospitalTable.hidden = NO;
    [self.view addSubview:hospitalTable];
    
    unitTable = [[ExperienceTableView alloc] init];
    unitTable.parent = self;
    unitTable.hidden = YES;
    [self.view addSubview:unitTable];
    
    schoolTable = [[ExperienceTableView alloc] init];
    schoolTable.parent = self;
    schoolTable.hidden = YES;
    [self.view addSubview:schoolTable];
}

- (void)createAddView
{
    registerOrganizationAddView = [[RegisterOrganizationAddView alloc] init];
    registerOrganizationAddView.hidden = YES;
    registerOrganizationAddView.parent = self;
    registerOrganizationAddView.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    [self.view addSubview:registerOrganizationAddView];
}

- (void)createSearchView
{
    searchTable = [[ExperienceTableView alloc] init];
    searchTable.parent = self;
    searchTable.hidden = YES;
    [self.view addSubview:searchTable];
}

#pragma mark - SearchBarExDelegate
- (void)searchBecomeFirstResponder
{
    coverView.hidden = NO;
}

- (void)searchViewClickAdd
{
    [self clickTap];
    AddOrgController *vc = [[AddOrgController alloc] init];
    vc.fromVC = self.fromVC;
    vc.parent = self.fromVC;
    vc.expType = self.experienceType;
    vc.province = self.province;
    vc.orgName = [registerOrganizationAddView getData];
    vc.orgType = self.orgType;
    vc.userType = self.userType;
    [registerOrganizationAddView setData:@""];
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - click
- (void)clickSearch
{
    registerOrganizationAddView.hidden = NO;
    searchView.hidden = NO;
    [searchView becomeFirstResponder];
    coverView.hidden = NO;
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

#pragma mark - RegisterOrganizationButtonViewDelegate
- (void)clickButtonIdx:(NSInteger)number
{
    if (number == 0) {
        showOrgDataIndex = 0;
        self.orgType = OrgType_Hospital;
    } else if (number == 1) {
        showOrgDataIndex = 1;
        self.orgType = OrgType_School;
    } else {
        showOrgDataIndex = 2;
        self.orgType = OrgType_Unit;
    }
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    if (showOrgDataIndex == 0) {
        hospitalTable.hidden = NO;
        unitTable.hidden = YES;
        schoolTable.hidden = YES;
        [param setValue:@0 forKey:@"from"];
        [param setObject:[NSNumber numberWithInt:OrgType_Hospital] forKey:@"type"];
        if (hospitArray.count == 0) {
            [self getOrganizationDataWithDict:param];
        }
    } else if (showOrgDataIndex == 1) {
        hospitalTable.hidden = YES;
        unitTable.hidden = YES;
        schoolTable.hidden = NO;
        [param setValue:@0 forKey:@"from"];
        [param setObject:[NSNumber numberWithInt:OrgType_School] forKey:@"type"];
        if (schoolArray.count == 0) {
            [self getOrganizationDataWithDict:param];
        }
    } else if (showOrgDataIndex == 2) {
        hospitalTable.hidden = YES;
        unitTable.hidden = NO;
        schoolTable.hidden = YES;
        [param setValue:@0 forKey:@"from"];
        [param setObject:[NSNumber numberWithInt:OrgType_Unit] forKey:@"type"];
        if (unitArray.count == 0) {
            [self getOrganizationDataWithDict:param];
        }
    }
}

#pragma mark - 数据源
- (void)getOrganizationDataWithDict:(NSMutableDictionary *)dict
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:dict];
    NSString *name = self.province.name;
    name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [param setValue:name forKey:@"province"];
    [param setValue:[NSNumber numberWithInt:MethodType_Degree_OrgSearch] forKey:@"method"];
    [param setValue:[NSNumber numberWithInt:20] forKey:@"size"];
    if ([self.fromVC isKindOfClass:[RegisterController class]] && self.orgType == OrgType_Hospital) { // 注册里的医生
        [param setValue:@(OrgType_Hospital) forKey:@"type"];
    }
    if (self.experienceType == ExperienceType_Edu) {    // 学生
        [param setValue:@(OrgType_School) forKey:@"type"];
    }
    [ServiceManager getData:param success:^(id JSON) {
        NSLog(@"organization -----  %@",JSON);
        NSArray *array = JSON;
        if (isSearch) {
            if ([param[@"from"] integerValue] == 0) {
                [searchArray removeAllObjects];
            }
            [searchArray addObjectsFromArray:array];
        } else {
            if (showOrgDataIndex == 0) {
                [hospitArray addObjectsFromArray:array];
            } else if (showOrgDataIndex == 1) {
                [schoolArray addObjectsFromArray:array];
            } else if (showOrgDataIndex == 2) {
                [unitArray addObjectsFromArray:array];
            }
        }
        
        if (isSearch) {
            if ([param[@"from"] integerValue] == 0) {
                [searchTable reloadArray];
            }
            [searchTable setInfo:array];
        } else {
            if (showOrgDataIndex == 0) {
                hospitalTable.hidden = NO;
                [hospitalTable setInfo:array];
            } else if (showOrgDataIndex == 1) {
                schoolTable.hidden = NO;
                [schoolTable setInfo:array];
            } else if (showOrgDataIndex == 2) {
                unitTable.hidden = NO;
                [unitTable setInfo:array];
            }
        }
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[result objectForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }
        }
    }];
}

- (void)getMoreData
{
    NSInteger num = 0;
    if (isSearch) {
        num = searchArray.count;
    } else {
        if (showOrgDataIndex == 0) {
            num = hospitArray.count;
        }else if (showOrgDataIndex == 1) {
            num = schoolArray.count;
        } else if (showOrgDataIndex == 2) {
            num = unitArray.count;
        }
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:@(num) forKey:@"from"];
    [param setObject:@(self.orgType) forKey:@"type"];
    [self getOrganizationDataWithDict:param];
}

#pragma mark - ExperienceTableViewDelegate
- (void)selectTitle:(id)dto
{
    if ([dto isKindOfClass:[OrganizationNameDTO class]]) {
        OrganizationNameDTO *idto = (OrganizationNameDTO *)dto;
        idto.province = _province;
        idto.type = self.orgType;
        
        if ([self.parent respondsToSelector:@selector(updateInfo:)]) {
            [self.parent updateInfo:@{@"data":@"organization",@"organization":idto}];
        }

        [self.navigationController popToViewController:self.fromVC animated:YES];
    }
}

@end
