//
//  AboutMeHeaderView.h
//  medtree
//
//  Created by tangshimi on 7/29/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseView.h"

@interface AboutMeHeaderView : BaseView

@property (nonatomic, copy) dispatch_block_t clickHeadBlock;
@property (nonatomic, copy) dispatch_block_t clickQRCodeBlock;

@end
