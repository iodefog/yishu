//
//  IdentitySelectorController.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  身份选择

#import "BaseController.h"

@interface IdentitySelectorController : BaseController

/** 登陆账号不存在，直接走注册流程，将手机号带入到注册框中*/
@property (nonatomic, strong) NSString *phoneNum;

@end
