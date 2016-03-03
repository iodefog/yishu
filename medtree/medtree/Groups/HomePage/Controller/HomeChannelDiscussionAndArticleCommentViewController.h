//
//  HomeChannelHelpDetailViewController.h
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"
@class HomeArticleAndDiscussionDTO;

typedef NS_ENUM(NSInteger, HomeChannelDiscussionAndArticleCommentViewControllerType) {
    HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle,
    HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment,
};

typedef void(^HomeChannelDiscussionAndArticleCommentViewControllerUpdateBlock)(HomeArticleAndDiscussionDTO *);

@interface HomeChannelDiscussionAndArticleCommentViewController : MedBaseTableViewController

@property (nonatomic, strong) HomeArticleAndDiscussionDTO *articleAndDiscussionDTO;
@property (nonatomic, copy) HomeChannelDiscussionAndArticleCommentViewControllerUpdateBlock updateBlock;
@property (nonatomic, copy) NSString *articleAndDiscussionID;

@property (nonatomic, copy) dispatch_block_t deleteBlock;

@property (nonatomic, assign) HomeChannelDiscussionAndArticleCommentViewControllerType type;

@property (nonatomic, copy) NSString *employmentID;

@property (nonatomic, copy) dispatch_block_t addSpeakBlock;

@end
