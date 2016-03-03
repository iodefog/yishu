//
//  ActionDTO.h
//  medtree
//
//  Created by 陈升军 on 14/12/27.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface ActionDTO : DTOBase

@property (nonatomic, strong) NSString      *action;
@property (nonatomic, strong) NSString      *data;
@property (nonatomic, strong) NSDate        *start_time;
@property (nonatomic, strong) NSDate        *elapsed_time;

+ (ActionDTO *)genAction:(NSInteger)action attr:(NSString *)attr;

@end
