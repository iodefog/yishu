//
//  NewSettingCell.h
//  medtree
//
//  Created by 边大朋 on 15-4-20.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseCell.h"
@class BadgeView;

@interface NewSettingCell : BaseCell
{
    UILabel         *keyLabel;
    UILabel         *valueLabel;
    UIImageView     *nextImage;
    BadgeView       *badgeView;
}

@end

