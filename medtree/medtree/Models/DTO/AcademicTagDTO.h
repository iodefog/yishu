//
//  AcademicTagDTO.h
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PairDTO.h"

typedef enum {
    AcademicTagShowType_Edit, //用户详情页学术标签展示
    AcademicTagShowType_Show, //自己的学术标签管理编辑页
} AcademicTagShowType;

@interface AcademicTagDTO : PairDTO

@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *tagCount;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) BOOL isLike;
@property (nonatomic, assign) CGRect lastItemFrame;
/**是否是编辑删除状态*/
@property (nonatomic, assign) BOOL isDelStatus;

/**此系统标签是否是当前用户标记的标签*/
@property (nonatomic, assign) BOOL isUserTag;
@property (nonatomic, assign) AcademicTagShowType showType;

@end
