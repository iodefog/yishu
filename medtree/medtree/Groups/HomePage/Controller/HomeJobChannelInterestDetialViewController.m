//
//  HomeJobChannelInterestDetialViewController.m
//  medtree
//
//  Created by tangshimi on 10/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelInterestDetialViewController.h"
#import "PairDTO.h"
#import "HomeJobChannelInterestDetialTableViewCell.h"
#import <InfoAlertView.h>
#import "ServiceManager.h"
#import <JSONKit.h>
#import "ProvinceDTO.h"

@interface HomeJobChannelInterestDetialViewController () <MedBaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, copy) NSDictionary *professionalQualificationsDic;

@end

@implementation HomeJobChannelInterestDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc] init];

    if(self.titleArray) {
        NSInteger i = 0;
        for (NSString *string in self.titleArray) {
            PairDTO *dto = [[PairDTO alloc] init];
            dto.label = string;
            
            if (self.type == HomeJobChannelInterestDetialViewControllerTypeProfessionalQualifications) {
                if ([string isEqualToString:self.selectedProvinceString]) {
                    dto.isSelect = YES;
                }
            } else {
                for (NSString *str in self.selectedIndexArray) {
                    if (i == [str integerValue]) {
                        dto.isSelect = YES;
                    }
                }
            }
            
            [self.dataArray addObject:dto];
            i ++;
        }
        
        [self.tableView setData:@[ self.dataArray ]];
    }
    
    if (self.type == HomeJobChannelInterestDetialViewControllerTypeRegionMultiSelection ||
        self.type == HomeJobChannelInterestDetialViewControllerTypeRegionSingalSelection) {
        [self showLoadingView];
        [self regionRequest];
    } else if (self.type == HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoMultiSelection ||
               self.type == HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoSingalSelection) {
        [self showLoadingView];
        [self functionLevelTwoRequest];
    }
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:self.title];
    [self createBackButton];
    
    if ([self supportMultiSelection]) {
        [naviBar setRightButton:[NavigationBar createNormalButton:@"保存"
                                                           target:self
                                                           action:@selector(saveButtonAction:)]];
    }
    
    self.tableView.registerCells = @{ @"PairDTO" : [HomeJobChannelInterestDetialTableViewCell class] };
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
}

#pragma mark -
#pragma mark - MedBaseTableViewDelegate -

- (void)clickCell:(PairDTO *)dto index:(NSIndexPath *)index
{
    if ([self supportMultiSelection]) {
        if (index.row == 0) {
            BOOL selected = dto.isSelect;
            for (PairDTO *sdto in self.dataArray) {
                sdto.isSelect = selected ? NO : YES;
            }
            self.completeBlock(@"不限", @[ @(0) ]);
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            dto.isSelect = !dto.isSelect;
            
            BOOL sameSelected = YES;
            
            NSInteger i = 0;
            for (PairDTO *sdto in self.dataArray) {
                if (i > 0) {
                    if (dto.isSelect != sdto.isSelect) {
                        sameSelected = NO;
                        break;
                    }
                }
                i ++;
            }
            
            PairDTO *firstDTO = [self.dataArray firstObject];
            firstDTO.isSelect = sameSelected && dto.isSelect ? YES : NO;
        }
    } else {
        NSInteger i = 0;
        for (PairDTO *sdto in self.dataArray) {
            if (i != index.row ) {
                sdto.isSelect = NO;
            }
            i ++;
        }
        
        dto.isSelect = !dto.isSelect;
        
        if (index.row == 0) {
            dto.isSelect = YES;
        }
        
        [self saveButtonAction:nil];
    }
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - response event -

- (void)saveButtonAction:(UIButton *)button
{
    if ([self supportMultiSelection]) {
        PairDTO *firstDTO = [self.dataArray firstObject];
        
        if (firstDTO.isSelect) {
            self.completeBlock(@"不限", @[ @(0) ]);
        } else {
            NSMutableArray *indexArray = [NSMutableArray new];
            NSMutableString *string = [NSMutableString new];
            
            NSInteger i = 0;
            for (PairDTO *sdto in self.dataArray) {
                if (i > 0 && sdto.isSelect ) {
                    [indexArray addObject:@(i)];
                    [string appendFormat:@"%@，", sdto.label];
                }
                i ++;
            }
            
            if (indexArray.count == 0) {
                [InfoAlertView showInfo:@"请至少选择一项" duration:1.0];
                return;
            } else {
                self.completeBlock([string substringToIndex:string.length - 1], indexArray);
            }
        }
    } else {
        NSMutableArray *indexArray = [NSMutableArray new];
        NSMutableString *string = [NSMutableString new];
        
        NSInteger i = 0;
        for (PairDTO *sdto in self.dataArray) {
            if (sdto.isSelect) {
                if (self.type == HomeJobChannelInterestDetialViewControllerTypeProfessionalQualifications) {
                    [indexArray addObject:self.professionalQualificationsDic[sdto.label]];
                } else {
                    [indexArray addObject:@(i)];
                }
                [string appendFormat:@"%@", sdto.label];
            }
            i ++;
        }
        
        if (indexArray.count == 0) {
            [InfoAlertView showInfo:@"请选择一项" duration:1.0];
            return;
        } else {            
            self.completeBlock(string, indexArray);
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - network request -

- (void)regionRequest
{    
    NSDictionary *params = @{ @"method" : @(MethodType_Degree_LocationSearch), @"org_type" : @(200), @"from" : @(0), @"size" : @(50)};
    
    [ServiceManager getData:params success:^(NSArray *JSON) {
        [self hideLoadingView];
        
        NSArray *selecedProvinceArray = [self.selectedProvinceString componentsSeparatedByString:@"，"];
        
        for (ProvinceDTO *dto in JSON) {
            PairDTO *pdto = [[PairDTO alloc] init];
            pdto.label = dto.name;
            
            for (NSString *str in selecedProvinceArray) {
                if ([str isEqualToString:dto.name]) {
                    pdto.isSelect = YES;
                }
            }
            
            [self.dataArray addObject:pdto];
        }
        PairDTO *pdto = [[PairDTO alloc] init];
        pdto.label = @"不限";
        
        if([[selecedProvinceArray firstObject] isEqualToString:@"不限"]) {
            pdto.isSelect = YES;
        }
        
        [self.dataArray insertObject:pdto atIndex:0];
        
        [self.tableView setData:@[ self.dataArray ]];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"]) {
                [InfoAlertView showInfo:result[@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)functionLevelTwoRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeJobChannelFunctionLevelTwo), @"parentID" : @(self.functionLevelOneID) };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        [self hideLoadingView];

        if([JSON[@"success"] boolValue]) {
            NSArray *array = JSON[@"result"];
            
            NSArray *selectedArray = [self.selectedFunctionLevelTwoString componentsSeparatedByString:@"，"];
            
            for (NSString *string in array) {
                PairDTO *dto = [[PairDTO alloc] init];
                dto.label = string;
                
                for (NSString *str in selectedArray) {
                    if ([str isEqualToString:dto.label]) {
                        dto.isSelect = YES;
                        break;
                    }
                }
                
                [self.dataArray addObject:dto];
            }
            
            PairDTO *pdto = [[PairDTO alloc] init];
            pdto.label = @"不限";
            if ([[selectedArray firstObject] isEqualToString:@"不限"]) {
                pdto.isSelect = YES;
            }
            
            [self.dataArray insertObject:pdto atIndex:0];
            
            [self.tableView setData:@[ self.dataArray ]];
        }
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"]) {
                [InfoAlertView showInfo:result[@"message"] inView:self.view duration:1];
            }
        }
    }];
}

#pragma mark -
#pragma mark - helper -

- (BOOL)supportMultiSelection
{
    if (self.type == HomeJobChannelInterestDetialViewControllerTypeRegionMultiSelection ||
        self.type == HomeJobChannelInterestDetialViewControllerTypeFunctionLevelTwoMultiSelection ||
        self.type == HomeJobChannelInterestDetialViewControllerTypeUnitNatureMultiSelection) {
        return YES;
    } else {
        return NO;
    }
}

- (NSDictionary *)professionalQualificationsDic
{
    if (!_professionalQualificationsDic) {
        _professionalQualificationsDic = @{ @"药士" : @(21),
                                            @"药师" : @(22),
                                            @"主管药师" : @(23),
                                            @"副主任药师" : @(24),
                                            @"主任药师" : @(25),
                                            @"技士" : @(31),
                                            @"技师" : @(32),
                                            @"主管技师" : @(33),
                                            @"副主任技师" : @(34),
                                            @"主任技师" : @(35),
                                            @"住院医师" : @(42),
                                            @"主治医师" : @(43),
                                            @"副主任医师" : @(44),
                                            @"主任医师" : @(45),
                                            @"护士" : @(53),
                                            @"护师" : @(54),
                                            @"主管护师" : @(55),
                                            @"副主任护师" : @(56),
                                            @"主任护师" : @(57) };
    }
    return _professionalQualificationsDic;
}

@end
