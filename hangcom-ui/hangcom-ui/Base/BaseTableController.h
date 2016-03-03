//
//  BaseTableController.h
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseController.h"
#import "BaseTableViewDelegate.h"
#import "BaseTableView.h"

@class BaseCell;

@interface BaseTableController : BaseController <BaseTableViewDelegate> {
    BaseTableView *table;
}

- (void)createTable;
- (BOOL)isLastCell:(NSIndexPath *)indexPath;
- (BOOL)isEndCell:(NSIndexPath *)indexPath;
- (BOOL)isAllowDelete:(NSIndexPath *)indexPath;

@end
