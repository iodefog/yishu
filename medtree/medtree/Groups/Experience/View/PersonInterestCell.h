//
//  PersonInterestCell.h
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"

@interface PersonInterestCell : BaseCell
{
    UILabel         *interestLab;
    UILabel         *titleLab;
    UIImageView     *nextImage;
}

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;
- (void)showNext;

@end
