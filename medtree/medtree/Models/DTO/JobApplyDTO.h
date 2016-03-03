//
//  JobApplyDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

#import "UnitSizeType.h"
#import "UnitLevelType.h"
#import "UnitNatureType.h"
#import "SalaryType.h"
#import "DegreeType.h"

typedef NS_ENUM(NSUInteger, ApplyResult) {
    ApplyResultAll = 0,
    ApplyResultDeliver = 1,
    ApplyResultChecking = 2,
    ApplyResultResumeFailure = 3,
    ApplyResultInviteAudition = 4,
    ApplyResultAuditionAccess = 7,
    ApplyResultAuditionFailure = 8,
    ApplyResultInviteDelivery = 13,
};

@interface JobApplyDTO : DTOBase

@property (nonatomic, strong) NSString *welfare;
@property (nonatomic, strong) NSString *applyID;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *positionId;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) NSString *avater;
@property (nonatomic, strong) NSString *salary;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, assign) ApplyResult applyResult;
@property (nonatomic, strong) NSDate *update;
@property (nonatomic, strong) NSDate *jobUpdate;
@property (nonatomic, assign) DegreeTypes degree;
@property (nonatomic, assign) UnitNatureTypes orginType;
@property (nonatomic, assign) UnitSizeTypes orginScale;
@property (nonatomic, assign) UnitLevelTypes orginLevel;

@end
