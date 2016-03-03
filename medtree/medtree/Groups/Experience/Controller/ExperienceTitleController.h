//
//  ExperienceTitleController.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceSearchController.h"
#import "UserType.h"

@class TitleDTO;
@interface ExperienceTitleController : ExperienceSearchController

@property (nonatomic, assign) ExperienceType experienceType;
@property (nonatomic, assign) OrgType orgType;
@property (nonatomic, strong) TitleDTO *titleDto;

/** 注册的时候用户身份：医生和护士分开对待 */
@property (nonatomic, assign) User_Types userType;

@end
