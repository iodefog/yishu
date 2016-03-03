//
//  PersonCertificationView.h
//  medtree
//
//  Created by 无忧 on 14-11-24.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"
#import "TitleAndDetailView.h"

@class CertificationDTO;

@interface PersonCertificationView : BaseView
{
    UIImageView     *bgView;
    UILabel         *titleLab;
    UILabel         *detailLab;
    UIImageView     *nextImage;
    UIImageView     *footerLine;
    NSIndexPath     *index;
    NSInteger       tagNum;
}

@property (nonatomic, assign) id<TitleAndDetailViewDelegate> parent;

- (void)setInfo:(CertificationDTO *)dto indexPath:(NSIndexPath *)indexPath tag:(NSInteger)tag;
+ (CGFloat)getCellHeight:(CertificationDTO *)dto width:(CGFloat)width;
- (void)showNext;
- (void)setIsShowFootLine:(BOOL)isShow;

@end
