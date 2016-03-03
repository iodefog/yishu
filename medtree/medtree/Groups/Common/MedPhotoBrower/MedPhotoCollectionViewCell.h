//
//  TSMPhotoCollectionViewCell.h
//  TSMPhotoBrowerView
//
//  Created by tangshimi on 10/3/15.
//  Copyright © 2015 tangshimi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MedPhotoCollectionViewCellTapBlock)(NSInteger);

@interface MedPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, copy) MedPhotoCollectionViewCellTapBlock tapBlock;

- (void)setImage:(NSString *)originalImageURL imageURL:(NSString *)imageURL indexPath:(NSIndexPath *)indexPath;

@end
