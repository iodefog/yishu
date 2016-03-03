//
//  OrganizationDTO.h
//  medtree
//
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface OrganizationDTO : DTOBase

@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSString  *value;
@property (nonatomic, strong) NSString  *value2;
@property (nonatomic, strong) NSString  *value3;
@property (nonatomic, strong) NSString  *time;
@property (nonatomic, strong) NSString  *startDate;
@property (nonatomic, strong) NSString  *endDate;
@property (nonatomic, assign) NSInteger cellType;
@property (nonatomic, assign) BOOL      isShowHeaderLine;
@property (nonatomic, assign) BOOL      isShowFootLine;
@property (nonatomic, assign) BOOL      isLastCell;
@property (nonatomic, assign) BOOL      isOn;
@property (nonatomic, assign) BOOL      isCommonFriend;
@property (nonatomic, strong) NSString  *experienceId;
@property (nonatomic, assign) BOOL      is_certificated;

@property (nonatomic, assign) NSInteger orig_type;

@end
