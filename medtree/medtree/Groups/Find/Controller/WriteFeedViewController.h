//
//  WriteFeedViewController.h
//  medtree
//
//  Created by tangshimi on 8/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"

@interface WriteFeedViewController : MedTreeBaseController

@property (nonatomic, copy) NSString *navigationTitle;
@property (nonatomic, copy) dispatch_block_t publishFeedSuccessBlock;

@end
