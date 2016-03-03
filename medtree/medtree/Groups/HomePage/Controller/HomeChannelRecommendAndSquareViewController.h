//
//  HomeChannelRecommendViewController.h
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"
#import "HomeChannelViewController.h"
#import "HomeRecommendChannelDetailDTO.h"

typedef NS_ENUM(NSInteger, HomeChannelRecommendAndSquareViewControllerType) {
    HomeChannelRecommendAndSquareViewControllerTypeRecommend,
    HomeChannelRecommendAndSquareViewControllerTypeSquare
};

@interface HomeChannelRecommendAndSquareViewController : MedBaseTableViewController

@property (nonatomic, assign) HomeChannelRecommendAndSquareViewControllerType type;
@property (nonatomic, strong) HomeRecommendChannelDetailDTO *channelDetailDTO;

- (void)reloadData;

@end
