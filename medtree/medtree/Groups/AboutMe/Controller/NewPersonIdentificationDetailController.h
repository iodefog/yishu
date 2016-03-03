//
//  NewPersonIdentificationDetailController.h
//  medtree
//
//  Created by 陈升军 on 15/4/8.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"

@class CertificationDTO;
@class ExperienceDTO;

@protocol IdentificationDetailDelegate <NSObject>

- (void)updateCertificationArray:(CertificationDTO *)dto;

@end

@interface NewPersonIdentificationDetailController : TableController

@property (nonatomic, assign) id<IdentificationDetailDelegate> delegate;

@property (nonatomic, strong) CertificationDTO *certifDto;

@property (nonatomic, strong) ExperienceDTO *experienceDto;

@property (nonatomic, strong) UIViewController *fromVC;

/** 来自注册，完善页面 */
@property (nonatomic, assign) BOOL fromRegister;

- (void)updateInfo:(NSDictionary *)dict;

@end
