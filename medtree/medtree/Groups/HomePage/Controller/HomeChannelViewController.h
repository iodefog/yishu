//
//  HomeViewController.h
//  medtree
//
//  Created by tangshimi on 7/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
@class HomeRecommendChannelDetailDTO;

@interface HomeChannelViewController : MedTreeBaseController

@property (nonatomic, strong) HomeRecommendChannelDetailDTO *channelDetailDTO;

@end
