//
//  ResumeDTO.h
//  medtree
//
//  Created by 边大朋 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "PairDTO.h"
#import "GenderTypes.h"

typedef NS_ENUM(NSUInteger, ResumeRowType) {
    ResumeRowTypePic = 1,
    ResumeRowTypeName,
    ResumeRowTypeGender,
    ResumeRowTypeBirthplace,
    ResumeRowTypeBirthday,
    ResumeRowTypePhone,
    ResumeRowTypeExperienceEdu,
    ResumeRowTypeExperienceWork,
    ResumeRowTypeInterest,
    ResumeRowTypeSelfIntroduction,
    ResumeRowTypeHonour,
    ResumeRowTypeResidential,//居住地
    ResumeRowTypeWorkExperience,//工作经验
    ResumeRowTypePrivacy // 隐私
};

typedef NS_ENUM(NSUInteger, WorkExperienceType) {
    WorkExperienceTypeOverOne   = 2,
    WorkExperienceTypeOverTwo,
    WorkExperienceTypeOverThree,
    WorkExperienceTypeOverFive,
    WorkExperienceTypeOverTen
};

@class ExperienceDTO;

@interface ResumeDTO : PairDTO

@property (nonatomic, assign) ResumeRowType         resumeRowType;
@property (nonatomic, strong) ExperienceDTO         *experienceDTO;

@property (nonatomic, strong) NSString              *resumeId;
@property (nonatomic, strong) NSString              *resumeName;
@property (nonatomic, strong) NSString              *userId;
@property (nonatomic, strong) NSString              *avater;
@property (nonatomic, strong) NSString              *name;
@property (nonatomic, assign) Gender_Types          gender;
@property (nonatomic, strong) NSString              *birthProvince;
@property (nonatomic, strong) NSDate                *birthday;
@property (nonatomic, strong) NSString              *mobile;
@property (nonatomic, strong) NSString              *liveProvince;
@property (nonatomic, assign) WorkExperienceType    workExperience;
@property (nonatomic, assign) BOOL                  privacy;
@property (nonatomic, strong) NSString              *hobby;
@property (nonatomic, strong) NSString              *introduction;
@property (nonatomic, strong) NSString              *honor;
@property (nonatomic, strong) NSArray               *eduList;
@property (nonatomic, strong) NSArray               *workList;

@property (nonatomic, strong, readonly) NSString    *workExperienceStr;

@end
