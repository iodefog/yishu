//
//  CHPhotoViewCell.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "CHPhotoViewCell.h"
#import "CHPhoto.h"
#import "UIImageView+setImageWithURL.h"
#import "CHPhotoLoadingView.h"

@interface CHPhotoViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CHPhotoLoadingView *photoLoadingView;

@end

@implementation CHPhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.scrollView.frame = self.bounds;
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    self.titleLabel.frame = CGRectMake((size.width - 80) * 0.5, 60, 80, 20);
}

- (void)setPhotoDTO:(CHPhoto *)photoDTO
{
    _photoDTO = photoDTO;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@/%@", @(photoDTO.index + 1), @(self.total)];

    if (photoDTO.url.length > 0) {
        [self.photoLoadingView showLoading];
        [self addSubview:self.photoLoadingView];
        __unsafe_unretained typeof(self) weakSelf = self;
        __unsafe_unretained CHPhotoLoadingView *loading = self.photoLoadingView;
        [self.imageView med_setImageWithUrl:[NSURL URLWithString:photoDTO.url]
                           placeholderImage:[UIImage imageNamed:@"chat_img_placeholder.png"]
                                    options:SDWebImageRetryFailed
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                       if (receivedSize > 0.01) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               loading.progress = (CGFloat)receivedSize / expectedSize;
                                           });
                                       }
                                   }
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (error) {
                                          [self.photoLoadingView showFailure];
                                          CGFloat w = CGRectGetWidth(self.frame);
                                          CGFloat h = CGRectGetHeight(self.frame);
                                          _scrollView.contentSize = CGSizeMake(w, h);
                                      } else {
                                          [self.photoLoadingView removeFromSuperview];
                                          [weakSelf resizeScrollViewContentSizeWithSize:image.size];
                                      }
                                  }];
    } else {
        if ([[self subviews] containsObject:self.photoLoadingView]) {
            [self.photoLoadingView removeFromSuperview];
        }
        if (photoDTO.filePath > 0) {
            NSError *error;
            NSData *data = [NSData dataWithContentsOfFile:photoDTO.filePath options:NSDataReadingMappedAlways error:&error];
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                [self resizeScrollViewContentSizeWithSize:image.size];
                _imageView.image = image;
            }
        } else {
            _imageView.image = [UIImage imageNamed:@"chat_img_placeholder.png"];
        }
    }
    photoDTO.isShow = YES;
    
    _scrollView.contentOffset = photoDTO.offSize;
}

- (void)resizeScrollViewContentSizeWithSize:(CGSize)size
{
    CGFloat imageW = CGRectGetWidth(self.frame);
    CGFloat imageH = size.height * imageW / size.width;
    CGFloat imageY = 0;
    CGFloat h = CGRectGetHeight(self.frame);
    if (imageH == 0) {
        imageH = h;
    }
    CGFloat contentH = imageH;
    if (imageH < h) {
        imageY = (h - imageH) * 0.5;
        contentH = CGRectGetHeight(self.frame);
    }
    _imageView.frame = CGRectMake(0, imageY, imageW, imageH);
    _scrollView.contentSize = CGSizeMake(imageW, contentH);
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    CGSize viewSize = view.frame.size;
    CGSize size = self.frame.size;
    CGFloat x = (size.width - viewSize.width) * 0.5 < 0 ? 0 : (size.width - viewSize.width) * 0.5;
    CGFloat y = (size.height - viewSize.height) * 0.5 < 0 ? 0 : (size.height - viewSize.height) * 0.5;
    view.frame = CGRectMake(x, y, viewSize.width, viewSize.height);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.zoomScale == 1.0) {
        self.photoDTO.offSize = scrollView.contentOffset;
    }
}

#pragma mark - click
- (void)clickTap
{
    if (self.clickTapBlock) {
        self.clickTapBlock();
    }
}

- (void)clickLongpress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.clickLongPressBlock) {
            self.clickLongPressBlock(_imageView.image);
        }
    }
}

#pragma mark - setter & getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.maximumZoomScale = 2;
        _scrollView.minimumZoomScale = 1;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
        [_scrollView addGestureRecognizer:tap];
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(clickLongpress:)];
        [_imageView addGestureRecognizer:longPress];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _titleLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.layer.masksToBounds = YES;
        _titleLabel.layer.cornerRadius = 10;
    }
    return _titleLabel;
}

- (CHPhotoLoadingView *)photoLoadingView
{
    if (!_photoLoadingView) {
        _photoLoadingView = [[CHPhotoLoadingView alloc] init];
        _photoLoadingView.userInteractionEnabled = NO;
    }
    return _photoLoadingView;
}

@end
