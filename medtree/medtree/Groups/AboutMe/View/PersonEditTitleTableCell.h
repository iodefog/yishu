//
//  PersonEditTitleTableCell.h
//  medtree
//
//  Created by 无忧 on 14-9-17.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"

@interface PersonEditTitleTableCell : BaseCell
{
    UILabel     *titleLab;
    UIImageView *selectImage;
    UILabel     *userCount;
    UIImageView *nextImage;
    
    NSInteger   count;
    BOOL        isShowCount;
    NSMutableDictionary *typeDict;

}

@end
