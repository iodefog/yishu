//
//  UserTagsDTO.h
//  medtree
//
//  Created by 边大朋 on 15-4-4.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@class UserDTO;
@interface UserTagsDTO : DTOBase
@property (nonatomic, strong) NSMutableArray    *tags;
@property (nonatomic, assign) NSInteger         type;
@property (nonatomic, assign) NSInteger         maxWidth;
@property (nonatomic, strong) UserDTO           *userDTO;
@property (nonatomic, assign) NSInteger         pageType;
@property (nonatomic, assign) BOOL              clearCache;
@end
