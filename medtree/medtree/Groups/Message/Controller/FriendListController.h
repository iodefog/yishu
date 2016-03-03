//
//  FriendListController.h
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "AddressBookController.h"

@interface FriendListController : AddressBookController

@property (nonatomic, strong)UISearchBar *searchBar;

- (NSInteger)getMethodType_Net;

@end
