//
//  CommonWebController.h
//  medtree
//
//  Created by 陈升军 on 15/9/14.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@interface CommonWebController : MedTreeBaseController

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, strong) NSString *naviTitle;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareDescription;
@property (nonatomic, strong) NSString *shareImageID;

@property (nonatomic, assign) BOOL     isShowShare;

- (void)clickShareWithInfo:(NSString *)info;

@end
