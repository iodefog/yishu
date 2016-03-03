//
//  UIButton+setImageWithURL.h
//  123456
//
//  Created by tangshimi on 5/6/15.
//  Copyright (c) 2015 tangshimi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIButton+WebCache.h"

@interface UIButton (setImageWithURL)

- (void)med_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)med_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

- (void)med_setImageWithURL:(NSURL *)url forState:(UIControlState)state;

- (void)med_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;

@end
