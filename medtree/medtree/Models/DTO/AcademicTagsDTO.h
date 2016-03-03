//
//  AcademicTagsDTO.h
//  medtree
//
//  Created by 边大朋 on 15/8/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"
#import "AcademicTagDTO.h"

@interface AcademicTagsDTO : DTOBase

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) AcademicTagShowType showType;

@end
