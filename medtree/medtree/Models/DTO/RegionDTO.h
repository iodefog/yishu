//
//  RegionDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-14.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface RegionDTO : DTOBase

@property (nonatomic, strong) NSString      *name;
@property (nonatomic, assign) NSInteger     first_degree_count;
@property (nonatomic, assign) NSInteger     second_degree_count;

@end
