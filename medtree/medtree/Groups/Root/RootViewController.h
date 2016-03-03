//
//  RootViewController.h
//  medtree
//
//  Created by tangshimi on 7/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController

@property (nonatomic, readonly, strong) UITabBarController *tabBarController;

+ (RootViewController *)shareRootViewController;

- (void)showLeftSideMenuViewController;
- (void)hideLeftSideMenuViewController;

- (void)presentLoginViewController;

- (void)loginIM;

- (void)logout;

@end
