//
//  NSString+Extension.m
//  medtree
//
//  Created by tangshimi on 5/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+ (CGSize)sizeForString:(NSString *)string Size:(CGSize)size Font:(UIFont *)font
{
    return [NSString sizeForString:string Size:size Font:font Lines:0];
}

+ (CGSize)sizeForString:(NSString *)string Size:(CGSize)size Font:(UIFont *)font Lines:(NSInteger)lines
{
    if (string == nil || [string isEqualToString:@""]) {
        return CGSizeZero;
    }
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    textView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
    
    textView.textContainer.maximumNumberOfLines = lines;
    textView.font = font;
    textView.text = string;
    
    CGSize deSize = [textView sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)];
    
    return deSize;
}

+ (CGSize)labelSizeForString:(NSString*)string Size:(CGSize)size Font:(UIFont*)font
{
    return [self labelSizeForString:string Size:size Font:font Lines:0];
}

+ (CGSize)labelSizeForString:(NSString*)string Size:(CGSize)size Font:(UIFont*)font Lines:(NSInteger)lines
{
    if (string == nil || [string isEqualToString:@""]) {
        return CGSizeZero;
    }

    static UILabel *label;
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }else{
        label.frame = CGRectMake(0, 0, size.width, size.height);
    }
    label.font = font;
    label.text = string;
    label.numberOfLines = lines;
    CGRect rect = [label textRectForBounds:label.frame limitedToNumberOfLines:lines];
    
    if(rect.size.height<0) {
        rect.size.height=0;
    }
    
    if (rect.size.width<0) {
        rect.size.width=0;
    }

    return rect.size;
}

- (CGSize)sizefitLabelInSize:(CGSize)size Font:(UIFont *)font
{
    if (self == nil || [self isEqualToString:@""]) {
        return CGSizeZero;
    }
    
    UILabel *   label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, 0)];
    label.font = font;
    label.text = self;
    label.numberOfLines = 0;
    CGSize deSize = [label sizeThatFits:CGSizeMake(size.width,CGFLOAT_MAX)];
    
    return deSize;
}

- (CGFloat)getStringWithFont:(UIFont *)font
{
    return [self getStringWidthInWidth:MAXFLOAT font:font];
}

- (CGFloat)getStringWidthInWidth:(CGFloat)maxWidth font:(UIFont *)font
{
    CGFloat width = [self sizeWithAttributes:@{NSFontAttributeName:font}].width;
    return width > maxWidth ? maxWidth : width;
}

@end
