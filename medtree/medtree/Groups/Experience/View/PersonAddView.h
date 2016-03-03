//
//  PersonAddView.h
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"
#import "TitleAndDetailView.h"

@interface PersonAddView : BaseView
{
    UIImageView     *addImage;
    UILabel         *titleLab;
    UIImageView     *nextImage;
    NSIndexPath     *index;
    NSInteger       tagNum;
    UIImageView     *bgView;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent;

- (void)setInfo:(NSString *)text indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;

@end
