//
//  EventFeedDetailViewController.h
//  medtree
//
//  Created by tangshimi on 8/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "TableController.h"
@class MedFeedDTO;

@interface EventFeedDetailViewController : TableController

@property (nonatomic, strong) MedFeedDTO *feedDTO;

@property (nonatomic, copy) dispatch_block_t updateBlock;

@end
