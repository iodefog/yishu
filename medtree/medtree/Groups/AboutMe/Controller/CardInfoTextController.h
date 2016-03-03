//
//  CardInfoTextController.h
//  medtree
//
//  Created by 边大朋 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseController.h"

typedef enum
{
    CardInfoTextType_Name,
    CardInfoTextType_Sideline,
    CardInfoTextType_Achievement,
    CardInfoTextType_Birthplace,
    CardInfoTextType_Phone
} CardInfoTextType;

@interface CardInfoTextController : BaseController

@property (nonatomic, assign) CardInfoTextType textType;
@property (nonatomic, weak) id parent;

@end
