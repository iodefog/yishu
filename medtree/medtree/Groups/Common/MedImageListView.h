//
//  MedImageListView.h
//  medtree
//
//  Created by tangshimi on 9/22/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MedImageListViewCollectionViewCellDeleteBlock)(NSInteger);
typedef void(^MedImageListViewClickBlock)(NSInteger);

typedef NS_ENUM(NSInteger, MedImageListViewType) {
    MedImageListViewTypeOnlyShow,
    MedImageListViewTypeShowAndAdd
};

@interface MedImageListView : UIView

@property (nonatomic, assign) MedImageListViewType type;
@property (nonatomic, copy) MedImageListViewClickBlock clickBlock;
@property (nonatomic, copy) dispatch_block_t addImageBlock;
@property (nonatomic, copy) NSArray *imageArray;

+ (CGFloat)heightWithWidth:(CGFloat)width type:(MedImageListViewType)type imageArray:(NSArray *)imageArray;

@end


@interface MedImageListViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, copy) MedImageListViewCollectionViewCellDeleteBlock deleteBlock;

- (void)setImage:(NSString *)image
    networkImage:(BOOL)networkImage
hideDeleteButton:(BOOL)hideDeletButton
       indexPath:(NSIndexPath *)indexPath;

@end
