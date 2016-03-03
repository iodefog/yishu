//
//  MapTransitionAnimation.m
//  medtree
//
//  Created by tangshimi on 6/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MapTransitionAnimation.h"

@implementation MapTransitionAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [containerView insertSubview:toController.view belowSubview:fromController.view];
    
    [UIView transitionFromView:fromController.view
                        toView:toController.view
                      duration:[self transitionDuration:transitionContext] options:self.type == MapTransitionAnimationPushType ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        [transitionContext completeTransition:YES];
                        if (self.complete) {
                            self.complete();
                        }
                    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.75;
}

@end
