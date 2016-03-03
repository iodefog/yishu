//
//  SettingHeaderView.m
//  medtree
//
//  Created by 无忧 on 14-10-13.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "SettingHeaderView.h"
#import "ImageCenter.h"
#import "MedGlobal.h"

@implementation SettingHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)createUI
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    iconImage = [[UIImageView alloc] initWithImage:[ImageCenter getBundleImage:@"setting_header_icon.png"]];
    [self addSubview:iconImage];
    
    textLab = [[UILabel alloc] initWithFrame:CGRectZero];
    textLab.backgroundColor = [UIColor clearColor];
    textLab.text = [NSString stringWithFormat:@"Verson:%@",version];
    textLab.textAlignment = NSTextAlignmentCenter;
    textLab.font = [MedGlobal getTinyLittleFont];
    [self addSubview:textLab];
    
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    iconImage.frame = CGRectMake((size.width-80)/2, 20, 80, 80);
    textLab.frame = CGRectMake(0, iconImage.frame.origin.y+80 , size.width, 20);
}

@end
