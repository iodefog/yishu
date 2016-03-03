//
//  PersonCell.h
//  medtree
//
//  Created by sam on 8/9/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseCell.h"
#import "RichBaseCell.h"

@interface PersonCell : RichBaseCell
{
    UIImageView         *vImage;
    UILabel             *depAndTitleLab;
}

@property (nonatomic, assign) BOOL isShowIndexs;

@end
