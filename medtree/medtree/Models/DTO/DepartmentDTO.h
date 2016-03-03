//
//  DepartmentDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-9.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface DepartmentDTO : DTOBase

@property (nonatomic, strong) NSString  *departmentID;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, assign) NSInteger degree;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString  *org_id;
//@property (nonatomic, assign) NSInteger second_degree_count;

@end
