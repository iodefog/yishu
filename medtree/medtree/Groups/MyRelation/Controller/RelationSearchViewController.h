//
//  RelationSearchViewController.h
//  medtree
//
//  Created by tangshimi on 6/11/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"

typedef enum {
    RelationSearchViewControllerClassmateType,
    RelationSearchViewControllerSchoolmateType,
    RelationSearchViewControllerColleagueType,
    RelationSearchViewControllerPeerType,
    RelationSearchViewControllerFriendType,
    RelationSearchViewControllerFriendOfFriendType,
    RelationSearchViewControllerStrangerType
}RelationSearchViewControllerType;

@interface RelationSearchViewController : MedBaseTableViewController

@property (nonatomic, assign)RelationSearchViewControllerType type;

@end
