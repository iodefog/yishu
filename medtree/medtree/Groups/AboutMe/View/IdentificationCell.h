//
//  IdentificationCell.h
//  medtree
//
//  Created by 无忧 on 14-10-31.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"
#import "TextAndNextImageView.h"

@class PairDTO;

@interface IdentificationCell : BaseCell <TextAndNextImageViewDelegate>
{
    UIImageView     *imageView;                         // 图片
    UILabel         *titleLabel;                        // 标题
    UILabel         *timeLabel;                         // 时间
    UIImageView     *nextImage;
    PairDTO         *pairDTO;
    NSMutableArray  *viewArray;
}

@end
