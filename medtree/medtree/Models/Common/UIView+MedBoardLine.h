//
//  UIView+MedBoardLine.h
//  medtree
//
//  Created by tangshimi on 10/26/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, MedBoardLineDirection) {
    MedBoardLineDirectionNone = 0,
    MedBoardLineDirectionTop = 1 << 0,
    MedBoardLineDirectionBottom = 1 << 1,
    MedBoardLineDirectionLeft = 1 << 2,
    MedBoardLineDirectionRight = 1 << 3,
};

@interface UIView (MedBoardLine)

- (void)addBoardLine:(MedBoardLineDirection)dirction;

@end
