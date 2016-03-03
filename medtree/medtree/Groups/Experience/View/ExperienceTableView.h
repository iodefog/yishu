//
//  ExperienceTableView.h
//  medtree
//
//  Created by 边大朋 on 15/6/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"
#import "LoadingTableView.h"
#import "BaseTableViewDelegate.h"

@protocol ExperienceTableViewDelegate <NSObject>

@required
- (void)selectTitle:(id)dto;

@optional
- (void)getMoreData;

@end

@interface ExperienceTableView : BaseView <BaseTableViewDelegate>
{
    LoadingTableView       *table;
    NSMutableArray         *dataList;
}

@property (nonatomic, assign) id<ExperienceTableViewDelegate> parent;
/** cell的name */
@property (nonatomic, strong) NSString      *ediTtitle;
@property (nonatomic, strong) NSString      *keyWord;
@property (nonatomic, assign) BOOL          footer;

- (void)setInfo:(NSArray *)array;
- (void)reloadArray;

@end
