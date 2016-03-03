//
//  StatusView.h
//  medtree
//
//  Created by tangshimi on 6/15/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"

typedef enum {
    StatusViewLoadingStatusType = 1,
    StatusViewEmptyStatusType
}StatusViewStatusType;

@interface StatusView : BaseView

- (instancetype)initWithInView:(UIView *)inView;

- (void)showWithStatusType:(StatusViewStatusType)statusType;

- (void)hide;

@property (nonatomic, assign) StatusViewStatusType statusType;
@property (nonatomic, assign) BOOL removeFromSuperViewWhenHide;

@end
