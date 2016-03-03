//
//  CollectionJobsView.m
//  medtree
//
//  Created by Jiangmm on 15/12/15.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "CollectionJobsView.h"

@interface CollectionJobsView ()


@end

@implementation CollectionJobsView

//重写删除，避免提前删除Cell
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.parent respondsToSelector:@selector(deleteIndex:)]) {
            [self.parent deleteIndex:indexPath];
        }
    }
}

@end
