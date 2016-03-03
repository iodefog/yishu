//
//  ExperienceSearchController.h
//  medtree
//
//  Created by 边大朋 on 15/6/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "RegisterOrganizationButtonView.h"
#import "RegisterOrganizationAddView.h"
#import "ExperienceTableView.h"
#import "ExperienceDTO.h"

@protocol ExperienceSearchDelegate <NSObject>

- (void)updateInfo:(NSDictionary *)dict;

@end

@interface ExperienceSearchController : MedTreeBaseController
{
    UISearchBar *searchView;
    
    RegisterOrganizationAddView *registerOrganizationAddView;
    ExperienceTableView *searchTable;
    ExperienceTableView *commonTable;
    
    UIView *coverView;
    
    BOOL isSearch;
    BOOL isPerson;
    
    NSMutableArray *dataArray;
    NSMutableArray *searchArray;
    
    NSString *typeTitle;
}

@property (nonatomic, weak) id parent;

- (void)clickTap;
- (void)createSearchView;
- (void)createCommonView;
- (void)createSearchBar:(UISearchBar *)searchBar Cancel:(BOOL)cancel;

- (void)getOrganizationDataWithDict:(NSMutableDictionary *)dict;
- (void)getDepartmentDataWithDict:(NSMutableDictionary *)dict;

@end
