//
//  PersonDetailControllerFoot.h
//  medtree
//
//  Created by 无忧 on 14-9-2.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"


@interface FooterBar : BaseView
{
    UILabel         *headerLine;
    UILabel         *footerLine;
    UIImageView     *bgImage;
    NSMutableArray  *buttonArray;
    NSMutableArray  *lineArray;
}

- (void)setButtonInfo:(NSArray *)array;
- (void)setBackgroundImage:(NSString *)imageName;
- (void)changeButtonImage:(NSString *)imageName index:(NSInteger)index;

@end
