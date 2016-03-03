//
//  ImproveController.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  完善个人信息

#import "MedTreeBaseController.h"
#import "UserType.h"

@interface ImproveController : MedTreeBaseController

/** 用户类型 */
@property (nonatomic, assign) User_Types userType;

@property (nonatomic, assign) BOOL isDismiss;

@end
