//
//  CHContentTextView.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/21.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CHContentTextView.h"
#import "CHSpecialDTO.h"

const NSInteger coverTag = 999;

@implementation CHContentTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.editable = NO;
        self.scrollEnabled = NO;
        self.textContainerInset = UIEdgeInsetsMake(0, -5, 0, -5);
    }
    return self;
}

- (void)setupSpecialRects
{
    for (CHSpecialDTO *special in self.specials) {
        self.selectedRange = special.range;
        NSArray *selectionRects = [self selectionRectsForRange:self.selectedTextRange];
        self.selectedRange = NSMakeRange(0, 0);
        NSMutableArray *rects = [NSMutableArray array];
        for (UITextSelectionRect *selectionRect in selectionRects) {
            CGRect rect = selectionRect.rect;
            if (rect.size.width == 0 || rect.size.height == 0) continue;
            [rects addObject:[NSValue valueWithCGRect:rect]];
        }
        special.rects = rects;
    }
}

- (CHSpecialDTO *)touchingSpecialWithPoint:(CGPoint)point
{
    for (CHSpecialDTO *special in self.specials) {
        for (NSValue *rectValue in special.rects) {
            CGRect rect = rectValue.CGRectValue;
            if (CGRectContainsPoint(rect, point)) {
                return special;
            }
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInView:self];
    [self setupSpecialRects];
    CHSpecialDTO *special = [self touchingSpecialWithPoint:loc];
    for (NSValue *rectValue in special.rects) {
        UIView *cover = [[UIView alloc] init];
        cover.backgroundColor = [UIColor lightGrayColor];
        cover.frame = rectValue.CGRectValue;
        cover.tag = coverTag;
        cover.layer.cornerRadius = 5;
        [self insertSubview:cover atIndex:0];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self touchesCancelled:touches withEvent:event];
    });
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView *childView in self.subviews) {
        if (childView.tag == coverTag) {
            [childView removeFromSuperview];
        }
    }
}

#pragma mark - 
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    [self setupSpecialRects];
    if ([self touchingSpecialWithPoint:point]) {
        return YES;
    } else {
        return NO;
    }
}

@end
