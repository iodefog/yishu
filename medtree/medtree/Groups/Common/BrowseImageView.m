//
//  BrowseImageView.m
//  medtree
//
//  Created by 陈升军 on 14/12/26.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BrowseImageView.h"
#import "MedGlobal.h"
#import "CircularProgressView.h"
#import "UIImageView+setImageWithURL.h"
#import "InfoAlertView.h"

@interface BrowseImageView () <UIActionSheetDelegate, UIScrollViewDelegate> {

    UIImageView         *imageView;
    CGSize              imageSize;
    CircularProgressView   *circular;
    UIScrollView        *scrollView_;
    NSString            *imageName;
}

@end

@implementation BrowseImageView

- (void)createUI
{
    [super createUI];
    
    self.backgroundColor = [UIColor blackColor];
    
    scrollView_ = [[UIScrollView alloc] init];
    scrollView_.userInteractionEnabled = YES;
    scrollView_.maximumZoomScale = 2.0;
    scrollView_.delegate = self;
    scrollView_.showsVerticalScrollIndicator = NO;
    scrollView_.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView_];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.userInteractionEnabled = YES;
    [scrollView_ addSubview:imageView];
    
    circular = [[CircularProgressView alloc] initWithFrame:CGRectZero];
    circular.backgroundColor = [UIColor clearColor];
    [circular setIsShowLabel:YES];
    [circular setFontFloat:14];
    circular.hidden = YES;
    [imageView addSubview:circular];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(longPressGestureAction:)];
    [imageView addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(tapGestureAction:)];
    [imageView addGestureRecognizer:tapGesture];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    scrollView_.frame = self.bounds;
    
    circular.frame = CGRectMake((imageView.frame.size.width-100)/2, (imageView.frame.size.height-100)/2, 100, 100);
}

- (void)setImageURL:(NSString *)imagePath
{
    circular.progress = 0.01;
    circular.hidden = NO;
    NSString *small = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig],imagePath];
    
    NSString *thumbnailPath = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Big],imagePath];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *thumbnail = [imageCache imageFromMemoryCacheForKey:thumbnailPath];
    
    [imageView med_setImageWithUrl:[NSURL URLWithString:small] placeholderImage:thumbnail options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        circular.progress = (float)receivedSize / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            circular.progress = 1;
            CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
            CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].bounds);
            
            CGFloat imageOriginalWidth = image.size.width;
            CGFloat imageOriginalHeight = image.size.height;

            if (imageOriginalHeight > screenHeight) {
                if (imageOriginalWidth > screenWidth) {
                    CGFloat showHeight = imageOriginalHeight / (imageOriginalWidth / screenWidth);
                    
                    if (showHeight > screenHeight) {
                        imageView.frame = CGRectMake(0, 0, screenWidth, showHeight);
                        scrollView_.contentSize = imageView.frame.size;
                    } else {
                        imageView.frame = [UIScreen mainScreen].bounds;
                        imageView.contentMode = UIViewContentModeScaleAspectFit;
                    }
                } else {
                    imageView.frame = [UIScreen mainScreen].bounds;
                    imageView.contentMode = UIViewContentModeScaleAspectFit;
                }
                
            } else {
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.frame = [UIScreen mainScreen].bounds;
            }
                        
            [self layoutIfNeeded];
        }
        circular.hidden = YES;
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIscrollViewDelegate -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews){
        return view;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [self scrollViewEnd];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0 && scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake((CGRectGetWidth(imageView.frame) - CGRectGetWidth(self.frame)) / 2,
                                               (CGRectGetWidth(imageView.frame) - CGRectGetWidth(self.frame)));
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - response event -
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    if (scrollView_.zoomScale != 1.0) {
        [scrollView_ setZoomScale:1.0 animated:YES];
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
    
    [InfoAlertView showInfo:message inView:self duration:1.0];
}

- (void)scrollViewEnd
{
    if (scrollView_.zoomScale < 1.0) {
        [scrollView_ setZoomScale:1.0 animated:YES];
        scrollView_.contentOffset = CGPointMake(0, 0);
    } else if (scrollView_.zoomScale > 2.0) {
        [scrollView_ setZoomScale:2.0 animated:YES];
    }
}


@end
