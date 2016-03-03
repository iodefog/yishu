//
//  OperationHelper.m
//  medtree
//
//  Created by sam on 8/15/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "OperationHelper.h"

@implementation OperationHelper

static UIViewController *rootController;

+ (void)setRootController:(UIViewController *)uvc
{
    rootController = uvc;
}

+ (UIViewController *)getRootController
{
    return rootController;
}

@end
