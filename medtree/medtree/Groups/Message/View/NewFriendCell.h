//
//  NewFriendCell.h
//  medtree
//
//  Created by sam on 9/26/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonCell.h"

@class ImageButton;

@interface NewFriendCell : PersonCell {
    UIButton *acceptButton;
    UIButton *inviteButton;
}

@end
