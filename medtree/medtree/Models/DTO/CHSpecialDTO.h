//
//  CHSpecialDTO.h
//  medtree
//
//  Created by 孙晨辉 on 15/9/21.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "DTOBase.h"

@interface CHSpecialDTO : DTOBase

/** 这段内容 */
@property (nonatomic, strong) NSString *text;

/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;

/** 这段特殊文字矩形框(数组里面存放CGRect) */
@property (nonatomic, strong) NSArray *rects;

@end
