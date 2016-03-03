//
//  NewCountDTO.h
//
//  Created by Qiang Zhuang on 12/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@interface NewCountDTO : DTOBase

@property (nonatomic, strong) NSString      *key;
@property (nonatomic, assign) NSInteger     value;
@property (nonatomic, assign) NSInteger     type;
@property (nonatomic, assign) NSInteger     unread;

@end
