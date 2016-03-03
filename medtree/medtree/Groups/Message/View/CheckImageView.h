//
//  CheckImageView.h
//  medtree
//
//  Created by 无忧 on 14-9-15.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckImageViewDelegate <NSObject>

- (void)clickThumbnail;

@end

@interface CheckImageView : UIView <UIScrollViewDelegate>

@property (nonatomic ,assign, setter = canClickIt:) BOOL canClick;
@property (nonatomic ,assign) float duration;//动画时间
@property (nonatomic, assign) id parent;

- (void)setPhotoID:(NSString *)photoID;
- (void)setPhoto:(NSDictionary *)info;

@end
