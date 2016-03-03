//
//  AcademicTagController.h
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseController.h"

@class UserDTO;
@protocol AcademicTagControllerDelegate <NSObject>
- (void)updateParentVC:(UserDTO *)dto;
@end

@interface AcademicTagController : BaseController

@property (nonatomic, weak) id <AcademicTagControllerDelegate>delegate;

@end
