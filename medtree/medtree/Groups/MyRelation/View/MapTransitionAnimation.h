//
//  MapTransitionAnimation.h
//  medtree
//
//  Created by tangshimi on 6/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MapTransitionAnimationPopType,
    MapTransitionAnimationPushType
}MapTransitionAnimationType;

@interface MapTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign)MapTransitionAnimationType type;

@property (nonatomic, copy) dispatch_block_t complete;

@end
