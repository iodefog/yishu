//
//  PersonExperienceView.h
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"
#import "TitleAndDetailView.h"

@interface PersonExperienceView : BaseView
{
    UILabel         *hosLab;
    UILabel         *depLab;
    UILabel         *detailLab;
    UIImageView     *nextImage;
    UIImageView     *footerLine;
    NSIndexPath     *index;
    NSInteger       tagNum;
    UIImageView     *bgView;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent;

- (void)setInfo:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;
+ (CGFloat)getCellHeight:(NSDictionary *)dict width:(CGFloat)width;
- (void)showNext;
- (void)setIsShowFootLine:(BOOL)isShow;

@end
