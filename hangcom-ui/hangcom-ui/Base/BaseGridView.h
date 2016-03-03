//
//  BaseGridView.h
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableView.h"
#import "BaseTableViewDelegate.h"

@class BaseCell;

@interface BaseGridView : BaseTableView {
    NSInteger   columnCount;
}

- (void)setGridColumn:(NSInteger)count;

@end
