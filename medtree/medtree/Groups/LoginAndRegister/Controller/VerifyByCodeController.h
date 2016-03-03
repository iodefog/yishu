//
//  VerifyByCodeController.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "NewPersonIdentificationDetailController.h"

@class CertificationDTO;
@class ExperienceDTO;
@interface VerifyByCodeController : MedTreeBaseController

@property (nonatomic, assign) id<IdentificationDetailDelegate> delegate;

@property (nonatomic, strong) CertificationDTO *certifDto;

@property (nonatomic, strong) ExperienceDTO *experienceDto;

@property (nonatomic, strong) UIViewController *fromVC;

/** 来自注册，完善页面 */
@property (nonatomic, assign) BOOL fromRegister;

- (void)updateInfo:(NSDictionary *)dict;

@end
