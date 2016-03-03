//
//  CertificationDTO.h
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"
#import "UserType.h"

@interface CertificationDTO : DTOBase

@property (nonatomic, strong) NSString   *certificationID;
@property (nonatomic, strong) NSString   *experience_id;
@property (nonatomic, assign) NSInteger  certificate_type;
/** 工作单位 */
@property (nonatomic, strong) NSString   *reason;
@property (nonatomic, assign) User_Types  userType;
@property (nonatomic, assign) NSInteger  status;
@property (nonatomic, strong) NSString   *comment;
@property (nonatomic, strong) NSString   *certificate_number;

@property (nonatomic, strong) NSMutableArray *images;

@end
