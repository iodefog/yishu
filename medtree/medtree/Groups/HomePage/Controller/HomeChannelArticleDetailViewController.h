//
//  HomeChannelArticleDetailViewController.h
//  medtree
//
//  Created by tangshimi on 8/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedTreeBaseController.h"
@class HomeArticleAndDiscussionDTO;

typedef void(^HomeChannelArticleDetailViewControllerUpdateBlock)(HomeArticleAndDiscussionDTO *);

@interface HomeChannelArticleDetailViewController : MedTreeBaseController

@property (nonatomic, strong) HomeArticleAndDiscussionDTO *articleDTO;
@property (nonatomic, copy) HomeChannelArticleDetailViewControllerUpdateBlock updateBlock;
@property (nonatomic, copy) NSString *articleID;

@end
