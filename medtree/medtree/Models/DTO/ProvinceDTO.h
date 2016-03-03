//
//  ProvienceDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/31.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  省份

#import "DTOBase.h"

@interface ProvinceDTO : DTOBase

/** 省份 */
@property (nonatomic, strong) NSString *name;
/** 总数 */
@property (nonatomic, assign) NSInteger count;

@end
