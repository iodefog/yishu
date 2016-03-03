//
//  HomePageCommonCell.h
//  medtree
//
//  Created by 陈升军 on 15/3/26.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "BaseCell.h"

@class BadgeView;

@interface HomePageCommonCell : BaseCell
{
    UIImageView         *headerImage;
    UILabel             *titleLab;
    UIImageView         *userImage;
    UILabel             *detailLab;
    UILabel             *bgDetailLab;
    BadgeView           *badgeView;
    UIImageView         *nextImage;
    UILabel             *decLab;
}

- (id)getDTO;

@end
