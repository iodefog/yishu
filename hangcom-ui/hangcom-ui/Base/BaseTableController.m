//
//  BaseTableController.m
//  hangcom-ui
//
//  Created by sam on 8/1/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseTableController.h"
#import "BaseCell.h"

@interface BaseTableController ()

@end

@implementation BaseTableController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGSize size = self.view.frame.size;
    CGRect rect = naviBar.frame;
    table.frame = CGRectMake(0, rect.origin.y+rect.size.height, size.width, size.height-rect.origin.y-rect.size.height);
}

- (void)createUI
{
    [super createUI];
    [self createTable];
}

- (void)createTable
{
    table = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.parent = self;
    table.enableHeader = YES;
    table.backgroundColor = [UIColor clearColor];
    [self.view addSubview:table];
}

#pragma mark RefreshTableView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [table performSelector:@selector(scrollViewDidScroll:) withObject:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [table performSelector:@selector(scrollViewDidEndDragging:willDecelerate:) withObject:scrollView withObject:nil];
}

- (void)showProgress
{

}

- (void)hideProgress
{

}

- (void)loadHeader:(BaseTableView *)table
{
    
}

- (void)loadFooter:(BaseTableView *)table
{
    
}

- (void)clickCell:(id)dto action:(NSNumber *)action
{
    
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    
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

@end
