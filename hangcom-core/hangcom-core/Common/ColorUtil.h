//
//  ColorUtil.h
//  aqgj_dial
//
//  Created by Sam on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorUtil : NSObject

+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha;

+ (void)setNavigationColor:(UIColor *)color;
+ (UIColor *)getNavigationColor;

+ (void)setBackgroundColor:(UIColor *)color;
+ (UIColor *)getBackgroundColor;
+ (NSInteger)getColorRow;
+ (void)setColorRow:(NSInteger)cRow;

+ (UIImageView *)getBackgroundImageView;
+ (void)setBackgroundImageView:(UIImage *)bgImage size:(CGSize)size;

+ (void)setTextColor:(UIColor *)color;
+ (UIColor *)getTextColor;
+ (UIColor *)getRandomColor:(BOOL)isRandom atIndex:(NSInteger)atIndex;
+ (NSString *)getColorString:(BOOL)isRandom atIndex:(NSInteger)atIndex;

@end
