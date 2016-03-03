//
//  ColorUtil.m
//  aqgj_dial
//
//  Created by Sam on 11-12-21.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil


+ (UIColor *)getColor:(NSString *)hexColor alpha:(CGFloat)alpha
{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	
	range.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];	
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:alpha];
}

UIColor *navigationColor = nil;
+ (void)setNavigationColor:(UIColor *)color
{
    if (navigationColor != nil) {
        navigationColor = nil;
    }
    navigationColor = color;
}

+ (UIColor *)getNavigationColor
{
    return navigationColor;
}

UIColor *backgroundColor = nil;
+ (void)setBackgroundColor:(UIColor *)color
{
    if (backgroundColor != nil) {
        backgroundColor = nil;
    }
    backgroundColor = color;
}

+ (UIColor *)getBackgroundColor
{
    return backgroundColor;
}

UIImageView *imageView = nil;
+ (void)setBackgroundImageView:(UIImage *)bgImage size:(CGSize)size
{
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        imageView.userInteractionEnabled = YES;
    }
    imageView.image = bgImage;
}

+(UIImageView *)getBackgroundImageView
{
    return imageView;
}

NSInteger  colorRow = 0;
+ (NSInteger)getColorRow
{
    return colorRow;
}

+ (void)setColorRow:(NSInteger)cRow
{
    NSString *tempRow = [NSString stringWithFormat:@"%@", @(cRow)];
    [[NSUserDefaults standardUserDefaults] setObject:tempRow forKey:@"navigationColorRow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    colorRow = cRow;
}


static UIColor *textColor;

+ (void)setTextColor:(UIColor *)color
{
    textColor = color;
}

+ (UIColor *)getTextColor
{
    if (textColor == nil) {
        textColor = [UIColor blackColor];
    }
    return textColor;
}

+ (NSString *)getColorString:(BOOL)isRandom atIndex:(NSInteger)atIndex
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"70DB93",
                             @"5C3317",
                             @"9F5F9F",
                             @"B5A642",
                             @"D9D919",
                             @"A62AA2",
                             @"8C7853",
                             @"A67D3D",
                             @"5F9F9F",
                             @"D98719",
                             @"B87333",
                             @"FF7F00",
                             @"42426F",
                             @"5C4033",
                             @"2F4F2F",
                             @"4A766E",
                             @"4F4F2F",
                             @"9932CD",
                             @"871F78",
                             @"6B238E",
                             @"2F4F4F",
                             @"97694F",
                             @"7093DB",
                             @"855E42",
                             @"545454",
                             @"856363",
                             @"D19275",
                             @"8E2323",
                             @"238E23",
                             @"CD7F32",
                             @"DBDB70",
                             @"C0C0C0",
                             @"527F76",
                             @"93DB70",
                             @"215E21",
                             @"4E2F2F",
                             @"9F9F5F",
                             @"A8A8A8",
                             @"8F8FBD",
                             @"E9C2A6",
                             @"32CD32",
                             @"E47833",
                             @"8E236B",
                             @"32CD99",
                             @"3232CD",
                             @"6B8E23",
                             @"9370DB",
                             @"426F42",
                             @"7F00FF",
                             @"70DBDB",
                             @"DB7093",
                             @"A68064",
                             @"2F2F4F",
                             @"23238E",
                             @"4D4DFF",
                             @"FF6EC7",
                             @"00009C",
                             @"CFB53B",
                             @"FF7F00",
                             @"FF2400",
                             @"DB70DB",
                             @"8FBC8F",
                             @"BC8F8F",
                             @"EAADEA",
                             @"5959AB",
                             @"6F4242",
                             @"8C1717",
                             @"238E68",
                             @"6B4226",
                             @"8E6B23",
                             @"3299CC",
                             @"007FFF",
                             @"FF1CAE",
                             @"236B8E",
                             @"38B0DE",
                             @"DB9370",
                             @"5C4033",
                             @"4F2F4F",
                             @"CC3299",
                             @"99CC32",
                             @"FF0000",
                             @"0000FF",
                             @"FF00FF",
                             @"70DB93",
                             nil];
    NSString *color = @"";
    if (isRandom) {
        color = [array objectAtIndex:arc4random()%array.count];
    } else {
        color = [array objectAtIndex:atIndex];
    }
    return color;
}

+ (UIColor *)getRandomColor:(BOOL)isRandom atIndex:(NSInteger)atIndex
{
    return [ColorUtil getColor:[ColorUtil getColorString:YES atIndex:atIndex] alpha:1];
}

@end
