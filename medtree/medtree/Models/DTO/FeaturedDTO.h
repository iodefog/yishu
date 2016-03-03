//
//  FeaturedDTO.h
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface FeaturedDTO : DTOBase

@property (nonatomic, strong) NSString    *name;
@property (nonatomic, strong) NSString    *summary;
@property (nonatomic, strong) NSString    *title;
@property (nonatomic, strong) NSString    *category;
@property (nonatomic, strong) NSString    *featuredID;

@property (nonatomic, strong) NSDate      *created;

@property (nonatomic, strong) NSMutableArray    *images;
@property (nonatomic, strong) NSMutableArray    *urls;

@property (nonatomic, assign) NSInteger    view_count;
@property (nonatomic, assign) NSInteger    style;

@end
