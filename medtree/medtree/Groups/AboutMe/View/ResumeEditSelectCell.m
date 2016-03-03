//
//  ResumeEditSelectCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/11/10.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "ResumeEditSelectCell.h"
#import "PairDTO.h"

@interface ResumeEditSelectCell ()
{
    UIImageView     *selectedView;
}

@end

@implementation ResumeEditSelectCell

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    selectedView = [[UIImageView alloc] init];
    [self addSubview:selectedView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    selectedView.frame = CGRectMake(self.frame.size.width - 15 - 44, (self.frame.size.height - 44) * 0.5, 44, 44);
}

#pragma mark - 数据源
- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    selectedView.image = dto.isSelect ? [UIImage imageNamed:@"home_selected"] : [UIImage imageNamed:@"home_unselected"];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.text = dto.value;
}

#pragma mark - click cell
- (void)clickCell
{
    [self.parent clickCell:idto index:index];
}

#pragma mark - cell height
+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 50;
}

@end
