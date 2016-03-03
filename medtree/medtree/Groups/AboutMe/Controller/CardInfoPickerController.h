//
//  AcademicPickerController.h
//  medtree
//
//  Created by 边大朋 on 15/8/10.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseController.h"

typedef enum
{
   PickerType_Gender,
   PickerType_Birthday,
}PickerType;

@interface CardInfoPickerController : BaseController

@property (nonatomic, assign) PickerType pickerType;
@property (nonatomic, weak) id parent;
@end
