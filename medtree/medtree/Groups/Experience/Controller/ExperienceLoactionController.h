//
//  ExperienceLoactionController.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"
#import "ExperienceDTO.h"
#import "UserType.h"

@interface ExperienceLoactionController : TableController

/** 经历类型：工作经历、教育经历 */
@property (nonatomic, assign) ExperienceType expType;
/** 组织类型 */
@property (nonatomic, assign) OrgType orgType;
@property (nonatomic, assign) User_Types userType;

@property (nonatomic, strong) UIViewController *fromVC;

@end
