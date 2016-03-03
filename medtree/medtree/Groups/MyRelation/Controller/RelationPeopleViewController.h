//
//  RelationPeopleViewController.h
//  medtree
//
//  Created by tangshimi on 6/9/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SearchBarTableViewController.h"

typedef enum {
    RelationPeopleViewControllerClassmateType, //同学
    RelationPeopleViewControllerSchoolmateType, //校友
    RelationPeopleViewControllerColleagueType, //同事
    RelationPeopleViewControllerPeerType, //同行
    RelationPeopleViewControllerFriendType, //好友
    RelationPeopleViewControllerFriendOfFriendType, //好友的好友
    
    RelationPeopleViewControllerMapType //地图
}RelationPeopleViewControllerType;

@interface RelationPeopleViewController : SearchBarTableViewController

@property (nonatomic, assign) RelationPeopleViewControllerType type;

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, copy) NSString *topTitle;

@end
