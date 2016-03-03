//
//  BaseTableView.m
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseGridView.h"
#import "RefreshTableView.h"
#import "BaseGridCell.h"
#import "ColorUtil.h"

@implementation BaseGridView

- (void)createUI
{
    [super createUI];
    
    columnCount = 1;
}

- (void)setGridColumn:(NSInteger)count
{
    columnCount = count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [dataArray objectAtIndex:section];
    NSInteger count = (array.count+columnCount-1)/columnCount;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = (indexPath.row+columnCount-1)/columnCount;
    id dto = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:idx];
    return [[self getCellClass:dto] getCellHeight:dto width:self.frame.size.width];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dto = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *name = NSStringFromClass([dto class]);
    NSString *CellIdentifier = name;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[[self getCellClass:dto] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //
        if ([cell respondsToSelector:@selector(setParent:)] == YES) {
            [cell performSelector:@selector(setParent:) withObject:parent];
        }
        if ([cell respondsToSelector:@selector(setColumnCount:)] == YES) {
            [cell performSelector:@selector(setColumnCount:) withObject:[NSNumber numberWithInteger:columnCount]];
        }
    }
    [(BaseGridCell *)cell setInfo:dataArray indexPath:indexPath];
    return cell;
}

@end
