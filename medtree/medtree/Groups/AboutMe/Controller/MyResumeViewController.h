//
//  MyResumeViewController.h
//  medtree
//
//  Created by 边大朋 on 15/10/20.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "TableController.h"

typedef NS_ENUM(NSUInteger, MyResumeViewControllerComeFrom) {
    MyResumeViewControllerComeFromMe = 1,
    MyResumeViewControllerComeFromPostDetail,
    MyResumeViewControllerComeFromRegister
};

@interface MyResumeViewController : TableController

@property (nonatomic, assign) MyResumeViewControllerComeFrom comeFrom;

@property (nonatomic, strong) NSString *positionId;

@end
