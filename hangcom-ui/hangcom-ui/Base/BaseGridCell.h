//
//  BaseGridCell.h
//  hangcom-ui
//
//  Created by sam on 11/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseCell.h"

@interface BaseGridCell : BaseCell {
    NSArray         *sourceArray;
    NSMutableArray  *viewArray;
    Class           ViewClass;
    NSInteger       columnCount;
}

- (void)setColumnCount:(NSNumber *)count;
- (void)registerView:(Class)view;

@end
