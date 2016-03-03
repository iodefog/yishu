//
//  ExperienceListController.h
//  medtree
//
//  Created by 边大朋 on 15/6/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"
#import "ExperienceDTO.h"
#import "MedTreeBaseController.h"

@interface ExperienceListController : MedTreeBaseController
/** 经历类型 */
@property (nonatomic, assign) ExperienceType experienceType;

@property (nonatomic, weak) id parent;

/** 来自选择认证控制器 */
@property (nonatomic, assign) BOOL fromVerify;
@property (nonatomic, assign) BOOL fromResume;

@end