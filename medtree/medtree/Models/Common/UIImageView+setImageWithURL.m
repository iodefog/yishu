//
//  UIImageView+setImageWithUrl.m
//  123456
//
//  Created by tangshimi on 5/6/15.
//  Copyright (c) 2015 tangshimi. All rights reserved.
//

#import "UIImageView+setImageWithURL.h"

@implementation UIImageView (setImageWithURL)

- (void)med_setImageWithUrl:(NSURL *)url
{
    [self sd_setImageWithURL:url];
}

- (void)med_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)image
{
    [self sd_setImageWithURL:url placeholderImage:image];
}

- (void)med_setImageWithUrl:(NSURL *)url
           placeholderImage:(UIImage *)image
                    options:(SDWebImageOptions)option
                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                  completed:(SDWebImageCompletionBlock)completedBlock
{
    [self sd_setImageWithURL:url
            placeholderImage:image
                     options:option
                    progress:progressBlock
                   completed:completedBlock];
}


@end
