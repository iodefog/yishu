//
//  RegisterOrganizationButtonView.m
//  medtree
//
//  Created by 无忧 on 14-11-7.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "RegisterOrganizationButtonView.h"
#import "ColorUtil.h"

@implementation RegisterOrganizationButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)clickButton:(UIButton *)button
{
    if (button.tag - 100 == selectIdx) {
        return;
    }
    selectIdx = button.tag - 100;
    [self.parent clickButtonIdx:button.tag-100];
    for (int i = 0; i < viewArray.count; i ++) {
        UIButton *button1 = [viewArray objectAtIndex:i];
        if (button1.tag == button.tag) {
            [button1 setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1] forState:UIControlStateNormal];
        } else {
            [button1 setTitleColor:[ColorUtil getColor:@"6f6f6f" alpha:1] forState:UIControlStateNormal];
        }
    }
}

- (void)createUI
{
    selectIdx = 0;
    viewArray = [[NSMutableArray alloc] init];
    NSArray *title = [NSArray arrayWithObjects:@"医院",@"学校",@"其他", nil];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[title objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = 100+i;
        if (i == 0) {
            [button setTitleColor:[ColorUtil getColor:@"365c8a" alpha:1] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[ColorUtil getColor:@"6f6f6f" alpha:1] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [viewArray addObject:button];
    }
    lineLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLab1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLab1];
    
    lineLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLab2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLab2];
    
    lineLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
    lineLab3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:lineLab3];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    lineLab3.frame = CGRectMake(0, size.height-0.5, size.width, 0.5);
    for (int i = 0; i < viewArray.count; i ++) {
        UIButton *button = [viewArray objectAtIndex:i];
        button.frame = CGRectMake(i*(size.width/viewArray.count), 0, (size.width/viewArray.count), size.height);
    }
    lineLab1.frame = CGRectMake((size.width/viewArray.count), 5, 1, size.height-10);
    lineLab2.frame = CGRectMake((size.width/viewArray.count)*2, 5, 1, size.height-10);
}

@end
