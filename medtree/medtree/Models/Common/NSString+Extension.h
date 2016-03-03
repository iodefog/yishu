//
//  NSString+Extension.h
//  medtree
//
//  Created by tangshimi on 5/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  UITextView 计算高度
 *
 *  @param string <#string description#>
 *  @param size   <#size description#>
 *  @param font   <#font description#>
 *
 *  @return <#return value description#>
 */

+ (CGSize)sizeForString:(NSString*)string Size:(CGSize)size Font:(UIFont*)font;

+ (CGSize)sizeForString:(NSString *)string Size:(CGSize)size Font:(UIFont*)font Lines:(NSInteger)lines;

+ (CGSize)labelSizeForString:(NSString*)string Size:(CGSize)size Font:(UIFont*)font;

+ (CGSize)labelSizeForString:(NSString*)string Size:(CGSize)size Font:(UIFont*)font Lines:(NSInteger)lines;

- (CGSize)sizefitLabelInSize:(CGSize)size Font:(UIFont *)font;

- (CGFloat)getStringWithFont:(UIFont *)font;

- (CGFloat)getStringWidthInWidth:(CGFloat)width font:(UIFont *)font;

@end
