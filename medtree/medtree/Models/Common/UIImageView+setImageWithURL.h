//
//  UIImageView+setImageWithUrl.h
//  123456
//
//  Created by tangshimi on 5/6/15.
//  Copyright (c) 2015 tangshimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface UIImageView (setImageWithURL)

- (void)med_setImageWithUrl:(NSURL *)url;

- (void)med_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image;

- (void)med_setImageWithUrl:(NSURL *)url
           placeholderImage:(UIImage *)image
                    options:(SDWebImageOptions)option
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock;

@end
