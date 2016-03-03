//
//  UIImage+imageWithColor.m
//  medtree
//
//  Created by tangshimi on 8/24/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "UIImage+imageWithColor.h"

@implementation UIImage (imageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
