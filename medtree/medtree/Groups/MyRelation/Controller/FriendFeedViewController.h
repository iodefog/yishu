//
//  FriendFeedViewController.h
//  medtree
//
//  Created by tangshimi on 8/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "TableController.h"

@class UserDTO;
/** 动态数据源类型 */
typedef  NS_ENUM(NSInteger, FriendFeedViewControllerDataType) {
    FriendFeedViewControllerDataType_Friend,
    FriendFeedViewControllerDataType_Person,
};

@interface FriendFeedViewController : TableController

@property (nonatomic, assign) FriendFeedViewControllerDataType feedType;
@property (nonatomic, strong) UserDTO *userDTO;
@end
