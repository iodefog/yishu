//
//  TableController.h
//  medtree
//
//  Created by sam on 8/8/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseTableController.h"
#import "GetDataLoadingView.h"


@interface TableController : BaseTableController
{
    GetDataLoadingView  *dataLoading;
}

- (void)getDataFromLocal;
- (void)requestData;
- (void)requestDataMore;
- (void)parseData:(id)JSON;
- (void)parseDataError:(id)JSON;

- (void)cleanData;
- (void)loadData;
- (void)reloadData;

- (void)clickBack;
- (UIButton *)createBackButton;

- (void)showErrorAlert:(NSString *)message;

@property (nonatomic, assign) id parent;

@end
