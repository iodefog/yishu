//
//  BaseController.h
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationBar.h"

@interface BaseController : UIViewController {
    UIImageView *statusBar;
    NavigationBar *naviBar;
}

- (CGFloat)getOffset;
- (void)createUI;
- (void)createNaviBar;
- (void)reloadCatenaImage;
- (void)registerNotifications;
- (void)registerCatenaImageNotifications;
- (void)removeCatenaImageNotifications;

@end
