//
//  TitleAndDetailView.h
//  medtree
//
//  Created by 无忧 on 14-9-1.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol TitleAndDetailViewDelegate <NSObject>

- (void)clickiViewIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;

@end

@interface TitleAndDetailView : BaseView
{
    UIView          *bgView;
    UILabel         *titleLab;
    UILabel         *detailLab;
    UIImageView     *nextImage;
    BOOL            isCanSelect;
    NSIndexPath     *index;
    NSInteger       integer;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent;

- (void)setInfo:(NSDictionary *)dict;
- (void)setIsShowNext;
- (void)setIsCanSelect;
- (void)setIndexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;
+ (CGFloat)getHeight:(NSString *)text width:(CGFloat)width;

@end
