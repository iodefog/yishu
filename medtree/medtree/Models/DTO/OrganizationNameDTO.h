//
//  OrganizationNameDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-19.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@class ProvinceDTO;
@interface OrganizationNameDTO : DTOBase

@property (nonatomic, strong) NSString *cert_state;
/** 组织id */
@property (nonatomic, strong) NSString *organizationID;
/** 纬度 */
@property (nonatomic, assign) double   latitude;
/** 精度 */
@property (nonatomic, assign) double   longitude;
/** 组织名 */
@property (nonatomic, strong) NSString *name;
/** 组织类型：医院，学校，其他 */
@property (nonatomic, assign) NSInteger type;
/** 所属省份 */
@property (nonatomic, strong) ProvinceDTO *province;

@property (nonatomic, strong) NSString *logo;
@property (nonatomic, assign) NSInteger userCount;

@end
