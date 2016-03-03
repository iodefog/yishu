//
//  HomeChannelMyInterestViewController.h
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
#import "HomeRecommendChannelDetailDTO.h"

typedef void(^ChoseInterstBlock)(NSArray *);

typedef NS_ENUM(NSUInteger, HomeChannelMyInterestViewControllerType) {
    HomeChannelMyInterestViewControllerTypeFirstChoseInterest,
    HomeChannelMyInterestViewControllerTypeNormalChoseInterest,
    HomeChannelMyInterestViewControllerTypePublishDiscussionChoseInterest
};

@interface HomeChannelMyInterestViewController : MedTreeBaseController

@property (nonatomic, strong) HomeRecommendChannelDetailDTO *channelDatailDTO;
@property (nonatomic, assign) HomeChannelMyInterestViewControllerType type;
@property (nonatomic, copy) dispatch_block_t updateBlock;
@property (nonatomic, copy) ChoseInterstBlock choseInterstBlock;

@end
