//
//  EmptyCell.m
//  medtree
//
//  Created by 陈升军 on 15/4/22.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "EmptyCell.h"
#import "EmptyDTO.h"

@implementation EmptyCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    self.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)getCellHeight:(EmptyDTO *)dto width:(CGFloat)width
{
    return dto.height;
}

@end
