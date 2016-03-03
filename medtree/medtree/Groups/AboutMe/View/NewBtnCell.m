//
//  NewBtnCell.m
//  medtree
//
//  Created by 边大朋 on 15-4-6.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewBtnCell.h"
#import "NewBtnView.h"
#import "Pair2DTO.h"
#import "ColorUtil.h"
@interface NewBtnCell ()<NewBtnViewDelegate>
{
    NewBtnView *btnView;
    Pair2DTO *pdto;
}
@end

@implementation NewBtnCell

- (void)createUI
{
    self.backgroundColor = [ColorUtil getColor:@"F5F6F8" alpha:1];
    btnView = [[NewBtnView alloc] initWithFrame:CGRectZero];
    btnView.parent = self;
    [self addSubview:btnView];
}

- (void)setInfo:(id)dto indexPath:(NSIndexPath *)indexPath
{
    pdto = (Pair2DTO *)dto;
    [btnView setInfo:pdto.title];
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    btnView.frame = CGRectMake(20, size.height-55, size.width-40 , 55);
    if ([pdto.label isEqualToString:@"empty"]) {
      //  btnView.frame = CGRectMake(20, 180, size.width-40 , 55);
    }
    
}

- (void)btnClickPush
{
    [self.parent clickCell:nil action:nil];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    Pair2DTO *pdto = (Pair2DTO *)dto;
    if ([pdto.label isEqualToString:@"empty"]) {
      //  return 300;
    }
    return 95;
}

#pragma mark - 屏蔽选中状态
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
@end
