//
//  ForgetPasswordController1.h
//  medtree
//
//  Created by 孙晨辉 on 15/4/15.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@protocol NewForgetPasswordControllerDelegate <NSObject>

- (void)setUserName:(NSString *)userName passWord:(NSString *)passWord;
- (void)clickLogin;

@end

@interface NewForgetPasswordController : MedTreeBaseController

@property (nonatomic, assign) id<NewForgetPasswordControllerDelegate> parent;

- (void)setNaviTitle:(NSString *)title;

- (void)setNaviColor:(UIColor *)color;


@end
