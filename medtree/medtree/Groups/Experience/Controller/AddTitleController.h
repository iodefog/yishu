//
//  AddTitleController.h
//  medtree
//
//  Created by 边大朋 on 15/6/18.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@interface AddTitleController : MedTreeBaseController

@property (nonatomic, strong) UIViewController *fromVC;

@property (nonatomic, weak) id parent;

@property (nonatomic, strong) NSString *titleName;

@end
