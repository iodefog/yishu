//
//  UIView+FindUIViewController.m
//  medtree
//
//  Created by tangshimi on 12/10/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "UIView+FindUIViewController.h"

@implementation UIView (FindUIViewController)

- (UIViewController *) firstAvailableUIViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
