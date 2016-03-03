//
//  BaseGridCell.m
//  hangcom-ui
//
//  Created by sam on 11/21/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseGridCell.h"

@implementation BaseGridCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    [super createUI];
    
    viewArray = [[NSMutableArray alloc] init];
}

- (void)setColumnCount:(NSNumber *)count
{
    columnCount = [count integerValue];
    for (int i=0; i<columnCount; i++) {
        UIView *view = [[ViewClass alloc] initWithFrame:CGRectZero];
        if ([view respondsToSelector:@selector(setParent:)] == YES) {
            [view performSelector:@selector(setParent:) withObject:self.parent];
        }
        [viewArray addObject:view];
    }
}

- (void)setInfo:(NSArray *)array indexPath:(NSIndexPath *)indexPath
{
    sourceArray = array;
    NSArray *rows = [array objectAtIndex:indexPath.section];
    NSInteger line = indexPath.row;
    for (NSInteger i=(line*columnCount); i<(line+1)*columnCount; i++) {
        NSInteger idx = i-(line*columnCount);
        if (i<rows.count) {
            UIView *view = [viewArray objectAtIndex:idx];
            if ([view respondsToSelector:@selector(setInfo:)]) {
                [view performSelector:@selector(setInfo:) withObject:[rows objectAtIndex:i]];
            }
            if ([self.contentView.subviews containsObject:view] == NO) {
                [self.contentView addSubview:view];
            }
        } else {
            UIView *view = [viewArray objectAtIndex:idx];
            if ([self.contentView.subviews containsObject:view] == YES) {
                [view removeFromSuperview];
            }
        }
    }
}

- (void)registerView:(Class)view
{
    ViewClass = view;
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    [self resize:size];
}

- (void)resize:(CGSize)size
{
    CGFloat width = size.width/columnCount;
    for (int i=0; i<columnCount; i++) {
        UIView *view = [viewArray objectAtIndex:i];
        view.frame = CGRectMake(width*i, 0, width, size.height);
    }
}

@end
