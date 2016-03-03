//
//  UIView+MedBoardLine.m
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "UIView+MedBoardLine.h"
#import "UIColor+Colors.h"

static NSString *const kBoardLineColor = @"#D7D7D7";

@implementation UIView (MedBoardLine)

- (void)addBoardLine:(MedBoardLineDirection)dirction
{
    if (dirction & MedBoardLineDirectionTop) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorFromHexString:kBoardLineColor].CGColor;
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 0.5);
        [self.layer addSublayer:layer];
    }
    
    if (dirction & MedBoardLineDirectionBottom) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorFromHexString:kBoardLineColor].CGColor;
        layer.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5);
        [self.layer addSublayer:layer];
    }
    
    if (dirction & MedBoardLineDirectionLeft) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorFromHexString:kBoardLineColor].CGColor;
        layer.frame = CGRectMake(0, 0, 0.5, CGRectGetHeight(self.frame));
        [self.layer addSublayer:layer];
    }
    
    if (dirction & MedBoardLineDirectionRight) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor colorFromHexString:kBoardLineColor].CGColor;
        layer.frame = CGRectMake(0, CGRectGetWidth(self.frame) - 0.5, 0.5, CGRectGetHeight(self.frame));
        [self.layer addSublayer:layer];
    }
}

@end
