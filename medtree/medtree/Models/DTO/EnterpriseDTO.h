//
//  EnterpriseDTO.h
//  medtree
//
//  Created by 边大朋 on 15/10/21.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface EnterpriseDTO : DTOBase

@property (nonatomic, copy) NSString *enterpriseId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *location;//企业所在地
@property (nonatomic, copy) NSString *companyType;//医院类别
@property (nonatomic, copy) NSString *peopleScope;//人数范围

//我关注的企业的基本格式化信息
@property (nonatomic, copy) NSString *baseInfoFormat;
@end
