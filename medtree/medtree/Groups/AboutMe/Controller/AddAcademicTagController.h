//
//  AddAcademicTagController.h
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "TableController.h"
#import "AcademicTagController.h"

@interface AddAcademicTagController : TableController

@property (nonatomic, strong) NSMutableArray *userTagArray;
@property (nonatomic, strong) id <AcademicTagControllerDelegate>delegate;

@end
