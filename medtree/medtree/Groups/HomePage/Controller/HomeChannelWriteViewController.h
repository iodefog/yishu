//
//  HomeChannelWriteViewController.h
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
@class HomeRecommendChannelDetailDTO;
@class HomeArticleAndDiscussionDTO;

typedef NS_ENUM(NSInteger, HomeChannelWriteViewControllerType) {
    HomeChannelWriteViewControllerTypePublish,
    HomeChannelWriteViewControllerTypeComment,
    HomeChannelWriteViewControllerTypeEmploymentComment
};

@interface HomeChannelWriteViewController : MedTreeBaseController

@property (nonatomic, assign) HomeChannelWriteViewControllerType type;
@property (nonatomic, strong) HomeRecommendChannelDetailDTO *channelDetailDTO;
@property (nonatomic, strong) HomeArticleAndDiscussionDTO *articleAndDiscussionDTO;
@property (nonatomic, copy) dispatch_block_t updateBlock;

@property (nonatomic, copy) NSString *employmentID;

@end
