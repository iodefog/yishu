//
//  NewRegisterController.h
//  medtree
//
//  Created by Jiangmm on 15/12/18.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "BaseController.h"
#import "UserType.h"

@interface NewRegisterController : BaseController
/** 用户类型 */
@property (nonatomic, assign) User_Types userType;
/** 登陆账号不存在，直接走注册流程，将手机号带入到注册框中*/
@property (nonatomic, strong) NSString *phoneNum;

@end
