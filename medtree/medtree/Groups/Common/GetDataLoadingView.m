//
//  GetDataLoadingView.m
//  medtree
//
//  Created by 陈升军 on 15/4/27.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "GetDataLoadingView.h"
#import "ImageCenter.h"


@implementation GetDataLoadingView

- (void)createUI
{
    loadingView = [[UIImageView alloc] initWithFrame:CGRectZero];
    loadingView.userInteractionEnabled = YES;
    loadingView.image = [ImageCenter getBundleImage:@"get_data_loading.png"];
    [self addSubview:loadingView];
    
    noDataView = [[UIImageView alloc] initWithFrame:CGRectZero];
    noDataView.userInteractionEnabled = YES;
    noDataView.hidden = YES;
    noDataView.image = [ImageCenter getBundleImage:@"get_data_no_data.png"];
    [self addSubview:noDataView];
}

- (void)showNoData:(BOOL)sender
{
    loadingView.hidden = sender;
    noDataView.hidden = !sender;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    loadingView.frame = CGRectMake((size.width-82)/2, (size.height-82)/2, 82, 82);
    noDataView.frame = CGRectMake((size.width-120)/2, (size.height-44)/2, 120, 44);
}

@end
