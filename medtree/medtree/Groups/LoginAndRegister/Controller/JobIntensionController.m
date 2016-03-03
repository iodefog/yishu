//
//  JobIntensionController.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/9.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "JobIntensionController.h"
#import "PairDTO.h"
#import "HomeJobChannelInterestTableViewCell.h"
#import "HomeJobChannelInterestDetialViewController.h"
#import "HomeJobChannelIntersetViewController.h"
#import "MyResumeViewController.h"
#import <MBProgressHUD.h>
#import <InfoAlertView.h>
#import <JSONKit.h>
#import "ChannelManager.h"
#import "NSString+Extension.h"

@interface JobIntensionController ()

@property (nonatomic, strong) NSMutableArray<PairDTO *> *dataArray;
@property (nonatomic, strong) NSArray *eduactionTitleArray;
@property (nonatomic, strong) NSArray *eduactionIDArray;
@property (nonatomic, strong) NSArray *workExperienceTitleArray;
@property (nonatomic, strong) NSArray *workExperienceIDArray;
@property (nonatomic, strong) NSArray *unitNatureTitleArray;
@property (nonatomic, strong) NSArray *unitNatureIDArray;
@property (nonatomic, strong) NSArray *unitSizeTitleArray;
@property (nonatomic, strong) NSArray *unitSizeIDArray;
@property (nonatomic, strong) NSArray *unitLevelTitleArray;
@property (nonatomic, strong) NSArray *unitLevelIDArray;

@property (nonatomic, strong) NSMutableDictionary *parmasDictionary;
@property (nonatomic, copy) NSString *functionLevelTwoString;

@end

@implementation JobIntensionController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.tableView.registerCells = @{@"PairDTO" : [HomeJobChannelInterestTableViewCell class]};
    self.enableHeader = NO;
    self.enableFooter = NO;
    
    [self createBackButton];
    [self createRightButton];
}

- (void)createRightButton
{
    UIButton *button = [NavigationBar createRightButton:@"保存" target:self action:@selector(clickSave)];
    [naviBar setRightButton:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _parmasDictionary = [[NSMutableDictionary alloc] init];
    
    [naviBar setTopTitle:@"求职意向"];
    self.tableView.bounces = NO;
    [self setupData];
    [self setupView];
}

- (void)setupData
{
    NSArray *titleArray = @[ @"所属地区", @"职能类别", @"学历要求", @"工作经验", @"单位性质", @"单位规模" ];

    for (int i = 0; i < titleArray.count; i ++) {
        PairDTO *dto = [[PairDTO alloc] init];
        dto.label = titleArray[i];
        dto.key = @"不限";
        
        [self.dataArray addObject:dto];
    }
    
    [self.tableView setData:@[self.dataArray]];
}

- (void)setupView
{
    CGSize size = self.view.frame.size;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), size.width, size.height - CGRectGetMaxY(naviBar.frame));
}

#pragma mark - click
- (void)clickSave
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = @{ @"method" : @(MethodTypeJobChannelPostinterests) }.mutableCopy;
    [params addEntriesFromDictionary:[self params]];
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([JSON[@"success"] boolValue]) {
            [InfoAlertView showInfo:@"保存成功" inView:self.view duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    } failure:^(NSError *error, id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)clickCell:(PairDTO *)dto index:(NSIndexPath *)index
{
    NSArray *titleArray = nil;
    
    HomeJobChannelInterestDetialViewControllerType type;
    switch (index.row) {
        case 0:
            type = HomeJobChannelInterestDetialViewControllerTypeRegionMultiSelection;
            break;
        case 1: {
            __weak __typeof(self) weakSelf = self;
            HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
            vc.type = HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection;
            vc.selectedFunctionLevelOneString = self.parmasDictionary[@"1"];
            vc.selectedFunctionLevelTwoString = self.functionLevelTwoString;
            
            vc.completeBlock = ^(NSString *showString, NSString *levelOnestring, NSString *levelTwoString){
                __strong __typeof(self) strongSelf = weakSelf;
                dto.key = showString;
                strongSelf.functionLevelTwoString = levelTwoString;
                [strongSelf.parmasDictionary setObject:levelOnestring forKey:[NSString stringWithFormat:@"%@", @(index.row)]];
                [strongSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
            
            return;
            break;
        }
        case 2:
            type = HomeJobChannelInterestDetialViewControllerTypeEducation;
            titleArray = self.eduactionTitleArray;
            break;
        case 3:
            type = HomeJobChannelInterestDetialViewControllerTypeWorkExperience;
            titleArray = self.workExperienceTitleArray;
            break;
        case 4:
            type = HomeJobChannelInterestDetialViewControllerTypeUnitNatureMultiSelection;
            titleArray = self.unitNatureTitleArray;
            break;
        case 5:
            type = HomeJobChannelInterestDetialViewControllerTypeUnitSize;
            titleArray = self.unitSizeTitleArray;
            break;
        default:
            break;
    }
    
    HomeJobChannelInterestDetialViewController *vc = [[HomeJobChannelInterestDetialViewController alloc] init];
    vc.titleArray = titleArray;
    vc.title = dto.label;
    vc.type = type;
    vc.completeBlock = ^(NSString *string, NSArray *indexArray) {
        dto.key = string;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - getter & setter
- (NSDictionary *)params
{
    NSString *province = [[self.dataArray firstObject].key stringByReplacingOccurrencesOfString:@"，" withString:@" "];
    
    NSString *functionlevelOne = @"不限";
    NSString *functionLevelOneString = self.parmasDictionary[@"1"];
    if (functionLevelOneString) {
        functionlevelOne = functionLevelOneString;
    }
    
    NSInteger education = 0;
    NSArray *selectEducation = self.parmasDictionary[@"2"];
    if (selectEducation) {
        education = [[selectEducation firstObject] integerValue];
    }
    
    NSInteger workExperience = 0;
    NSArray *selectWorkExperience = self.parmasDictionary[@"3"];
    if (selectWorkExperience) {
        workExperience = [[selectWorkExperience firstObject] integerValue];
    }
    
    NSString *unitNature = @"0";
    NSArray *selectUnitNature = self.parmasDictionary[@"4"];
    if (selectUnitNature) {
        __block NSMutableString *str = [NSMutableString new];
        [selectUnitNature enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendFormat:@"%@", obj];
            if (idx < selectUnitNature.count - 1) {
                [str appendString:@" "];
            }
        }];
        unitNature = [str copy];
    }
    
    NSInteger unitSize = 0;
    NSArray *selectUnintSize = self.parmasDictionary[@"5"];
    if (selectUnintSize) {
        unitSize = [[selectUnintSize firstObject] integerValue];
    }
    
    NSDictionary *params = @{ @"provinces" : province,
                              @"job_property_lev1" : functionlevelOne,
                              @"job_property_lev2" : self.functionLevelTwoString ? : @"不限",
                              @"education" : @(education),
                              @"experience_time" : @(workExperience),
                              @"enterprise_type" : unitNature,
                              @"enterprise_scale" : @(unitSize) };
    
    return params;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSArray *)eduactionTitleArray
{
    if (!_eduactionTitleArray) {
        NSString *string = @"不限，大中专及以上，本科及以上，硕士及以上，博士及以上，其他";
        
        _eduactionTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _eduactionTitleArray;
}

- (NSArray *)eduactionIDArray
{
    if (!_eduactionIDArray) {
        _eduactionIDArray = @[ @"" ];
    }
    return _eduactionIDArray;
}

- (NSArray *)workExperienceTitleArray
{
    if (!_workExperienceTitleArray) {
        NSString *string = @"不限，应届毕业生，1年以上，2年以上，3年以上，5年以上，10年以上";
        
        _workExperienceTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _workExperienceTitleArray;
}

- (NSArray *)workExperienceIDArray
{
    if (!_workExperienceIDArray) {
        _workExperienceIDArray = @[];
    }
    return _workExperienceIDArray;
}

- (NSArray *)unitNatureTitleArray
{
    if (!_unitNatureTitleArray) {
        NSString *string = @"不限，公立医院，民营医院，药械企业，生物企业，科研院所，其他";
        
        _unitNatureTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitNatureTitleArray;
}

- (NSArray *)unitNatureIDArray
{
    if (!_unitNatureIDArray) {
        _unitNatureIDArray = @[];
    }
    return _unitNatureIDArray;
}

- (NSArray *)unitSizeTitleArray
{
    if (!_unitSizeTitleArray) {
        NSString *string = @"不限，1-400人，400人以上，1000人以上，2000人以上，4000人以上";
        
        _unitSizeTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitSizeTitleArray;
}

- (NSArray *)unitSizeIDArray
{
    if (!_unitSizeIDArray) {
        _unitSizeIDArray = @[ ];
    }
    return _unitSizeIDArray;
}

- (NSArray *)unitLevelTitleArray
{
    if (!_unitLevelTitleArray) {
        NSString *string = @"不限，三级甲等，三级乙等，二级甲等，二级二等，一级，其他";
        
        _unitLevelTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitLevelTitleArray;
}

- (NSArray *)unitLevelIDArray
{
    if (!_unitLevelIDArray) {
        _unitLevelIDArray = @[];
    }
    return _unitLevelIDArray;
}

@end
