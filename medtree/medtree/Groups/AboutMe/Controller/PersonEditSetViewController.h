//
//  PersonEditSetViewController.h
//  medtree
//
//  Created by 无忧 on 14-8-25.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@protocol PersonEditSetViewControllerDelegate <NSObject>

- (void)updateUserInfo:(NSDictionary *)dict;

@end

@interface PersonEditSetViewController : MedTreeBaseController

@property (nonatomic, assign) id<PersonEditSetViewControllerDelegate> parent;

- (void)setNaviTitle:(NSString *)title;
- (void)setUserInfo:(NSDictionary *)dict;

@end
