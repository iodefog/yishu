//
//  BaseTableView+Foot.m
//  hangcom-ui
//
//  Created by 陈升军 on 15/2/8.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseTableView+Foot.h"
#import "ColorUtil.h"

@implementation BaseTableView (Foot)

- (void)setTableCellHeight:(CGFloat)height index:(NSIndexPath *)index
{
    if ([tableHeightDict allKeys].count == 0) {
        tableHeight = tableHeight + height;
        [tableHeightDict setObject:@[@{@"row":[NSNumber numberWithInteger:index.row],@"height":[NSNumber numberWithFloat:height]}] forKey:[NSString stringWithFormat:@"%@", @(index.section)]];
    } else {

        NSMutableArray *array = [NSMutableArray arrayWithArray:[tableHeightDict objectForKey:[NSString stringWithFormat:@"%@", @(index.section)]]];
        if (array.count > 0) {
            BOOL isFind = NO;
            for (int i = 0; i < array.count; i ++) {
                NSMutableDictionary *dict = [array objectAtIndex:i];
                if ([[dict objectForKey:@"row"] integerValue] == index.row) {
                    isFind = YES;
                    break;
                }
            }
            if (!isFind) {
                [array addObject:@{@"row":[NSNumber numberWithInteger:index.row],@"height":[NSNumber numberWithFloat:height]}];
                tableHeight = tableHeight + height;
                [tableHeightDict setObject:array forKey:[NSString stringWithFormat:@"%@", @(index.section)]];
            }
        } else {
            tableHeight = tableHeight + height;
            [tableHeightDict setObject:@[@{@"row":[NSNumber numberWithInteger:index.row],@"height":[NSNumber numberWithFloat:height]}] forKey:[NSString stringWithFormat:@"%@", @(index.section)]];
        }
    }
    if (isNeedFootView) {
        [self addFootView];
    }
}

static int cellSection,cellRow;

- (void)setTableCellHeight1:(CGFloat)height index:(NSIndexPath *)index
{
    NSNumber *section = [NSNumber numberWithInteger:index.section];
    NSNumber *row = [NSNumber numberWithInteger:index.row];
    if (!tableHeightDict1[section])
    {
        [tableHeightDict1 setObject:[NSMutableDictionary dictionary] forKey:section];
    }
    
    if (cellSection != index.section)
    {
        // 计算上一个所有行
        NSUInteger maxRow = [tableHeightDict1[section] allKeys].count;
        if (maxRow > cellRow)
        {
            for (int i = (cellRow + 1); i < maxRow; i ++)
            {
                [tableHeightDict1[@(cellSection)] removeObjectForKey:@(i)];
            }
        }
        cellSection = (int)index.section;
    }
    cellRow = [row intValue];
    
    if (![tableHeightDict1[section] objectForKey:row])
    {
        [tableHeightDict1[section] setObject:@(height) forKey:row];
    }
    else
    {// 有数据
        [tableHeightDict1[section] setObject:@(height) forKey:row];
    }
    
    if (isNeedFootView) {
        [self addFootView];
    }
}

- (void)addFootView
{
    if (tableHeight < self.frame.size.height) {
        UIView *foot = [self tableFooterView];
        if (foot.frame.size.height == self.frame.size.height-tableHeight) {
            return;
        } else {
            foot = nil;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-tableHeight)];
            view.backgroundColor = [ColorUtil getBackgroundColor];
            [self setTableFooterView:view];
        }
    } else {
        [self setTableFooterView:nil];
    }
}

- (void)setTitleHeight:(NSArray *)array
{
    tableHeight = 0;
    tableHeight = tableHeight + tableHeaderViewHeight;
    for (int i = 0; i < array.count; i ++) {
        tableHeight = tableHeight+[[array objectAtIndex:i] floatValue];
    }
}

- (void)clearTableCellHeight
{
    tableHeight = 0;
    tableHeight = tableHeight + tableHeaderViewHeight;
    [tableHeightDict removeAllObjects];
}

- (CGFloat)tableSlideWithIndex:(NSIndexPath *)index inputHeight:(CGFloat)inputHeight
{
    CGFloat height = 0;
    for (int i = 0; i < [[tableHeightDict allKeys] count]; i ++) {
        NSInteger section = [[[tableHeightDict allKeys] objectAtIndex:i] integerValue];
        if (section < index.section || section == index.section) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[tableHeightDict objectForKey:[NSString stringWithFormat:@"%@", @(section)]]];
            for (int j = 0; j < array.count; j ++) {
                NSMutableDictionary *dict = [array objectAtIndex:j];
                if (section == index.section) {
                    NSInteger row = [[dict objectForKey:@"row"] integerValue];
                    if (row < index.row || row == index.row) {
                        height += [[dict objectForKey:@"height"] integerValue];
                    } else {
                        break;
                    }
                } else {
                    height += [[dict objectForKey:@"height"] integerValue];
                }
            }
        }
    }
    
    CGFloat offsetY = self.contentOffset.y;
//    NSLog(@"offsetY ---- %f", offsetY);
    
    if (height-self.contentOffset.y > self.frame.size.height-inputHeight) {
        [self setContentOffset:CGPointMake(0, height-self.frame.size.height+inputHeight) animated:YES];
//        return (height-self.frame.size.height+inputHeight);
    }
    return offsetY;
}

- (void)tableSlideToBackWithHeight:(CGFloat)inputHeight
{
    [self setContentOffset:CGPointMake(0, inputHeight) animated:YES];
}

- (CGFloat)tableCurrentCellHeightAtIndex:(NSIndexPath *)index
{
    CGFloat height = 0;
    NSNumber *section = [NSNumber numberWithInteger:(index.section)];
    
    for (int i = 0; i < (index.section); i ++)
    {
        for (NSString *num in [tableHeightDict1[@(i)] allKeys])
        {
            height += [tableHeightDict1[@(i)][num] floatValue];
        }
    }
    
    NSDictionary *dict = tableHeightDict1[section];
    for (NSString *numStr in dict)
    {
        NSInteger num = [numStr integerValue];
        if (num <= index.row)
        {
            height += [dict[@(num)] floatValue];
        }
    }
    
    return height;
}

@end
