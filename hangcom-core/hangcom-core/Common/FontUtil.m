//
//  FontUtil.m
//  mcare-core
//
//  Created by sam on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation FontUtil

static NSString *font = nil;
+ (void)setFont:(NSString *)fontName
{
    font = fontName;
}

+ (UIFont *)getFont:(CGFloat)size
{
    return [UIFont fontWithName:font size:size];
}

+ (NSString *)getFontName;
{
    return @"Hiragino Sans GB";
}

+ (void)setComFont:(UILabel *)label size:(CGFloat)size
{
    label.font = [UIFont fontWithName:[FontUtil getFontName] size:size];
    label.font = [UIFont boldSystemFontOfSize:size];
}

+ (void)setFont:(UILabel *)label size:(CGFloat)size
{
    [FontUtil setComFont:label size:size];
}

+ (CGFloat)getLabelHeight:(UILabel *)label labelFont:(CGFloat)labelFont
{
    UIFont *font = [UIFont systemFontOfSize:labelFont];
    CGSize size = [label.text sizeWithFont:font];
    return size.height;
}

+ (CGFloat)getLabelWidth:(UILabel *)label labelFont:(CGFloat)labelFont
{
    UIFont *font = [UIFont systemFontOfSize:labelFont];
    CGSize size = [label.text sizeWithFont:font];
    return size.width;
}

+ (CGFloat)infoHeight:(NSString *)info font:(CGFloat)font width:(CGFloat)width
{
    CGSize infoSize = CGSizeMake(width, 1000000);
    if ((NSObject *)info == [NSNull null] || info.length == 0) {
        return 0;
    } else {
        CGSize size = [info sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:infoSize lineBreakMode:NSLineBreakByWordWrapping];
        return size.height;
    }
    
}

static UIColor* barFontColor;

+ (UIColor *)getBarFontColor
{
    UIColor *color = [UIColor whiteColor];
    if (barFontColor != nil) {
        color = barFontColor;
    }
    return color;
}

+ (void)setBarFontColor:(UIColor *)color
{
    barFontColor = color;
}

static UIColor* btnTitleFontColor;

+ (UIColor *)getBtnTitleFontColor
{
    UIColor *color = [UIColor whiteColor];
    if (btnTitleFontColor != nil) {
        color = btnTitleFontColor;
    }
    return color;
}

+ (void)setBtnTitleFontColor:(UIColor *)color
{
    btnTitleFontColor = color;
}

+ (void)getFontsNames
{
    //这个方法用来列出自定义字体的name
    NSArray *familyNames =[[NSArray alloc]initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily = 0; indFamily < [familyNames count]; indFamily++) {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames =[[NSArray alloc]initWithArray:[UIFont fontNamesForFamilyName:[familyNames objectAtIndex:indFamily]]];
        //
        for (indFont = 0; indFont < [fontNames count]; indFont++) {
            NSLog(@"    Font name: %@",[fontNames objectAtIndex:indFont]);
        }
    }
}

+ (CGFloat)getTextWidth:(NSString *)txt font:(UIFont *)font
{
    if ((NSObject *)txt != [NSNull null]) {
        CGSize size = [txt sizeWithAttributes:@{NSFontAttributeName:font}];
        return size.width;
    } else {
        return 0;
    }
}

+ (CGFloat)getTextHeight:(NSString *)txt font:(UIFont *)font width:(CGFloat)width
{
    if ((NSObject *)txt != [NSNull null]) {
        CGSize maxSize = CGSizeMake(width, 10000);
        CGSize size = [txt sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat height = [txt isEqualToString:@""]? 0:size.height;
        
        return height;
    } else {
        return 0;
    }
}



@end
