//
//  CellDTO.h
//  mcare-core
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTOBase.h"

@interface CellDTO : DTOBase

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL      isHideFootLineS;
@property (nonatomic, assign) BOOL      isShowFootLineL;
/** 右侧有image */
//@property (nonatomic, copy) NSString *other;
@property (nonatomic, assign) BOOL showSwitch;
/** key字体属性 */
@property (nonatomic, strong) NSDictionary *keyAttribute;

@property (nonatomic, assign) CGFloat   left;
@property (nonatomic, assign) CGFloat   right;
@property (nonatomic, assign) CGFloat   height;

@property (nonatomic, assign) BOOL isSelected;

@end
