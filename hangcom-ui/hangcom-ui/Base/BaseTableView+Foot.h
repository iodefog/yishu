//
//  BaseTableView+Foot.h
//  hangcom-ui
//
//  Created by 陈升军 on 15/2/8.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseTableView.h"

@interface BaseTableView (Foot)

- (void)setTableCellHeight:(CGFloat)height index:(NSIndexPath *)index;
- (void)setTableCellHeight1:(CGFloat)height index:(NSIndexPath *)index;
- (void)setTitleHeight:(NSArray *)array;
- (void)clearTableCellHeight;
- (void)addFootView;

- (CGFloat)tableSlideWithIndex:(NSIndexPath *)index inputHeight:(CGFloat)inputHeight;
- (void)tableSlideToBackWithHeight:(CGFloat)inputHeight;
- (CGFloat)tableCurrentCellHeightAtIndex:(NSIndexPath *)index;

@end
