//
//  DepartmentNameDTO.h
//  medtree
//
//  Created by 无忧 on 14-9-19.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface DepartmentNameDTO : DTOBase

/** 部门id */
@property (nonatomic, strong) NSString  *departmentID;
/** 部门名 */
@property (nonatomic, strong) NSString  *name;
/** 部门层级:1,第一层 */
@property (nonatomic, assign) NSInteger level;
/** 父部门id */
@property (nonatomic, strong) NSString  *parent_id;
/** 父部门名 */
@property (nonatomic, strong) NSString *parent_name;
/** 组织结构id */
@property (nonatomic, strong) NSString  *org_id;
/** 是否含有子部门 */
@property (nonatomic, assign) BOOL  hasChild;

@end
