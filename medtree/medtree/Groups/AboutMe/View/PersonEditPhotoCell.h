//
//  PersonEditPhotoCell.h
//  medtree
//
//  Created by 无忧 on 14-9-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"

@interface PersonEditPhotoCell : BaseCell
{
    UIImageView         *photoImage;
    UILabel             *titleLab;
    UIImageView         *nextImage;
    NSString            *imagePath;
}

@end
