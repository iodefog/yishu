//
//  FriendRecommandDTO.h
//  medtree
//
//  Created by tangshimi on 7/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "DTOBase.h"

@interface FriendRecommandDTO : DTOBase

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *backgroundImage;
@property (strong , nonatomic) NSArray *friendArray;

@end
