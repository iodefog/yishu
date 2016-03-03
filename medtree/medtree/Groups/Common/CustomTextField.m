//
//  CustomTextField.m
//  medtree
//
//  Created by 边大朋 on 15/7/2.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "CustomTextField.h"
#import "ColorUtil.h"
#import "MedGlobal.h"

@interface CustomTextField ()
{
    UILabel         *dividLine1;
    UILabel         *dividLine2;
}

@end

@implementation CustomTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.font = [MedGlobal getMiddleFont];
        
        dividLine1 = [[UILabel alloc] init];
        dividLine1.backgroundColor = [ColorUtil getColor:@"E6E6E5" alpha:1];
        [self addSubview:dividLine1];
        
        dividLine2 = [[UILabel alloc] init];
        dividLine2.backgroundColor = [ColorUtil getColor:@"E6E6E5" alpha:1];
        [self addSubview:dividLine2];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    dividLine1.frame = CGRectMake(0, 0, size.width, 0.5);
    dividLine2.frame = CGRectMake(0, size.height - 0.5, size.width, 0.5);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
}

//控制显示文本的位置
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
}


//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + 15, bounds.origin.y, bounds.size.width - 30, bounds.size.height);
}
@end
