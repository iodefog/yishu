//
//  VerifyController.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "UserType.h"
#import "NewPersonIdentificationDetailController.h"

@class CertificationDTO;
@class ExperienceDTO;
@interface VerifyController : MedTreeBaseController

/** 来自注册，完善页面 */
@property (nonatomic, assign) BOOL fromRegister;

@property (nonatomic, assign) User_Types userType;

@property (nonatomic, strong) CertificationDTO *certifDto;

@property (nonatomic, strong) ExperienceDTO *experienceDto;

@property (nonatomic, weak) id<IdentificationDetailDelegate> delegate;

@property (nonatomic, strong) UIViewController *fromVC;

@end
