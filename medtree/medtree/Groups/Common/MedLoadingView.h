//
//  MedLoadingView.h
//  medtree
//
//  Created by tangshimi on 10/27/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedLoadingView : UIView

+ (MedLoadingView *)showLoadingViewAddedTo:(UIView *)view;

+ (BOOL)hideLoadingViewForView:(UIView *)view;

+ (BOOL)restartAnimationInView:(UIView *)view;

@end
