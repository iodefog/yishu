//
//  ExperienceOrgController.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceSearchController.h"
#import "ExperienceDTO.h"
#import "UserType.h"

@class ExperienceTableView;
@class RegisterOrganizationAddView;
@class ProvinceDTO;

@interface ExperienceOrgController : ExperienceSearchController

@property (nonatomic, copy) void(^dismissBlock)(NSDictionary *dict);
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) ProvinceDTO *province;
@property (nonatomic, assign) ExperienceType experienceType;

@property (nonatomic, assign) OrgType orgType;
@property (nonatomic, assign) User_Types userType;

@end