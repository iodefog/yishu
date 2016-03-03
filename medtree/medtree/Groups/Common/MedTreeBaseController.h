//
//  MedTreeBaseController.h
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseController.h"
#import "GetDataLoadingView.h"

@interface MedTreeBaseController : BaseController
{
    GetDataLoadingView  *dataLoading;
}

@property (nonatomic, assign) BOOL hideNoNetworkImage;

- (void)showErrorAlert:(NSString *)message;

- (UIButton *)createBackButton;
- (void)clickBack;

@end
