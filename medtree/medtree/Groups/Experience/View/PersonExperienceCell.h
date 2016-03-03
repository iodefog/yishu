//
//  PersonExperienceCell.h
//  medtree
//
//  Created by 无忧 on 14-11-8.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseCell.h"
#import "TitleAndDetailView.h"

@class PersonAddView;

@interface PersonExperienceCell : BaseCell
{
    UILabel         *titleLab;
    UILabel         *numLab;
    NSMutableArray  *viewArray;
    PersonAddView   *addView;
    NSMutableArray  *dataArray;
    NSInteger       type;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent2;

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath;
+ (CGFloat)getCellHeight:(NSDictionary *)dict width:(CGFloat)width;

@end
