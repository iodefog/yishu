//
//  RegisterController.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//
// 填写注册信息

#import "BaseController.h"
#import "UserType.h"

extern NSString *const kRegistAction;

@interface RegisterController : BaseController

/** 用户类型 */
@property (nonatomic, assign) User_Types userType;
/** 登陆账号不存在，直接走注册流程，将手机号带入到注册框中*/
@property (nonatomic, strong) NSString *phoneNum;

@end
