//
//  AcademicTabCell.h
//  medtree
//
//  Created by 边大朋 on 15/8/7.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AcademicTagDTO;

@protocol AcademicTagDelegate <NSObject>

@optional
- (void)delTag:(NSString *)tag index:(NSIndexPath *)indexPatch;
- (void)likeTag:(NSString *)tag index:(NSIndexPath *)indexPatch;

@end

@interface AcademicTagCell : UICollectionViewCell

@property (nonatomic, weak) id <AcademicTagDelegate>parent;

- (void)setInfo:(AcademicTagDTO *)dto index:(NSIndexPath *)indexPatch;
- (UIView *)getBgView;

@end
