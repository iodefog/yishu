//
//  FriendListCell.m
//  medtree
//
//  Created by 无忧 on 14-12-6.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "FriendListCell.h"

@implementation FriendListCell

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
    
    self.backgroundColor = [UIColor whiteColor];
    descLabel.hidden = YES;
}

@end
