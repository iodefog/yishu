//
//  TSMPhotoCollectionViewCell.m
//  TSMPhotoBrowerView
//
//  Created by tangshimi on 10/3/15.
//  Copyright © 2015 tangshimi. All rights reserved.
//

#import "MedPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "MedPhotoProgressView.h"

@interface MedPhotoCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) UIButton *reDownloadButton;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) MedPhotoProgressView *progressView;
@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *originalImageURL;

@end

@implementation MedPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.reDownloadButton];
        
        self.scrollView.frame = self.bounds;
        self.imageView.frame = self.bounds;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.progressView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.reDownloadButton
                                                                     attribute:NSLayoutAttributeCenterX
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterX
                                                                    multiplier:1.0
                                                                      constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.reDownloadButton
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.contentView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.0
                                                                      constant:0]];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [self.scrollView addGestureRecognizer:tapGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChangeAction:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!self.imageView.image) {
        return;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat showHeight = self.imageView.image.size.height / (self.imageView.image.size.width / screenWidth);
    
    if (showHeight > screenHeight) {
        self.imageView.frame = CGRectMake(0, 0, screenWidth, showHeight);
        self.scrollView.contentSize = CGSizeMake(screenWidth, showHeight);
    } else {
        self.imageView.frame = CGRectMake(0, (screenHeight - showHeight) / 2.0 , screenWidth, showHeight);
        self.scrollView.contentSize = [UIScreen mainScreen].bounds.size;
    }
}

- (void)setImage:(NSString *)originalImageURL imageURL:(NSString *)imageURL indexPath:(NSIndexPath *)indexPath;
{
    self.indexPath = indexPath;
    self.imageURL = imageURL;
    self.originalImageURL = originalImageURL;
    [self.scrollView setZoomScale:1.0];
    self.progressView.hidden = NO;
    self.reDownloadButton.hidden = YES;

    [self downloadImage];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture
{
    if (self.tapBlock) {
        self.tapBlock(self.indexPath.row);
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate -

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews){
        return view;
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x <= 0 && scrollView.contentOffset.y <= 0) {
        scrollView.contentOffset = CGPointMake((CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.frame)) / 2,
                                               (CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.frame)));
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if (scrollView.zoomScale < 1.0) {
        [scrollView setZoomScale:1.0 animated:YES];
        scrollView.contentOffset = CGPointMake(0, 0);
    } else if (scrollView.zoomScale > 2.0) {
        [scrollView setZoomScale:2.0 animated:YES];
    }
}

#pragma mark -
#pragma mark - response event -

- (void)statusBarOrientationChangeAction:(NSNotification *)notification
{
    [self setNeedsDisplay];
}

- (void)reDownloadButtonAction:(UIButton *)button
{
    button.hidden = YES;
    
    [self downloadImage];
}

#pragma mark -
#pragma mark - private -

- (void)downloadImage
{
    self.progressView.progress = 0.001;
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *originalImage = [manager.imageCache imageFromMemoryCacheForKey:[manager cacheKeyForURL:[NSURL URLWithString:self.originalImageURL]]];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]
                      placeholderImage:originalImage ? : GetImage(@"feed_default_image.png")
                               options:SDWebImageRetryFailed | SDWebImageHighPriority
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  self.progressView.progress = (float)receivedSize / expectedSize;
                              } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  if (image) {
                                      self.progressView.progress = 1.0;
                                      self.imageView.image = image;
                                      [self setNeedsLayout];
                                  } else {
                                      self.reDownloadButton.hidden = originalImage ? YES : NO;
                                  }
                                  
                                  self.progressView.hidden = YES;
                              }];

}

#pragma mark -
#pragma mark - setter and getter -

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.maximumZoomScale = 2.0;
            scrollView.minimumZoomScale = 0.5;
            scrollView.delegate = self;
            scrollView.delaysContentTouches = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _imageView;
}

- (MedPhotoProgressView *)progressView
{
    if (!_progressView) {
        _progressView =  ({
            MedPhotoProgressView *progressView = [[MedPhotoProgressView alloc] init];
            progressView.translatesAutoresizingMaskIntoConstraints = NO;
            progressView;
        });
    }
    return _progressView;
}

- (UIButton *)reDownloadButton
{
    if (!_reDownloadButton) {
        _reDownloadButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"重新下载" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(reDownloadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _reDownloadButton;
}

@end
