//
//  CHProgressView.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/3.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHProgressView : UIView

@property (nonatomic, strong) UIColor *trackTintColor;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, assign) CGFloat progress;

@end
