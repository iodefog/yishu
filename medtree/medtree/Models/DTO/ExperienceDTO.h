//
//  ExperienceDTO.h
//  medtree
//
//  Created by 陈升军 on 15/6/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CellDTO.h"
#import "CertificationStatusType.h"

typedef enum
{
    ExperienceType_Edu = 1,
    ExperienceType_Work = 2,
} ExperienceType;

typedef NS_ENUM(NSInteger, ExperienceAction) {
    ExperienceAction_AddExperience,
    ExperienceAction_GoToCert
};

typedef enum
{
    OrgType_School   = 10,      //  学校
    OrgType_Hospital = 20,      //  医院
    OrgType_Unit     = 30,      //  其他
    OrgType_All      = 200,
    
} OrgType;

@class DepartmentNameDTO;

@interface ExperienceDTO : CellDTO

/** 组织名 */
@property (nonatomic, strong) NSString *org;
@property (nonatomic, assign) ExperienceType experienceType;
@property (nonatomic, strong) NSString  *startDate;
@property (nonatomic, strong) NSString  *endDate;

@property (nonatomic, strong) NSString *organization_id;
@property (nonatomic, assign) NSInteger title_type;
@property (nonatomic, strong) NSString  *experienceId;

@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSString  *value;
@property (nonatomic, assign) BOOL      isOn;
@property (nonatomic, assign) OrgType  orgType;
@property (nonatomic, assign) BOOL      isShowVerify;
@property (nonatomic, strong) NSMutableArray *departments;
@property (nonatomic, strong) NSString  *province;
/** 部门的 */
@property (nonatomic, strong) DepartmentNameDTO *department;

/** 经历认证状态*/
@property (nonatomic, assign) CertificationStatus_Types experienceCertStatus;
@property (nonatomic, assign) NSUInteger index;

@end
