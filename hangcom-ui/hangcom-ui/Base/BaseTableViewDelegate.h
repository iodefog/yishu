//
//  BaseTableViewDelegate.h
//
//  Created by sam on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseCell;
@class BaseTableView;

@protocol BaseTableViewDelegate <NSObject>

@optional

- (void)clickCell:(id)dto action:(NSNumber *)action;
- (void)clickCell:(id)dto index:(NSIndexPath *)index;
- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action;
- (void)clickTable;

- (void)showProgress;
- (void)hideProgress;
- (void)loadHeader:(BaseTableView *)table;
- (void)loadFooter:(BaseTableView *)table;

- (BOOL)isLastCell:(NSIndexPath *)indexPath;
- (BOOL)isEndCell:(NSIndexPath *)indexPath;
- (BOOL)isAllowDelete:(NSIndexPath *)indexPath;


@end
