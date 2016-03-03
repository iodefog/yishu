//
//  PairCell.h
//  medtree
//
//  Created by sam on 8/18/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseCell.h"

@class PairDTO;
@class BadgeView;

enum {
    PairCell_Type_LEFT_RIGHT    = 1,
    PairCell_Type_RIGHT_LEFT    = 2,
    PairCell_Type_LEFT          = 3,
    PairCell_Type_CENTER        = 4,
    PairCell_Type_TOP_BOTTOM    = 5
} PairCell_Type;

@interface PairCell : BaseCell {
    UILabel         *keyLabel;
    UILabel         *valueLabel;
    UIImageView     *nextImage;
    BadgeView       *badgeView;
}

@end
