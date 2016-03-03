//
//  CHPhotoViewCell.h
//  medtree
//
//  Created by 孙晨辉 on 15/10/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHPhoto;
@interface CHPhotoViewCell : UICollectionViewCell

@property (nonatomic, strong) CHPhoto       *photoDTO;
@property (nonatomic, assign) NSInteger     total;
@property (nonatomic, copy) void (^clickTapBlock)(void);
@property (nonatomic, copy) void (^clickLongPressBlock)(UIImage *image);

@end
