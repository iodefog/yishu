//
//  ImagePairCell.h
//  medtree
//
//  Created by 无忧 on 14-8-29.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"

@class PairDTO;
@class BadgeView;
@class ImagePairView;

@interface ImagePairCell : BaseCell
{
    ImagePairView   *imageTextView;
    BadgeView       *badgeView;
    BOOL            showLastLine;
}

@end
