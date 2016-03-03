//
//  CircularProgressView.m
//  CircularProgressView
//
//  Created by lyuan on 13-7-11.
//  Copyright (c) 2013年 lyuan. All rights reserved.
//

#import "CircularProgressView.h"

#define DEGREES_2_RADIANS(x) (0.0174532925 * (x))

@implementation CircularProgressView

@synthesize trackTintColor;
@synthesize progressTintColor;
@synthesize progress;
@synthesize progressLabel;
@synthesize isShowLabel;
@synthesize fontFloat;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        isShowLabel = NO;
        
        progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        progressLabel.text = @"0%";
        progressLabel.textColor = [UIColor whiteColor];
        progressLabel.textAlignment = NSTextAlignmentCenter;
        progressLabel.backgroundColor = [UIColor clearColor];
        progressLabel.hidden = !isShowLabel;
        [self addSubview:progressLabel];
    }
    return self;
}

- (UIColor *)trackTintColor
{
    if (!trackTintColor) {
        trackTintColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3f];
    }
    return trackTintColor;
}

- (UIColor *)progressTintColor
{
    if (!progressTintColor) {
        progressTintColor = [UIColor whiteColor];
    }
    return progressTintColor;
}

- (void)setFontFloat:(CGFloat)font
{
    fontFloat = font;
    progressLabel.font = [UIFont systemFontOfSize:font];
    [self setNeedsDisplay];
}

- (void)setIsShowLabel:(BOOL)isShow
{
    isShowLabel = isShow;
    progressLabel.hidden = !isShowLabel;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)p
{
    progress = p;
    progressLabel.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    [self setNeedsDisplay];
}

- (void)layoutSubviews
{
    UIFont *font = [UIFont systemFontOfSize:fontFloat];
    CGSize textSize = CGSizeMake(200, 200);
    
    NSString *text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    CGSize sizeStr = [text sizeWithFont:font constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    /*
     NSDictionary *attribute = @{NSFontAttributeName: font};
     CGSize sizeStr = [text boundingRectWithSize:textSize
     options:NSStringDrawingUsesFontLeading
     attributes:attribute
     context:nil].size;
     */
    progressLabel.frame = CGRectMake(0, self.frame.size.height-40-sizeStr.height, self.frame.size.width, sizeStr.height);
}

- (void)drawRect:(CGRect)rect
{
    CGPoint centerPoint = CGPointMake(rect.size.height / 2, rect.size.width / 2);
    CGFloat radius = MIN(rect.size.height, rect.size.width) / 2;
    
    CGFloat pathWidth = radius * 0.3f;
    
    CGFloat radians = DEGREES_2_RADIANS((self.progress*359.9)-90);
    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    CGPoint endPoint = CGPointMake(xOffset, yOffset);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.trackTintColor setFill];
    CGMutablePathRef trackPath = CGPathCreateMutable();
    CGPathMoveToPoint(trackPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(trackPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), DEGREES_2_RADIANS(-90), NO);
    CGPathCloseSubpath(trackPath);
    CGContextAddPath(context, trackPath);
    CGContextFillPath(context);
    CGPathRelease(trackPath);
    
    [self.progressTintColor setFill];
    CGMutablePathRef progressPath = CGPathCreateMutable();
    CGPathMoveToPoint(progressPath, NULL, centerPoint.x, centerPoint.y);
    CGPathAddArc(progressPath, NULL, centerPoint.x, centerPoint.y, radius, DEGREES_2_RADIANS(270), radians, NO);
    CGPathCloseSubpath(progressPath);
    CGContextAddPath(context, progressPath);
    CGContextFillPath(context);
    CGPathRelease(progressPath);
    
    CGContextAddEllipseInRect(context, CGRectMake(centerPoint.x - pathWidth/2, 0, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextAddEllipseInRect(context, CGRectMake(endPoint.x - pathWidth/2, endPoint.y - pathWidth/2, pathWidth, pathWidth));
    CGContextFillPath(context);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);;
    CGFloat innerRadius = radius * 0.7;
	CGPoint newCenterPoint = CGPointMake(centerPoint.x - innerRadius, centerPoint.y - innerRadius);
	CGContextAddEllipseInRect(context, CGRectMake(newCenterPoint.x, newCenterPoint.y, innerRadius*2, innerRadius*2));
	CGContextFillPath(context);
//    CGSize size = rect.size;
//    CGFloat x = (size.width-sizeStr.width)/2;
//    CGFloat y = (size.height-sizeStr.height)/2;
//    [text drawInRect:CGRectMake(x, y, sizeStr.width, sizeStr.height) withAttributes:attribute];
}

@end
