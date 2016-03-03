//
//  ExperienceDepController.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceSearchController.h"
#import "ExperienceDTO.h"

@class CustomTextField;
@class OrganizationNameDTO;

@interface ExperienceDepController : ExperienceSearchController
{
    NSString *firstDepName;
    NSString *secondDepId;
    NSString *secondDepName;
    NSInteger fromNum;
    
    UISearchBar *searchShowView;
    
    
    UILabel *noticeLab;
    CustomTextField *inputView;
    UILabel *exampleLab;
}

@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) NSString *depName;
@property (nonatomic, strong) OrganizationNameDTO *organDto;
@property (nonatomic, assign) ExperienceType experienceType;
@property (nonatomic, assign) OrgType orgType;

/** 修改时，传递过来的department name */
@property (nonatomic, strong) NSString *departmentName;

@end
