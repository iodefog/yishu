//
//  FriendRequestController.h
//  medtree
//
//  Created by 陈升军 on 14/12/30.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "TableController.h"

typedef enum {
    MethodType_Controller_Privacy               = 800,
    MethodType_Controller_Add                   = 801,
    MethodType_Controller_Accept                = 802,
} Method_Controller;

@interface FriendRequestController : TableController

@property (nonatomic, copy) dispatch_block_t updateBlock;

@property (nonatomic, strong) NSDictionary *dataDict;

@end
