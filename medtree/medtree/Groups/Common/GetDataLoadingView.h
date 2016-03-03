//
//  GetDataLoadingView.h
//  medtree
//
//  Created by 陈升军 on 15/4/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@interface GetDataLoadingView : BaseView
{
    UIImageView         *loadingView;
    UIImageView         *noDataView;
}

- (void)showNoData:(BOOL)sender;

@end
