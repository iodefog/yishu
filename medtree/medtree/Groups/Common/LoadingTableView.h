//
//  LoadingTableView.h
//  medtree
//
//  Created by sam on 9/23/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseTableView.h"

@class LoadingView;

@interface LoadingTableView : BaseTableView {
    LoadingView *_headerView;
    LoadingView *_footerView;
}

@end
