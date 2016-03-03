//
//  OrganizationMapDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface OrganizationMapDTO : DTOBase

@property (nonatomic, strong) NSString  *organizationID;
@property (nonatomic, assign) double    latitude;
@property (nonatomic, assign) double    longitude;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *region;
//@property (nonatomic, assign) NSInteger first_degree_count;
//@property (nonatomic, assign) NSInteger second_degree_count;
@property (nonatomic, assign) NSInteger total_count;
@property (nonatomic, assign) NSInteger org_type;
@property (nonatomic, strong) NSString  *image;
@property (nonatomic, assign) NSInteger degree;

@end
