//
//  HomeJobChannelIntersetViewController.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelIntersetViewController.h"
#import "PairDTO.h"
#import "HomeJobChannelInterestTableViewCell.h"
#import "HomeJobChannelInterestDetialViewController.h"
#import "ChannelManager.h"
#import <MBProgressHUD.h>
#import <JSONKit.h>
#import <InfoAlertView.h>
#import "HomeJobChannelViewController.h"

@interface HomeJobChannelIntersetViewController () <BaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray<PairDTO *> *dataArray;

@property (nonatomic, copy) NSArray *eduactionTitleArray;
@property (nonatomic, copy) NSArray *workExperienceTitleArray;
@property (nonatomic, copy) NSArray *unitNatureTitleArray;
@property (nonatomic, copy) NSArray *unitSizeTitleArray;
@property (nonatomic, copy) NSArray *unitLevelTitleArray;
@property (nonatomic, copy) NSArray *publishTimeTitleArray;
@property (nonatomic, copy) NSArray *professionalQualificationsTitleArray; //职称要求
@property (nonatomic, copy) NSArray *salaryTitleArray;

@property (nonatomic, strong) NSMutableDictionary *parmasDictionary;
@property (nonatomic, copy) NSString *functionLevelTwoString;

@property (nonatomic, strong) UIView *footerCleanView;

@end

@implementation HomeJobChannelIntersetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _dataArray = [[NSMutableArray alloc] init];
    _parmasDictionary = [[NSMutableDictionary alloc] init];
    
    NSArray *titleArray = nil;
    
    if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
        titleArray = @[ @"所属地区", @"职能类别", @"学历要求", @"工作经验", @"单位性质", @"单位规模" ];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilter) {
        titleArray = @[ @"发布时间", @"所属地区", @"经验要求", @"职能类别", @"职称要求", @"单位类型", @"单位规模", @"单位级别", @"月薪范围", @"学历要求" ];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeUnitFilter) {
        titleArray = @[ @"所属地区", @"单位类型", @"单位规模", @"单位级别" ];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb) {
        titleArray = @[ @"发布时间", @"所属地区", @"经验要求", @"职能类别", @"职称要求", @"月薪范围", @"学历要求" ];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection ||
               self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection) {
        [self showLoadingView];
        [self founctionLevelOneRequest];
        
        return;
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
        titleArray = self.professionalQualificationsTitleArray;
    }
    
    NSInteger i = 0;
    for (NSString *title in titleArray) {
        PairDTO *dto = [[PairDTO alloc] init];
        dto.label = title;
        dto.key = @"不限";
        
        if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
            if (i == 6 - self.selectedProfessionalQualifiactionsIndex / 10) {
                dto.isSelect = YES;
                dto.key = self.selectedProfessionalQualifiactionsString;
            }
        }
        
        if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications && i == 0) {
            dto.key = @"";
            dto.accessType = 1;
        }
        
        [self.dataArray addObject:dto];
        i ++;
    }
    
    if (![self.dataArray[1].key isEqualToString:@"不限"]) {
        self.dataArray[2].key = self.dataArray[1].key;
        self.dataArray[2].isSelect = YES;
        self.dataArray[1].key = @"不限";
        self.dataArray[1].isSelect = NO;
    } else if (![self.dataArray[2].key isEqualToString:@"不限"]) {
        self.dataArray[1].key = self.dataArray[2].key;
        self.dataArray[1].isSelect = YES;
        self.dataArray[2].key = @"不限";
        self.dataArray[2].isSelect = NO;
    }

    [self.tableView setData:@[ self.dataArray ]];
    
    if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
        [self getMyInterestRequest];
    }
}

- (void)createUI
{
    [super createUI];
    
    if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
        [self createBackButton];
        
        [naviBar setTopTitle:@"工作意向"];
        [naviBar setLeftButton:[NavigationBar createNormalButton:@"取消"
                                                          target:self
                                                          action:@selector(cancleButton:)]];

        [naviBar setRightButton:[NavigationBar createNormalButton:@"保存"
                                                           target:self
                                                           action:@selector(saveButtonAction:)]];

    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilter ||
               self.type == HomeJobChannelIntersetViewControllerTypeUnitFilter ||
               self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb) {
        [naviBar setTopTitle:@"筛选"];
        [naviBar setLeftButton:[NavigationBar createNormalButton:@"取消"
                                                          target:self
                                                          action:@selector(cancleButton:)]];
        [naviBar setRightButton:[NavigationBar createNormalButton:@"确定"
                                                           target:self
                                                           action:@selector(sureButtonAction:)]];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection ||
               self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection) {
        [self createBackButton];
        
        [naviBar setTopTitle:@"职能类别"];
        [naviBar setRightButton:[NavigationBar createNormalButton:@"保存"
                                                           target:self
                                                           action:@selector(saveButtonAction:)]];
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
        [self createBackButton];
        
        [naviBar setTopTitle:@"职称要求"];
    }
    
    self.tableView.registerCells = @{ @"PairDTO" : [HomeJobChannelInterestTableViewCell class] };
    self.enableHeader = NO;
    self.enableFooter = NO;
    
    if (!(self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications ||
          self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection ||
          self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection)) {
        self.tableView.tableFooterView = self.footerCleanView;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(PairDTO *)dto index:(NSIndexPath *)index
{
    NSArray *titleArray = nil;
    
    HomeJobChannelInterestDetialViewControllerType type;
    if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
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
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilter) {
        switch (index.row) {
            case 0:
                type = HomeJobChannelInterestDetialViewControllerTypePublishTime;
                titleArray = self.publishTimeTitleArray;
                break;
            case 1:
                type = HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection;
                break;
            case 2:
                type = HomeJobChannelInterestDetialViewControllerTypeWorkExperience;
                titleArray = self.workExperienceTitleArray;
                break;
            case 3: {
                __weak __typeof(self) weakSelf = self;
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection;
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
            case 4: {
                __weak __typeof(self) weakSelf = self;
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeProfessionalQualifications;
                vc.completeBlock = ^(NSString *showString, NSString *levelOnestring, NSString *levelTwoString){
                    __strong __typeof(self) strongSelf = weakSelf;
                    dto.key = showString;
                    strongSelf.functionLevelTwoString = levelTwoString;
                    [strongSelf.parmasDictionary setObject:@[ levelOnestring ] forKey:[NSString stringWithFormat:@"%@", @(index.row)]];
                    [strongSelf.tableView reloadData];
                };
                vc.selectedProfessionalQualifiactionsIndex = [[self.parmasDictionary[@"4"] firstObject] integerValue];
                vc.selectedProfessionalQualifiactionsString = dto.key;

                [self.navigationController pushViewController:vc animated:YES];
                return;
                
                break;
            }
            case 5:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitNatureSingalSelection;
                titleArray = self.unitNatureTitleArray;
                break;
            case 6:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitSize;
                titleArray = self.unitSizeTitleArray;
                break;
            case 7:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitLevel;
                titleArray = self.unitLevelTitleArray;
                break;
            case 8:
                type = HomeJobChannelInterestDetialViewControllerTypeSalary;
                titleArray = self.salaryTitleArray;
                break;
            case 9:
                type = HomeJobChannelInterestDetialViewControllerTypeEducation;
                titleArray = self.eduactionTitleArray;
                break;
            default:
                break;
        }
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb) {
        switch (index.row) {
            case 0:
                type = HomeJobChannelInterestDetialViewControllerTypePublishTime;
                titleArray = self.publishTimeTitleArray;
                break;
            case 1:
                type = HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection;
                break;
            case 2:
                type = HomeJobChannelInterestDetialViewControllerTypeWorkExperience;
                titleArray = self.workExperienceTitleArray;
                break;
            case 3: {
                __weak __typeof(self) weakSelf = self;
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection;
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
            case 4: {
                __weak __typeof(self) weakSelf = self;
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeProfessionalQualifications;
                vc.completeBlock = ^(NSString *showString, NSString *levelOnestring, NSString *levelTwoString){
                    __strong __typeof(self) strongSelf = weakSelf;
                    dto.key = showString;
                    strongSelf.functionLevelTwoString = levelTwoString;
                    [strongSelf.parmasDictionary setObject:@[ levelOnestring ] forKey:[NSString stringWithFormat:@"%@", @(index.row)]];
                    [strongSelf.tableView reloadData];
                };
                vc.selectedProfessionalQualifiactionsIndex = [[self.parmasDictionary[@"4"] firstObject] integerValue];
                vc.selectedProfessionalQualifiactionsString = dto.key;
                [self.navigationController pushViewController:vc animated:YES];
                return;
                
                break;
            }
            case 5:
                type = HomeJobChannelInterestDetialViewControllerTypeSalary;
                titleArray = self.salaryTitleArray;
                break;
            case 6:
                type = HomeJobChannelInterestDetialViewControllerTypeEducation;
                titleArray = self.eduactionTitleArray;
                break;
            default:
                break;
        }
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection) {
        type = HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoMultiSelection;
        
        if ([dto.label isEqualToString:@"不限"]) {
            self.completeBlock(@"不限", @"不限", @"不限");
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection) {
        type = HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoSingalSelection;
        if ([dto.label isEqualToString:@"不限"]) {
            self.completeBlock(@"不限", @"不限", @"不限");
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeUnitFilter) {
        switch (index.row) {
            case 0:
                type = HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection;
                break;
            case 1:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitNatureSingalSelection;
                titleArray = self.unitNatureTitleArray;
                break;
            case 2:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitSize;
                titleArray = self.unitSizeTitleArray;
                break;
            case 3:
                type = HomeJobChannelInterestDetialViewControllerTypeUnitLevel;
                titleArray = self.unitLevelTitleArray;
                break;
            default:
                break;
        }
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
        type = HomeJobChannelInterestDetialViewControllerTypeProfessionalQualifications;
        switch (index.row) {
            case 0:
                titleArray = @[ @"不限" ];
                self.completeBlock(@"不限",@"0", nil);
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
                break;
            case 1:
                titleArray = @[ @"主任医师", @"副主任医师", @"主治医师", @"住院医师" ];
                break;
            case 2:
                titleArray = @[ @"主任护师", @"副主任护师", @"主管护师", @"护师", @"护士" ];
                break;
            case 3:
                titleArray = @[ @"主任技师", @"副主任技师", @"主管技师", @"技师", @"技士" ];
                break;
            case 4:
                titleArray = @[ @"主任药师", @"副主任药师",  @"主管药师", @"药师", @"药士"];
                break;
            default:
                break;
        }
    }
    
    __weak __typeof(self) weakSelf = self;
    HomeJobChannelInterestDetialViewController *vc = [[HomeJobChannelInterestDetialViewController alloc] init];
    vc.titleArray = titleArray;
    vc.title = dto.label;
    vc.type = type;
    
    if (type == HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection ||
        type == HomeJobChannelInterestDetialViewControllerTypeRegionMultiSelection) {
        vc.selectedProvinceString = dto.key;
    }
    
    if (self.type == HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
        vc.completeBlock = ^(NSString *string, NSArray *indexArray) {
            __strong __typeof(self) strongSelf = weakSelf;
            strongSelf.completeBlock(string, [NSString stringWithFormat:@"%@", indexArray.firstObject], nil);
            [strongSelf.navigationController popToRootViewControllerAnimated:YES];
        };
        vc.lastLevelIndex = index.row;
        vc.selectedProvinceString = dto.key;
    } else {
        vc.completeBlock = ^(NSString *string, NSArray *indexArray) {
            __strong __typeof(self) strongSelf = weakSelf;
            
            dto.key = string;
            [strongSelf.parmasDictionary setObject:indexArray forKey:[NSString stringWithFormat:@"%@", @(index.row)]];
            [strongSelf.tableView reloadData];
        };
    }
    if(type == HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoMultiSelection ||
       type == HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoSingalSelection) {
        vc.functionLevelOneID = [dto.value integerValue];
        vc.selectedFunctionLevelTwoString = dto.key;
    }
    
    if (self.type != HomeJobChannelIntersetViewControllerTypeProfessionalQualifications) {
        vc.selectedIndexArray = self.parmasDictionary[[NSString stringWithFormat:@"%@", @(index.row)]] ?: @[ @"0" ] ;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - response event -

- (void)saveButtonAction:(UIButton *)button
{
    if (self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneSingleSelection ||
        self.type == HomeJobChannelIntersetViewControllerTypeFunctionLevelOneMultiSelection) {
        if (self.completeBlock) {
            NSMutableString *levelOneString = [NSMutableString new];
            NSMutableString *levelTwoString = [NSMutableString new];
            NSMutableString *showString = [NSMutableString new];
            
            for (PairDTO *dto in self.dataArray) {
                if (![dto.label isEqualToString:@"不限"]) {
                    if (![dto.key isEqualToString:@"不限"]) {
                        [levelOneString appendFormat:@"%@ ", [dto.label stringByReplacingOccurrencesOfString:@"，" withString:@" "]];
                        [levelTwoString appendFormat:@"%@|", [dto.key stringByReplacingOccurrencesOfString:@"，" withString:@" "]];
                        
                        [showString appendFormat:@"%@，", dto.key];
                    }
                }
            }
            
            if (levelOneString.length == 0) {
                [levelOneString appendFormat:@"不限"];
                [levelTwoString appendFormat:@"不限|"];
                [showString appendFormat:@"不限，"];
            }
            
            self.completeBlock([[showString copy] substringToIndex:showString.length - 1], [levelOneString copy], [[levelTwoString copy] substringToIndex:levelTwoString.length - 1]);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self setMyInterestRequest];
}

- (void)cancleButton:(UIButton *)button
{
    if (self.closeBlock) {
        self.closeBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sureButtonAction:(UIButton *)button
{
    if (self.sureBlock) {
        self.sureBlock([self params]);
    }
    
    if (self.type != HomeJobChannelIntersetViewControllerTypeEmploymentFilter) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cleanButtonAction:(UIButton *)button
{
    for (PairDTO *dto in self.dataArray) {
        dto.key = ![dto.key isEqualToString:@""] ? @"不限" : @"" ;
    }
    
    [self.parmasDictionary removeAllObjects];
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - network request -

- (void)founctionLevelOneRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeJobChannelFunctionLevelOne) };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        [self hideLoadingView];
        
        NSArray *selectedLevelOneArray = [self.selectedFunctionLevelOneString componentsSeparatedByString:@" "];
        NSArray *selectedLevelTwoArray = [self.selectedFunctionLevelTwoString componentsSeparatedByString:@"|"];
        
        if ([JSON[@"success"] boolValue]) {
            NSArray *array = JSON[@"result"];
         
            for (NSDictionary *dic in array) {
                PairDTO *dto = [[PairDTO alloc] init];
                dto.label = dic[@"name"];
                dto.value = dic[@"id"];
                dto.key = @"不限";
                
                NSInteger i = 0;
                for (NSString *str in selectedLevelOneArray) {
                    if ([str isEqualToString:dto.label]) {
                        dto.key = [selectedLevelTwoArray[i] stringByReplacingOccurrencesOfString:@" " withString:@"，"];
                        break;
                    }
                    i++;
                }
                
                if([dto.label isEqualToString:@"不限"]) {
                    dto.accessType = 1;
                    dto.key = @"";
                }
                
                [self.dataArray addObject:dto];
            }
            [self.tableView setData:@[ self.dataArray ]];
        }
        
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
    }];
}

- (void)setMyInterestRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *params = @{ @"method" : @(MethodTypeJobChannelPostinterests) }.mutableCopy;
    [params addEntriesFromDictionary:[self params]];
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([JSON[@"success"] boolValue]) {
            [InfoAlertView showInfo:@"保存成功" inView:self.view duration:1];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
                    if (self.updateBlock) {
                        self.updateBlock();
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else if (self.type == HomeJobChannelIntersetViewControllerTypeFirstChoseInterest) {
                    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
                    [viewControllers removeLastObject];
                    
                    HomeJobChannelViewController *vc = [[HomeJobChannelViewController alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [viewControllers addObject:vc];
                    
                    [self.navigationController setViewControllers:[viewControllers copy] animated:YES];
                }
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

- (void)getMyInterestRequest
{
    NSMutableDictionary *params = @{ @"method" : @(MethodtypeJonChannelGetInterests) }.mutableCopy;
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            NSDictionary *dic = JSON[@"result"];
            
            NSString *province = dic[@"provinces"];
            NSString *education = self.eduactionTitleArray[[dic[@"education"] integerValue]];
            NSString *workExperience = self.workExperienceTitleArray[[dic[@"experience_time"] integerValue]];
            NSArray *unintNatureArray =  [dic[@"enterprise_type"] componentsSeparatedByString:@" "];
            __block NSMutableString *unitNature = [NSMutableString new];
                [unintNatureArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *  stop) {
                    [unitNature appendFormat:@"%@", self.unitNatureTitleArray[[obj integerValue]]];
                    if (idx < unintNatureArray.count - 1) {
                        [unitNature appendFormat:@"，"];
                    }
                }];
            NSString *unitSize = self.unitSizeTitleArray[[dic[@"enterprise_scale"] integerValue]];
            
            PairDTO *provinceDTO = [self.dataArray firstObject];
            provinceDTO.key = [province stringByReplacingOccurrencesOfString:@" " withString:@"，"];
            
            PairDTO *fuctionDTO = self.dataArray[1];
            fuctionDTO.key = [[dic[@"job_property_lev2"] stringByReplacingOccurrencesOfString:@"|" withString:@" "]
                              stringByReplacingOccurrencesOfString:@" " withString:@"，"];
            self.parmasDictionary[@"1"] = dic[@"job_property_lev1"];
            self.functionLevelTwoString = dic[@"job_property_lev2"];
            
            PairDTO *educationDTO = self.dataArray[2];
            educationDTO.key = education;
            self.parmasDictionary[@"2"] = @[ dic[@"education"] ];
            
            PairDTO *workExperienceDTO = self.dataArray[3];
            workExperienceDTO.key = workExperience;
            self.parmasDictionary[@"3"] = @[ dic[@"experience_time"] ];
            
            PairDTO *unitNatureDTO = self.dataArray[4];
            unitNatureDTO.key = [unitNature copy];
            self.parmasDictionary[@"4"] = unintNatureArray;
            
            PairDTO *unitSizeDTO = self.dataArray[5];
            unitSizeDTO.key = unitSize;
            self.parmasDictionary[@"5"] = @[ dic[@"enterprise_scale"] ];
            
            [self.tableView reloadData];
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - helper -

- (NSDictionary *)params
{
    if (self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest ||
        self.type == HomeJobChannelIntersetViewControllerTypeFirstChoseInterest) {
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
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeUnitFilter) {
        NSString *province = [[self.dataArray firstObject].key stringByReplacingOccurrencesOfString:@"，" withString:@" "];

        NSString *unitNature = @"0";
        NSArray *selectUnitNature = self.parmasDictionary[@"1"];
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
        NSArray *selectUnintSize = self.parmasDictionary[@"2"];
        if (selectUnintSize) {
            unitSize = [[selectUnintSize firstObject] integerValue];
        }

        NSInteger unitLevel = 0;
        NSArray *selectUnintLevel = self.parmasDictionary[@"3"];
        if (selectUnintLevel) {
            unitLevel = [[selectUnintLevel firstObject] integerValue];
        }
        
        NSDictionary *params = @{ @"province" : province,
                                  @"enterprise_type" : unitNature,
                                  @"enterprise_scale" : @(unitSize),
                                  @"enterprise_level" : @(unitLevel) };
        return params;
    } else if ( self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilter) {
        NSInteger publishTime = 0;
        NSArray *selectPublishTime = self.parmasDictionary[@"0"];
        if (selectPublishTime) {
            publishTime = [[selectPublishTime firstObject] integerValue];
        }
        
        NSString *province = [self.dataArray[1].key stringByReplacingOccurrencesOfString:@"，" withString:@" "];

        NSInteger workExperience = 0;
        NSArray *selectWorkExperience = self.parmasDictionary[@"2"];
        if (selectWorkExperience) {
            workExperience = [[selectWorkExperience firstObject] integerValue];
        }
        
        NSString *functionlevelOne = @"不限";
        NSString *functionLevelOneString = self.parmasDictionary[@"3"];
        if (functionLevelOneString) {
            functionlevelOne = functionLevelOneString;
        }
        
        NSInteger professionalQualifications = 0;
        NSArray *selectProfessionalQualifications = self.parmasDictionary[@"4"];
        if (selectProfessionalQualifications) {
            professionalQualifications = [[selectProfessionalQualifications firstObject] integerValue];
        }
        
        NSString *unitNature = @"0";
        NSArray *selectUnitNature = self.parmasDictionary[@"5"];
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
        NSArray *selectUnintSize = self.parmasDictionary[@"6"];
        if (selectUnintSize) {
            unitSize = [[selectUnintSize firstObject] integerValue];
        }

        NSInteger unitLevel = 0;
        NSArray *selectUnintLevel = self.parmasDictionary[@"7"];
        if (selectUnintLevel) {
            unitLevel = [[selectUnintLevel firstObject] integerValue];
        }
        
        NSInteger salary = 0;
        NSArray *selectSalary = self.parmasDictionary[@"8"];
        if (selectSalary) {
            salary = [[selectSalary firstObject] integerValue];
        }
        
        NSInteger education = 0;
        NSArray *selectEducation = self.parmasDictionary[@"9"];
        if (selectEducation) {
            education = [[selectEducation firstObject] integerValue];
        }
        
        NSDictionary *params = @{ @"publish_time" : @(publishTime),
                                  @"province" : province,
                                  @"job_property_lev1" : functionlevelOne,
                                  @"job_property_lev2" : self.functionLevelTwoString ? : @"不限",
                                  @"experience_time" : @(workExperience),
                                  @"title" : @(professionalQualifications),
                                  @"enterprise_type" : unitNature,
                                  @"enterprise_scale" : @(unitSize),
                                  @"enterprise_level" : @(unitLevel),
                                  @"salary" : @(salary),
                                  @"education" : @(education) };
        
        return params;
    } else if (self.type == HomeJobChannelIntersetViewControllerTypeEmploymentFilterFromWeb) {
        NSInteger publishTime = 0;
        NSArray *selectPublishTime = self.parmasDictionary[@"0"];
        if (selectPublishTime) {
            publishTime = [[selectPublishTime firstObject] integerValue];
        }
        
        NSString *province = [self.dataArray[1].key stringByReplacingOccurrencesOfString:@"，" withString:@" "];
        
        NSInteger workExperience = 0;
        NSArray *selectWorkExperience = self.parmasDictionary[@"2"];
        if (selectWorkExperience) {
            workExperience = [[selectWorkExperience firstObject] integerValue];
        }
        
        NSString *functionlevelOne = @"不限";
        NSString *functionLevelOneString = self.parmasDictionary[@"3"];
        if (functionLevelOneString) {
            functionlevelOne = functionLevelOneString;
        }
        
        NSInteger professionalQualifications = 0;
        NSArray *selectProfessionalQualifications = self.parmasDictionary[@"4"];
        if (selectProfessionalQualifications) {
            professionalQualifications = [[selectProfessionalQualifications firstObject] integerValue];
        }
        
        NSInteger salary = 0;
        NSArray *selectSalary = self.parmasDictionary[@"5"];
        if (selectSalary) {
            salary = [[selectSalary firstObject] integerValue];
        }
        
        NSInteger education = 0;
        NSArray *selectEducation = self.parmasDictionary[@"6"];
        if (selectEducation) {
            education = [[selectEducation firstObject] integerValue];
        }
        
        NSDictionary *params = @{ @"publish_time" : @(publishTime),
                                  @"province" : province,
                                  @"job_property_lev1" : functionlevelOne,
                                  @"job_property_lev2" : self.functionLevelTwoString ? : @"不限",
                                  @"experience_time" : @(workExperience),
                                  @"title" : @(professionalQualifications),
                                  @"salary" : @(salary),
                                  @"education" : @(education) };
        
        return params;
    }
    
    return nil;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIView *)footerCleanView
{
    if (!_footerCleanView) {
        _footerCleanView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 130)];
            view.userInteractionEnabled = YES;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"清除选项重置" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.layer.borderColor = [UIColor lightGrayColor].CGColor;
            button.layer.borderWidth = 0.5;
            button.layer.cornerRadius = 3.0;
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(cleanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            
            CGFloat margin = 40;
            if (self.type == HomeJobChannelIntersetViewControllerTypeFirstChoseInterest ||
                self.type == HomeJobChannelIntersetViewControllerTypeChoseInterest) {
                margin = 60;
            }
            
            [button makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(margin);
                make.right.equalTo(-margin);
                make.centerY.equalTo(0);
                make.height.equalTo(40);
            }];
            
            view;
        });
    }
    return _footerCleanView;
}

- (NSArray *)eduactionTitleArray
{
    if (!_eduactionTitleArray) {
        NSString *string = @"不限，大中专及以上，本科及以上，硕士及以上，博士及以上，其他";
        
        _eduactionTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _eduactionTitleArray;
}

- (NSArray *)workExperienceTitleArray
{
    if (!_workExperienceTitleArray) {
        NSString *string = @"不限，应届毕业生，1年以上，2年以上，3年以上，5年以上，10年以上";
        
        _workExperienceTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _workExperienceTitleArray;
}

- (NSArray *)unitNatureTitleArray
{
    if (!_unitNatureTitleArray) {
        NSString *string = @"不限，事业单位，国家行政机关，国有企业，国有控股企业，外资企业，合资企业，私营企业";
        
        _unitNatureTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitNatureTitleArray;
}

- (NSArray *)unitSizeTitleArray
{
    if (!_unitSizeTitleArray) {
        NSString *string = @"不限，1-400人，400人以上，1000人以上，2000人以上，4000人以上";
        
        _unitSizeTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitSizeTitleArray;
}

- (NSArray *)unitLevelTitleArray
{
    if (!_unitLevelTitleArray) {
        NSString *string = @"不限，三级甲等，三级乙等，二级甲等，二级二等，一级，其他";
        
        _unitLevelTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _unitLevelTitleArray;
}

- (NSArray *)publishTimeTitleArray
{
    if (!_publishTimeTitleArray) {
        NSString *string = @"不限，最近三天，最近一周，最近一个月，最近三个月";
        
        _publishTimeTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _publishTimeTitleArray;
}

- (NSArray *)professionalQualificationsTitleArray
{
    if (!_professionalQualificationsTitleArray) {
        NSString *string = @"不限，医师，护师，技师，药师";
        
        _professionalQualificationsTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _professionalQualificationsTitleArray;
}

- (NSArray *)salaryTitleArray
{
    if (!_salaryTitleArray) {
        NSString *string = @"不限，2k-4k，4k-6k，6k-10k，10k-20k，20k以上，面议";
        _salaryTitleArray = [string componentsSeparatedByString:@"，"];
    }
    return _salaryTitleArray;
}

@end
