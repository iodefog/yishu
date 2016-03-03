//
//  BaseCell.m
//  zhihu
//
//  Created by sam on 7/30/14.
//  Copyright (c) 2014 lyuan. All rights reserved.
//

#import "BaseCell.h"
#import "ImageCenter.h"

@implementation BaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

#define SINGLE_LINE_WIDTH (1 / [UIScreen mainScreen].scale)

#define SINGLE_LINE_ADJUST_OFFSET ((1 / [UIScreen mainScreen].scale) / 2)

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.selectedBackgroundView = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0  blue:220 / 255.0  alpha:1];
        view;
    });

    headerLine = [[UIImageView alloc] initWithFrame:CGRectZero];
    headerLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
    [self.contentView addSubview:headerLine];
    
    footerLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - SINGLE_LINE_WIDTH - SINGLE_LINE_ADJUST_OFFSET, CGRectGetWidth(self.frame), SINGLE_LINE_WIDTH)];
    footerLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_page_cell_line.png"]];
    [self.contentView addSubview:footerLine];
}

- (void)resize:(CGSize)size
{
    [self checkLine];
    headerLine.hidden = !isFirstCell;
    headerLine.frame = CGRectMake(0, 0, size.width, 1);
    footerLine.frame = CGRectMake(isLastCell ? 0 : 70, size.height - 1, size.width, 1);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    footerLine.frame = CGRectMake(0, CGRectGetHeight(self.frame) - SINGLE_LINE_WIDTH, CGRectGetWidth(self.frame), SINGLE_LINE_WIDTH);
}

- (void)showBgView:(BOOL)tf
{
    if (isDisable == NO) {
        bgView.alpha = tf ? 0.5 : 0;
        footerLine.hidden = tf;
    }
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{

}

- (void)checkLine
{
    isFirstCell = index.row == 0 ? YES : NO;
    isLastCell = [self.parent isLastCell:index];
    if ([self.parent respondsToSelector:@selector(isEndCell:)]) {
        isEndCell = [self.parent isEndCell:index];
    }
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 44;
}

+ (void)setCellWidth:(CGFloat)width
{
    
}

- (void)clickCell
{
    
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    if(![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"] isEqualToString:@"医树"]) {
//        [self clickCell];
//    }
//}

- (void)setFirstCell:(BOOL)firstCell
{
    _firstCell = firstCell;
}

- (void)setLastCell:(BOOL)lastCell
{
    _lastCell = lastCell;
}

@end
