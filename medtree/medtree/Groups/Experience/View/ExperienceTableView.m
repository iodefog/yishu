//
//  ExperienceTableView.m
//  medtree
//
//  Created by 边大朋 on 15/6/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceTableView.h"
#import "ExperienceCommonCell.h"
#import "ColorUtil.h"
#import "OrganizationNameDTO.h"
#import "DepartmentNameDTO.h"

@implementation ExperienceTableView

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    table = [[LoadingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.parent = self;
    table.enableHeader = NO;
    table.enableFooter = YES;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCell:[ExperienceCommonCell class]];
    table.backgroundColor = [UIColor clearColor];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:table];
    
    dataList = [[NSMutableArray alloc] init];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self.parent getMoreData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    table.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - 数据源
- (void)reloadArray
{
    [dataList removeAllObjects];
    [table setData:[NSArray arrayWithObjects:dataList, nil]];
}

- (void)setInfo:(NSArray *)array
{
    if (array.count >= 20) {
        table.enableFooter = YES;
    } else {
        table.enableFooter = NO;
    }
    
    [dataList addObjectsFromArray:array];
    [self setNeedsLayout];
    [table setData:[NSArray arrayWithObject:dataList]];
}

- (BOOL)isLastCell:(NSIndexPath *)indexPath
{
    BOOL isLast = NO;
    if (indexPath.section < [table numberOfSections] && indexPath.row == [table numberOfRowsInSection:indexPath.section]-1) {
        isLast = YES;
    }
    return isLast;
}

- (BOOL)isEndCell:(NSIndexPath *)indexPath
{
    BOOL isEnd = NO;
    if (indexPath.section == ([table numberOfSections]-1) && indexPath.row == [table numberOfRowsInSection:indexPath.section]-1) {
        isEnd = YES;
    }
    return isEnd;
}

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)setFooter:(BOOL)footer
{
    table.enableFooter = footer;
}

#pragma mark - click
- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([self.parent respondsToSelector:@selector(selectTitle:)]) {
        [self.parent selectTitle:dto];
    }
}

@end
