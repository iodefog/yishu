//
//  BaseTableView.h
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"
#import "BaseTableViewDelegate.h"

@class BaseCell;

@interface BaseTableView : RefreshTableView <UITableViewDataSource, UITableViewDelegate, BaseTableViewDelegate> {
    NSMutableArray  *dataArray;
    NSMutableArray  *titleArray;
    Class           CellClass;
    NSMutableDictionary *CellClasses;
    NSMutableArray  *sectionTitleHeightArray;
    NSMutableArray  *sectionHeaderArray;
    NSString        *headerBGColor;
    NSMutableArray  *sectionIndexTitles;
    NSMutableDictionary *tableHeightDict;
    NSMutableDictionary *tableHeightDict1;
    CGFloat         tableHeight;
    CGFloat         tableHeaderViewHeight;
    BOOL            isNeedFootView;
    NSString        *editButtonTitle;
}

- (void)setSectionHeaderViewBGColor:(NSString *)color;
- (void)setTitle:(NSArray *)array;
- (void)setData:(NSArray *)array;
- (NSMutableArray *)getData;
- (void)insertCell:(id)dto indexPath:(NSIndexPath *)indexPath;
- (void)setSectionTitleHeight:(NSArray *)array;
- (void)setSectionHeader:(NSArray *)array;
- (void)setSectionIndexTitles:(NSArray *)alpha;
- (void)registerCell:(Class)cell;
- (void)registerCells:(NSDictionary *)cells;
- (void)deleteData:(NSIndexPath *)indexPath;
- (void)setViewImages;
- (void)setTableHeaderViewHeight:(CGFloat)height;
- (void)setIsNeedFootView:(BOOL)isNeed;
- (void)setEditButtonTitle:(NSString *)title;
- (Class)getCellClass:(id)dto;
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath;


- (CGFloat)tableSlideWithIndex:(NSIndexPath *)index height:(CGFloat)height;
- (void)tableSlideBackWithHeight:(CGFloat)inputHeight;
- (CGFloat)tableCellHeightAtIndex:(NSIndexPath *)index;

@end
