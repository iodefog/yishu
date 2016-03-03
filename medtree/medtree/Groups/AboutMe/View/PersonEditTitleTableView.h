//
//  PersonEditTitleTableView.h
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"
#import "LoadingTableView.h"
#import "BaseTableViewDelegate.h"

@protocol PersonEditTitleTableViewDelegate <NSObject>

- (void)selectTitle;
- (void)getMoreData;

@end

@interface PersonEditTitleTableView : BaseView <BaseTableViewDelegate>
{
    LoadingTableView       *table;
    NSMutableArray         *titleArray;
}

@property (nonatomic, assign) id<PersonEditTitleTableViewDelegate> parent;
@property (nonatomic, strong) NSString      *ediTtitle;
@property (nonatomic, assign) BOOL          isSearch;
@property (nonatomic, strong) NSString      *keyWord;

@property (nonatomic, strong) NSMutableDictionary *typeDict;

- (void)setInfo:(NSArray *)array;
- (void)reloadArray;

@end
