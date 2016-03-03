//
//  AddOrgController.h
//  medtree
//
//  Created by 边大朋 on 15/6/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "ExperienceDTO.h"
#import "UserType.h"

@class CustomTextField;
@class ProvinceDTO;
@interface AddOrgController : MedTreeBaseController

@property (nonatomic, weak) id parent;
@property (nonatomic, assign) ExperienceType expType;
@property (nonatomic, strong) UIViewController *fromVC;
@property (nonatomic, strong) NSString *orgName;
@property (nonatomic, strong) ProvinceDTO *province;
@property (nonatomic, assign) OrgType orgType;
/** 注册时医生只能选择医院 */
@property (nonatomic, assign) User_Types userType;

@end
