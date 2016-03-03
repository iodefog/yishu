//
//  BaseTableView.m
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseTableView.h"
#import "RefreshTableView.h"
#import "BaseCell.h"
#import "ColorUtil.h"
#import "BaseTableView+Foot.h"

@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)createUI
{
    [super createUI];
    self.delegate = self;
    self.dataSource = self;

    isNeedFootView = NO;
    tableHeightDict = [[NSMutableDictionary alloc] init];
    tableHeightDict1 = [NSMutableDictionary dictionary];
    
    dataArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];
    sectionTitleHeightArray = [[NSMutableArray alloc] init];
    sectionHeaderArray = [[NSMutableArray alloc] init];
    sectionIndexTitles = [[NSMutableArray alloc] init];
    
    headerBGColor = @"";
    
    editButtonTitle = @"删除";
}

- (void)dealloc
{

}

/*使section title 随着table滑动而滑动 不再一直显示在cell上*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self)
    {
        if (sectionHeaderArray.count == 0 && sectionTitleHeightArray.count > 0) {
            CGFloat sectionHeaderHeight = 20;
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataArray.count == 0 && isNeedFootView) {
        [self addFootView];
    }
    return dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [dataArray objectAtIndex:section];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    if (section < titleArray.count) {
        title = [titleArray objectAtIndex:section];
    }
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (section < sectionTitleHeightArray.count) {
        height = [[sectionTitleHeightArray objectAtIndex:section] floatValue];
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = nil;
    if (section < sectionHeaderArray.count) {
        header = [sectionHeaderArray objectAtIndex:section];
    } else {
        header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, [[sectionTitleHeightArray objectAtIndex:section] floatValue])];
        if (headerBGColor.length == 0) {
            header.backgroundColor = [UIColor clearColor];
        } else {
            header.backgroundColor = [ColorUtil getColor:headerBGColor alpha:1];
        }
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (Class)getCellClass:(id)dto
{
    if (CellClass != nil) {
        return CellClass;
    } else {
        Class cell = [CellClasses objectForKey:NSStringFromClass([dto class])];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dto = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CGFloat height = [[self getCellClass:dto] getCellHeight:dto width:self.frame.size.width];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setTableCellHeight:height index:indexPath];
////        [self setTableCellHeight1:height index:indexPath];
    });
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id dto = [[dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSString *name = NSStringFromClass([dto class]);
    NSString *CellIdentifier = name;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[[self getCellClass:dto] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([cell respondsToSelector:@selector(setParent:)] == YES) {
            [cell performSelector:@selector(setParent:) withObject:parent];
        }
    }
    [(BaseCell *)cell setInfo:dto indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:)]) {
        [self.parent clickCell:dataArray[indexPath.section][indexPath.row]
                         index:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.parent) {
        if ([self.parent respondsToSelector:@selector(isAllowDelete:)]) {
            return [self.parent isAllowDelete:indexPath];
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return editButtonTitle;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self deleteData:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
//        [tableView reloadData];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if ([self getSectionIndexTitles] != nil) {
        return [self getSectionIndexTitles];
    } else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (void)setTitle:(NSArray *)array
{
    [titleArray removeAllObjects];
    [titleArray addObjectsFromArray:array];
}

- (void)setData:(NSArray *)array
{
    [self clearTableCellHeight];
    [self setTitleHeight:sectionTitleHeightArray];
    [dataArray removeAllObjects];
    [dataArray addObjectsFromArray:array];
    [self reloadData];
}

- (NSMutableArray *)getData
{
    return dataArray;
}

- (void)insertCell:(id)dto indexPath:(NSIndexPath *)indexPath
{
    BOOL isOK = YES;
    NSMutableArray *refreshArray = [NSMutableArray array];
    //
    if (dto != nil) {
        if (indexPath.section < dataArray.count) {
            NSMutableArray *array = [dataArray objectAtIndex:indexPath.section];
            if (indexPath.row < array.count) {
                [array insertObject:dto atIndex:indexPath.row];
                if (indexPath.row == 0) {
                    [refreshArray addObject:indexPath];
                    [refreshArray addObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]];
                }
            } else if (indexPath.row == array.count) {
                [array addObject:dto];
                if (indexPath.row > 0) {
                    [refreshArray addObject:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
                }
                [refreshArray addObject:indexPath];
            } else {
                isOK = NO;
            }
            if (isOK) {
                [self beginUpdates];
                [self insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
                [self endUpdates];
                [self reloadRowsAtIndexPaths:refreshArray withRowAnimation:UITableViewRowAnimationFade];
            }
        } else if (indexPath.section == dataArray.count && indexPath.row == 0) {
            [dataArray addObject:[NSMutableArray arrayWithObjects:dto, nil]];
            [self reloadData];
        } else {
            isOK = NO;
        }
    }
}

- (void)setSectionTitleHeight:(NSArray *)array
{
    [sectionTitleHeightArray removeAllObjects];
    [sectionTitleHeightArray addObjectsFromArray:array];
    [self setTitleHeight:sectionTitleHeightArray];
//    [self reloadData];
}

- (void)setSectionHeader:(NSArray *)array
{
    [sectionHeaderArray removeAllObjects];
    [sectionHeaderArray addObjectsFromArray:array];
}

- (void)deleteData:(NSIndexPath *)indexPath
{
    if (parent != nil && [parent respondsToSelector:@selector(deleteIndex:)] == YES) {
        [parent performSelector:@selector(deleteIndex:) withObject:indexPath];
    } else if (parent != nil && [parent respondsToSelector:@selector(deleteData:)] == YES) {
        NSMutableArray *array = [dataArray objectAtIndex:indexPath.section];
        if (array.count > indexPath.row) {
            [parent performSelector:@selector(deleteData:) withObject:[array objectAtIndex:indexPath.row]];
        }
    }
    if (dataArray.count > indexPath.section) {
        NSMutableArray *array = [dataArray objectAtIndex:indexPath.section];
        if (array.count > indexPath.row) {
            [array removeObjectAtIndex:indexPath.row];
            [self reloadData];
        }
    }
}

- (void)registerCell:(Class)cell
{
    CellClasses = nil;
    CellClass = cell;
}

- (void)registerCells:(NSDictionary *)cells
{
    CellClass = nil;
    CellClasses = [[NSMutableDictionary alloc] initWithDictionary:cells];
}

- (void)setSectionHeaderViewBGColor:(NSString *)color
{
    headerBGColor = color;
}

- (NSArray *)getSectionIndexTitles
{
    return sectionIndexTitles;
}

- (void)setSectionIndexTitles:(NSArray *)titles
{
    [sectionIndexTitles removeAllObjects];
    [sectionIndexTitles addObjectsFromArray:titles];
}

- (void)setViewImages
{
    
}

- (void)setTableHeaderViewHeight:(CGFloat)height
{
    tableHeaderViewHeight = height;
}

- (void)setIsNeedFootView:(BOOL)isNeed
{
    isNeedFootView = isNeed;
}

- (CGFloat)tableSlideWithIndex:(NSIndexPath *)index height:(CGFloat)height
{
    return [self tableSlideWithIndex:index inputHeight:height];
}

- (void)tableSlideBackWithHeight:(CGFloat)inputHeight
{
    return [self tableSlideToBackWithHeight:inputHeight];
}

- (CGFloat)tableCellHeightAtIndex:(NSIndexPath *)index
{
    return [self tableCurrentCellHeightAtIndex:index];
}

- (void)setEditButtonTitle:(NSString *)title
{
    editButtonTitle = title;
}

#pragma mark - 返回当前高度
- (CGFloat)heightAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:self cellForRowAtIndexPath:indexPath].frame.origin.y;
}

@end
