//
//  PersonEditViewController.h
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@class UserDTO;

@protocol PersonEditViewControllerDelegate <NSObject>

- (void)reloadView;


@end

@interface PersonEditViewController : MedTreeBaseController

@property (nonatomic, assign) id<PersonEditViewControllerDelegate> parent;

- (void)setInfo:(UserDTO *)dto;

@end
