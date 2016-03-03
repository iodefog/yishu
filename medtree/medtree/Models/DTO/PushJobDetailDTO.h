//
//  PushJobDetailDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/12/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

#import "UnitSizeType.h"
#import "UnitLevelType.h"
#import "UnitNatureType.h"
#import "SalaryType.h"
#import "DegreeType.h"
#import "WorkExperienceType.h"

@class UserDTO;
@interface PushJobDetailDTO : DTOBase

@property (nonatomic, strong) NSString *jobId;
@property (nonatomic, strong) NSString *jobName;
@property (nonatomic, strong) NSString *enterpriseName;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *enterpriseLogo;
@property (nonatomic, assign) UnitNatureTypes enterpriseType;
@property (nonatomic, assign) UnitSizeTypes enterpriseSacle;
@property (nonatomic, assign) UnitLevelTypes enterpriseLevel;
@property (nonatomic, assign) SalaryTypes salary;
@property (nonatomic, assign) DegreeTypes degree;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) WorkExperienceTypes experienceTime;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) UserDTO *user;
@property (nonatomic, strong) NSString *shareInfo;

@end
