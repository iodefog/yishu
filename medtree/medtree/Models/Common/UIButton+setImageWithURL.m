//
//  UIButton+setImageWithURL.m
//  123456
//
//  Created by tangshimi on 5/6/15.
//  Copyright (c) 2015 tangshimi. All rights reserved.
//

#import "UIButton+setImageWithURL.h"


@implementation UIButton (setImageWithURL)

- (void)med_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self sd_setBackgroundImageWithURL:url forState:state];
}

- (void)med_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self sd_setBackgroundImageWithURL:url forState:state placeholderImage:placeholder];
}

- (void)med_setImageWithURL:(NSURL *)url forState:(UIControlState)state
{
    [self sd_setImageWithURL:url forState:state ];
}

- (void)med_setImageWithURL:(NSURL *)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder
{
    [self sd_setImageWithURL:url forState:state placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}

@end
