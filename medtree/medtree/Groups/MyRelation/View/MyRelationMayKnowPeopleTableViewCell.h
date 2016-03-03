//
//  MyRelationMayKnowPeopleTableViewCell.h
//  medtree
//
//  Created by tangshimi on 8/4/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "BaseCell.h"
@class UserDTO;

typedef void(^myRelationMayKnowPeopleTableViewCellAddFriendBlock)(UserDTO *dto);

@interface MyRelationMayKnowPeopleTableViewCell : BaseCell

@end
