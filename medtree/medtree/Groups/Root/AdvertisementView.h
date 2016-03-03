//
//  AdvertisementView.h
//  medtree
//
//  Created by tangshimi on 7/3/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"
@class RecommendDTO;

@interface AdvertisementView : BaseView

@property (strong, nonatomic) RecommendDTO *recommendDTO;
@property (copy, nonatomic) dispatch_block_t clickBlock;
@property (nonatomic, assign, readonly) BOOL todayShowAdvertisementView;

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inView;

- (void)showAnimated:(BOOL)animated;

@end
