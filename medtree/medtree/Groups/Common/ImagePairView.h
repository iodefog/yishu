//
//  ImagePairView.h
//  medtree
//
//  Created by 无忧 on 14-10-10.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@class PairDTO;

@protocol ImagePairViewDelegate <NSObject>

- (void)clickImagePairView:(NSNumber *)tag;

@end

@interface ImagePairView : BaseView
{
    UIImageView     *headerLine;
    UIImageView     *footerLine;
    UIImageView     *iconImage;
    UITextField     *titleLab;
    UILabel         *detailLab;
    UIImageView     *nextImage;
    NSNumber        *idxNum;
    BOOL            isTouch;
}

@property (nonatomic, assign) id<ImagePairViewDelegate> parent;

- (void)setInfo:(PairDTO *)dto indexPath:(NSIndexPath *)indexPath;
- (void)setInfo:(NSDictionary *)dict;
- (void)updateTitle:(NSString *)title;

@end
