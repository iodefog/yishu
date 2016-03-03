//
//  CheckImageView.m
//  medtree
//
//  Created by 无忧 on 14-9-15.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "CheckImageView.h"
#import "ImageCenter.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"
#import "InfoAlertView.h"
#import "FileUtil.h"

@interface CheckImageView () <UIActionSheetDelegate>
{
    UIImage         *placeHoldImage;
    UIScrollView    *scrollView;
    UIImageView     *bigImageView;
    UIImageView     *origImageView;
    NSTimeInterval  time;
    NSString        *imageID;
    
    BOOL            isChanged;
    CGRect          defaultRect;
    UIWindow        *window;
    
    NSDictionary    *imageInfo;
}

@end

@implementation CheckImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.multipleTouchEnabled = YES;
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 2.0;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor blackColor];
    
    origImageView = [[UIImageView alloc] init];
    origImageView.userInteractionEnabled = YES;
    origImageView.alpha = 0;
    origImageView.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:origImageView];
    
    bigImageView = [[UIImageView alloc] init];
    bigImageView.userInteractionEnabled = YES;
    bigImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bigImageView];
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    bigImageView.frame = CGRectMake(0, 0, size.width, size.height);
}

- (void)setPhotoID:(NSString *)photoID
{
    imageID = photoID;
    [self downLoadImage:NO];
}

- (void)downLoadImage:(BOOL)isOrig
{
    NSString *small = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:isOrig?ImageType_Orig:ImageType_Small],imageID];
    
    if (isOrig) {
        [origImageView med_setImageWithUrl:[NSURL URLWithString:small]];
        [self setOrigImageViewFrame];
    } else {
        [bigImageView med_setImageWithUrl:[NSURL URLWithString:small]];
    }
}

- (void)setPhoto:(NSDictionary *)info
{
    imageInfo = info;
    [self downLoadImage2:NO];
}

// 聊天下载图片
- (void)downLoadImage2:(BOOL)isOrig
{
    NSDictionary *info = [imageInfo objectForKey:@"image"];
    BOOL isLocal = [[imageInfo objectForKey:@"local"] boolValue];
    if (isLocal) { // 本地图片
        NSInteger status = [imageInfo[@"status"] integerValue];
        if (status == 6) { // 未上传成功的
            NSString *filePath = info[@"path"];
            NSError *error;
            NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedAlways error:&error];
            UIImage *image = [UIImage imageWithData:data];
            if (isOrig) {
                if (image) {
                    CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
                    CGFloat imageH = image.size.height * imageW / image.size.width;
                    CGFloat imageY = 0;
                    CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                    if (imageH == 0) {
                        imageH = h;
                    }
                    CGFloat contentH = imageH;
                    if (imageH < h) {
                        imageY = (h - imageH) * 0.5;
                        contentH = CGRectGetHeight([UIScreen mainScreen].bounds);
                    }
                    
                    scrollView.contentSize = CGSizeMake(imageW, contentH);
                    origImageView.frame = CGRectMake(0, imageY, imageW, imageH);
                    
                } else {
                    CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
                    CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                    scrollView.contentSize = CGSizeMake(w, h);
                    origImageView.frame = CGRectMake(0, 0, w, h);
                }
            } else {
                bigImageView.image = image;
            }
        } else {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", [imageInfo objectForKey:@"dir"], [info objectForKey:@"path"]];
            NSRange range = [info[@"path"] rangeOfString:@"/"];
            if (range.length > 0) {
                filePath = info[@"path"];
            }
            
            UIImage *image = [ImageCenter getImageFromPath:filePath source:PhotoSource_Path];
            if (image) {
                if (isOrig) {
                    if (image) {
                        CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
                        CGFloat imageH = image.size.height * imageW / image.size.width;
                        CGFloat imageY = 0;
                        CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                        if (imageH == 0) {
                            imageH = h;
                        }
                        CGFloat contentH = imageH;
                        if (imageH < h) {
                            imageY = (h - imageH) * 0.5;
                            contentH = CGRectGetHeight([UIScreen mainScreen].bounds);
                        }
                        
                        scrollView.contentSize = CGSizeMake(imageW, contentH);
                        origImageView.frame = CGRectMake(0, imageY, imageW, imageH);
                        
                    } else {
                        CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
                        CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                        scrollView.contentSize = CGSizeMake(w, h);
                        origImageView.frame = CGRectMake(0, 0, w, h);
                    }
                } else {
                    bigImageView.image = image;
                }
            } else {
                NSString *imageName = info[@"path"];
                if (isOrig) {
                    [origImageView med_setImageWithUrl:[NSURL URLWithString:[[MedGlobal getPicHost:ImageType_Orig] stringByAppendingPathComponent:imageName]]
                                      placeholderImage:placeHoldImage
                                               options:SDWebImageRetryFailed
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                 if (error) {
                                                     CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
                                                     CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                                                     scrollView.contentSize = CGSizeMake(w, h);
                                                     origImageView.frame = CGRectMake(0, 0, w, h);
                                                 } else {
                                                     CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
                                                     CGFloat imageH = image.size.height * imageW / image.size.width;
                                                     CGFloat imageY = 0;
                                                     CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                                                     if (imageH == 0) {
                                                         imageH = h;
                                                     }
                                                     CGFloat contentH = imageH;
                                                     if (imageH < h) {
                                                         imageY = (h - imageH) * 0.5;
                                                         contentH = CGRectGetHeight([UIScreen mainScreen].bounds);
                                                     }
                                                     
                                                     scrollView.contentSize = CGSizeMake(imageW, contentH);
                                                     origImageView.frame = CGRectMake(0, imageY, imageW, imageH);
                                                 }
                                             }];
                } else {
                    [bigImageView med_setImageWithUrl:[NSURL URLWithString:[[MedGlobal getPicHost:ImageType_Small] stringByAppendingPathComponent:imageName]]
                                     placeholderImage:[ImageCenter getBundleImage:@"chat_img_placeholder.png"]];
                }
            }
        }
    } else {
        NSString *imageName = info[@"path"];
        if (isOrig) {
            [origImageView med_setImageWithUrl:[NSURL URLWithString:[[MedGlobal getPicHost:ImageType_Orig] stringByAppendingPathComponent:imageName]]
                              placeholderImage:placeHoldImage
                                       options:SDWebImageRetryFailed
                                      progress:nil
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (error) {
                                             CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
                                             CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                                             scrollView.contentSize = CGSizeMake(w, h);
                                             origImageView.frame = CGRectMake(0, 0, w, h);
                                         } else {
                                             CGFloat imageW = CGRectGetWidth([UIScreen mainScreen].bounds);
                                             CGFloat imageH = image.size.height * imageW / image.size.width;
                                             CGFloat imageY = 0;
                                             CGFloat h = CGRectGetHeight([UIScreen mainScreen].bounds);
                                             if (imageH == 0) {
                                                 imageH = h;
                                             }
                                             CGFloat contentH = imageH;
                                             if (imageH < h) {
                                                 imageY = (h - imageH) * 0.5;
                                                 contentH = CGRectGetHeight([UIScreen mainScreen].bounds);
                                             }
                                             
                                             scrollView.contentSize = CGSizeMake(imageW, contentH);
                                             origImageView.frame = CGRectMake(0, imageY, imageW, imageH);
                                         }
                                     }];
        } else {
            [bigImageView med_setImageWithUrl:[NSURL URLWithString:[[MedGlobal getPicHost:ImageType_200_150] stringByAppendingPathComponent:imageName]]
                             placeholderImage:[ImageCenter getBundleImage:@"chat_img_placeholder.png"]];
        }
    }
}

- (void)canClickIt:(BOOL)click
{
    if (click==YES) {
        UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapIt:)];
        [touch setNumberOfTapsRequired:1];
        self.userInteractionEnabled = YES;
        _duration = 0.5;
        [self addGestureRecognizer:touch];
    }
}

- (void)tapIt:(UIGestureRecognizer*)sender
{
    if (self.parent != nil && [self.parent respondsToSelector:@selector(clickThumbnail)]) {
        [self.parent performSelector:@selector(clickThumbnail) withObject:self];
    }
    [self showImage:bigImageView];
}

- (void)showImage:(UIImageView *)defaultImageView
{
    UIImage *image = defaultImageView.image;
    window = [UIApplication sharedApplication].keyWindow;
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

    defaultRect = [defaultImageView convertRect:defaultImageView.bounds toView:window];// self.parent];//关键代码，坐标系转换
    origImageView.frame = defaultRect;
    origImageView.image = image;
    origImageView.tag = 1;
    placeHoldImage = image;

    [window addSubview:scrollView];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap:)];
    [scrollView addGestureRecognizer:tap];
    origImageView.alpha = 1;
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(longPressGestureAction:)];
    [origImageView addGestureRecognizer:longPressGesture];

    [UIView animateWithDuration:_duration animations:^{
        [self setOrigImageViewFrame];
        if (imageInfo == nil) {
            [self downLoadImage:YES];
        } else {
            [self downLoadImage2:YES];
        }
        scrollView.backgroundColor=[UIColor blackColor];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setOrigImageViewFrame
{
    UIImage *image = origImageView.image;
    CGFloat origImageViewY = ([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2;
    CGFloat origImageViewW = [UIScreen mainScreen].bounds.size.width;
    CGFloat origImageViewH = image.size.height * origImageViewW / image.size.width;
    origImageView.frame=CGRectMake(0, origImageViewY, origImageViewW, origImageViewH);
}

- (void)hideImage
{
    [UIView animateWithDuration:_duration animations:^{
        origImageView.image = bigImageView.image;
        [self setOrigImageViewFrame];
        scrollView.zoomScale = 1.0f;
        origImageView.frame = defaultRect;
        scrollView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.alpha = 1;
        origImageView.alpha = 0;
        [scrollView removeFromSuperview];
    }];
}

- (void)imageTap:(UITapGestureRecognizer *)tap
{
    NSTimeInterval begin = [[NSDate date] timeIntervalSince1970];
    if (time == 0) {
        [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
    } else {
        if (begin - time < 0.3) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideImage) object:nil];
            if (isChanged) {
                scrollView.zoomScale = 1.0f;
                isChanged = NO;
            } else {
                scrollView.zoomScale = 2.0f;
                isChanged = YES;
            }
        } else {
            [self performSelector:@selector(hideImage) withObject:nil afterDelay:0.3];
        }
    }
    time = begin;
}

//实现图片的缩放
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return origImageView;
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView
{
    CGFloat offsetX = (aScrollView.bounds.size.width > aScrollView.contentSize.width)?(aScrollView.bounds.size.width - aScrollView.contentSize.width)/2 : 0.0;
    CGFloat offsetY = (aScrollView.bounds.size.height > aScrollView.contentSize.height)?(aScrollView.bounds.size.height - aScrollView.contentSize.height)/2 : 0.0;
    origImageView.center = CGPointMake(aScrollView.contentSize.width/2 + offsetX, aScrollView.contentSize.height/2 + offsetY);
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"保存图片", nil];
        [actionSheet showInView:self];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - helper -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)imageSavedToPhotosAlbum:(UIImage *)image
       didFinishSavingWithError:(NSError *)error
                    contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"图片已保存";
        
    } else {
        message = [error description];
    }
    
    [InfoAlertView showInfo:message inView:[[UIApplication sharedApplication].delegate window] duration:1.0];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(origImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

@end
