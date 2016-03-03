//
//  NewBtnView.m
//  medtree
//
//  Created by 边大朋 on 15-4-1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "NewBtnView.h"
#import "ColorUtil.h"

@interface NewBtnView ()
{
    UIButton *button;
    int      actionType;
}
@end
@implementation NewBtnView

- (void)createUI
{
    [super createUI];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [ColorUtil getColor:@"365c8a" alpha:1];
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds = YES;
    [button setTitleColor:[ColorUtil getColor:@"ffffff" alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    button.frame = CGRectMake(40, 0, size.width - 80, size.height);
}

- (void)setInfo:(NSString *)str
{
    [button setTitle:str forState:UIControlStateNormal];
    NSRange range = [str rangeOfString:@"添加"];
    if(range.location == NSNotFound) {
        actionType = 1;
    } else {
        actionType = 0;
    }
}

- (void)clickBtn
{
    if (actionType == 0) {
        [self.parent btnClickPush];
    } else {
        [self.parent btnClickSave];
    }
    
}
@end
