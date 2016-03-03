//
//  BaseGuideView.h
//  medtree
//
//  Created by tangshimi on 6/4/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseGuideView : UIView

@property (nonatomic, strong) UIView *backView;

+ (void)setAlreadyShow:(NSString *)className;
+ (BOOL)showGuideView:(NSString *)className;

@end
