//
//  MateUserDTO.h
//  medtree
//
//  Created by 陈升军 on 15/4/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface MateUserDTO : DTOBase

@property (nonatomic, strong) NSString          *mateID;
@property (nonatomic, strong) NSString          *name;
@property (nonatomic, strong) NSString          *marked_user_id;

@property (nonatomic, assign) NSInteger         match_type;
@property (nonatomic, assign) NSInteger         relation;
@property (nonatomic, assign) NSInteger         same_name_count;
@property (nonatomic, assign) NSInteger         status;

@property (nonatomic, strong) NSMutableArray    *phones_encrypted;
@property (nonatomic, strong) NSMutableArray    *matched_users;

@end
