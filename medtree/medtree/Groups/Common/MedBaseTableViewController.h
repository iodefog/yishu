//
//  MedBaseTableViewController.h
//  medtree
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "BaseController.h"
#import <MedBaseTableView.h>

@interface MedBaseTableViewController : BaseController
{
    MedBaseTableView *table;
}

@property (nonatomic, strong) MedBaseTableView *tableView;
@property (nonatomic, assign) BOOL enableHeader;
@property (nonatomic, assign) BOOL enableFooter;
@property (nonatomic, assign) BOOL showNoMorelogo;

@property (nonatomic, strong) UIView *dataEmptyView;

@property (nonatomic, assign) BOOL hideNoNetworkImage;

- (UIButton *)createBackButton;

- (void)triggerPullToRefresh;
- (void)stopLoading;

- (void)showLoadingView;
- (void)hideLoadingView;

- (void)showDataEmptyView;
- (void)hideDataEmptyView;

@end
