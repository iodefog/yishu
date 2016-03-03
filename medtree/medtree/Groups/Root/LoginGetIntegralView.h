//
//  LoginGetIntegralView.h
//  medtree
//
//  Created by tangshimi on 9/17/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "BaseView.h"
@class SignDTO;

@interface LoginGetIntegralView : BaseView

@property (nonatomic, strong) SignDTO *signDTO;
@property (nonatomic, assign, readonly) BOOL todayGetIntegral;
@property (nonatomic, copy) dispatch_block_t getMoreIntegralBlock;

- (void)setTodayAlreadyGetIntergtal;
- (void)showInView:(UIView *)inView;

@end
