//
//  VerticalButton.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//
//  图文上下排列的button

#import <UIKit/UIKit.h>

@interface VerticalButton : UIButton

+ (instancetype)button;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) UIImage *image;

@end
