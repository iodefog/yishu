//
//  SlideDTO.h
//  medtree
//
//  Created by 陈升军 on 15/4/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface SlideDTO : DTOBase

@property (nonatomic, assign) NSInteger slideType;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *title;

@end
