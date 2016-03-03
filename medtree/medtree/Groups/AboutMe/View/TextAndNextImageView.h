//
//  TextAndNextImageView.h
//  medtree
//
//  Created by 无忧 on 14-11-5.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol TextAndNextImageViewDelegate <NSObject>

- (void)clickTextAndNextImageView:(NSInteger)tag;

@end

@interface TextAndNextImageView : BaseView
{
    UIImageView             *lineImage;
    UILabel                 *titleLab;
    UIImageView             *nextImage;
    UIImageView             *bgView;
    NSInteger               num;
}

@property (nonatomic, assign) id<TextAndNextImageViewDelegate> parent;

- (void)setTitle:(NSString *)title tag:(NSInteger)tag;

@end
