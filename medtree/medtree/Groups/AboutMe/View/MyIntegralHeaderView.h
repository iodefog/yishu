//
//  MyIntegralHeaderView.h
//  medtree
//
//  Created by 陈升军 on 15/4/9.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseView.h"

@class SignDTO;

@interface MyIntegralHeaderView : BaseView
{
    UILabel         *titleLab;
    UILabel         *integralLab;
    UIImageView     *coverImage;
}

- (void)setInfo:(NSInteger)info;

@end
