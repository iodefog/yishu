//
//  PersonEditTitleTableView.m
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "PersonEditTitleTableView.h"
#import "PersonEditTitleTableCell.h"
#import "ColorUtil.h"

@implementation PersonEditTitleTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    
    table = [[LoadingTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.parent = self;
    table.enableHeader = NO;
    table.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [table registerCell:[PersonEditTitleTableCell class]];
    table.backgroundColor = [UIColor clearColor];
    [self addSubview:table];
    
    titleArray = [[NSMutableArray alloc] init];
}

- (void)loadHeader:(BaseTableView *)table
{
    
}

- (void)loadFooter:(BaseTableView *)table
{
    [self.parent getMoreData];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    table.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)reloadArray
{
    [titleArray removeAllObjects];
    [table setData:[NSArray arrayWithObjects:titleArray, nil]];
}

- (void)setInfo:(NSArray *)array
{
    if (array.count == 20) {
        table.enableFooter = YES;
    } else {
        table.enableFooter = NO;
    }
    
    if (_isSearch) {
      [titleArray removeAllObjects];
    }
    [titleArray addObjectsFromArray:array];
    [self layoutSubviews];
    [table setData:[NSArray arrayWithObject:titleArray]];
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

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    for (int i = 0; i < titleArray.count; i ++) {
        NSMutableDictionary *dict = [titleArray objectAtIndex:i];
        if (index.row == i) {
            _ediTtitle = [dict objectForKey:@"title"];
            [titleArray replaceObjectAtIndex:i withObject:@{@"title":[dict objectForKey:@"title"],@"isSelect":[NSNumber numberWithBool:YES]}];
        } else {
            [titleArray replaceObjectAtIndex:i withObject:@{@"title":[dict objectForKey:@"title"],@"isSelect":[NSNumber numberWithBool:NO]}];
        }
    }
    [table setData:[NSArray arrayWithObject:titleArray]];
    [self postTitle];
//    [self performSelector:@selector(postTitle) withObject:nil afterDelay:1];
//    [table reloadData];
}

- (void)postTitle
{
    [self.parent selectTitle];
}

@end
