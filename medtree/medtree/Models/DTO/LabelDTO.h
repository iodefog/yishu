//
//  LabelDTO.h
//  medtree
//
//  Created by sam on 11/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "DTOBase.h"

@interface LabelDTO : DTOBase

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *image;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, assign) BOOL      isSelected;


@end
