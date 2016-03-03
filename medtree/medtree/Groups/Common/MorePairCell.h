//
//  MorePairCell.h
//  medtree
//
//  Created by 无忧 on 14-9-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"
#import "TitleAndDetailView.h"

@interface MorePairCell : BaseCell
{
    NSMutableArray      *pairArray;
    NSMutableArray      *lineArray;
    BOOL                isAllShowNext;
    UIView              *commonView;
    NSMutableArray      *dataArray;
    UIImageView         *lineImage;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent2;

- (void)allShowNext:(BOOL)sender;

@end
