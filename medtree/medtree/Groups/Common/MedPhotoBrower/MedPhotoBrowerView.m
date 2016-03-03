//
//  TSMPhotoBrowerView.m
//  TSMPhotoBrowerView
//
//  Created by tangshimi on 10/3/15.
//  Copyright © 2015 tangshimi. All rights reserved.
//

#import "MedPhotoBrowerView.h"
#import "MedPhotoCollectionViewCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "InfoAlertView.h"

#define GetScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define GetScreenHeight     [[UIScreen mainScreen] bounds].size.height

static NSString *const kCollectionViewCellReuseID = @"MedPhotoCollectionViewCell";
static CGFloat const kAnimationDuration = 0.3;

@interface MedPhotoBrowerView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *indexLable;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIImageView *rotationTemporaryImageView;

@end

@implementation MedPhotoBrowerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.rotationTemporaryImageView];
    [self.view addSubview:self.indexLable];
    [self.view addSubview:self.saveButton];
    self.rotationTemporaryImageView.hidden = YES;
    
    NSDictionary *views = @{ @"collectionView" : self.collectionView,
                             @"indexLabel" : self.indexLable,
                             @"saveButton" : self.saveButton };
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.indexLable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[indexLabel]"
                                                                      options:NSLayoutFormatAlignAllTop
                                                                      metrics:nil views:views]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[saveButton(40)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[saveButton]-20-|" options:0 metrics:nil views:views]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChangeAction:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    self.indexLable.text = [NSString stringWithFormat:@"%@/%@", @(self.currentIndex + 1), @(self.imageURLArray.count)];
    
    self.collectionView.hidden = YES;
    self.indexLable.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
 
    [self showPhoto];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
    self.collectionView.hidden = YES;
    
    MedPhotoCollectionViewCell *cell = [[self.collectionView visibleCells] firstObject];
    
    CGRect frame = [cell convertRect:cell.imageView.frame toView:self.view];
    self.rotationTemporaryImageView.frame = frame;
    self.rotationTemporaryImageView.image = cell.imageView.image;
    self.rotationTemporaryImageView.hidden = NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.collectionView.contentOffset = CGPointMake(GetScreenWidth * self.currentIndex, 0);
    self.collectionView.hidden = NO;

    self.rotationTemporaryImageView.hidden = YES;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellReuseID forIndexPath:indexPath];
    __weak __typeof(self) weakSelf = self;
    cell.tapBlock = ^(NSInteger index) {
        [weakSelf hidePhoto];
    };
    
    [cell setImage:self.originalImageURLArray[indexPath.row] imageURL:self.imageURLArray[indexPath.row] indexPath:indexPath];

    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.indexLable.text = [NSString stringWithFormat:@"%@/%@", @(index + 1), @(self.imageURLArray.count)];
    
    self.currentIndex = index;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(GetScreenWidth, GetScreenHeight);
}

#pragma mark -
#pragma mark - response event -

- (void)statusBarOrientationChangeAction:(NSNotification *)notification
{
    [self.collectionView reloadData];
}

- (void)saveButtonAction:(UIButton *)button
{
    MedPhotoCollectionViewCell *cell = [[self.collectionView visibleCells] firstObject];

    UIImageWriteToSavedPhotosAlbum(cell.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

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
    
    [InfoAlertView showInfo:message inView:self.view duration:1.0];
}

#pragma mark -
#pragma mark - public -

- (void)show
{
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self
                                                                                 animated:NO
                                                                               completion:nil];
}

#pragma mark -
#pragma mark - private -

- (void)showPhoto
{
    NSAssert(self.imageURLArray.count == self.originalImageURLArray.count &&
             self.imageURLArray.count == self.imageFrameArray.count,
             @"imageURLArray.count and originalImageURLArray.count and self.imageFrameArray.count must be the same");
    
    UIImageView *temporaryImageView = [UIImageView new];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *originalKey = [manager cacheKeyForURL:[NSURL URLWithString:self.originalImageURLArray[self.currentIndex]]];
    NSString *key = [manager cacheKeyForURL:[NSURL URLWithString:self.imageURLArray[self.currentIndex]]];
    
    if ([manager cachedImageExistsForURL:[NSURL URLWithString:self.imageURLArray[self.currentIndex]]]) {
        temporaryImageView.image = [manager.imageCache imageFromDiskCacheForKey:key];
    } else {
        temporaryImageView.image = [manager.imageCache imageFromMemoryCacheForKey:originalKey];
    }
    temporaryImageView.image = temporaryImageView.image ? : GetImage(@"feed_default_image.png");
    
    [self.view addSubview:temporaryImageView];
    temporaryImageView.frame = [self.imageFrameArray[self.currentIndex] CGRectValue];
    
    CGRect temporaryImageViewFrame;

    if (temporaryImageView.image) {
        CGFloat showHeight = temporaryImageView.image.size.height / (temporaryImageView.image.size.width / GetScreenWidth);
        
        temporaryImageViewFrame = CGRectMake(0, 0, GetScreenWidth, showHeight);
        
        if (showHeight < GetScreenHeight) {
            temporaryImageViewFrame = CGRectMake(0, (GetScreenHeight - showHeight) / 2.0 , GetScreenWidth, showHeight);
        }
    }
    [UIView animateWithDuration:kAnimationDuration animations:^{
        temporaryImageView.frame = temporaryImageViewFrame;
    } completion:^(BOOL finished) {
        [temporaryImageView removeFromSuperview];
        self.collectionView.contentOffset = CGPointMake(GetScreenWidth * self.currentIndex, 0);
        self.collectionView.hidden = NO;
        self.indexLable.hidden = self.imageURLArray.count == 1 ? : NO;
    }];
}

- (void)hidePhoto
{
    MedPhotoCollectionViewCell *cell = [[self.collectionView visibleCells] firstObject];
    
    UIImageView *temporaryImageView = [UIImageView new];
    temporaryImageView.contentMode = UIViewContentModeScaleAspectFill;
    temporaryImageView.clipsToBounds = YES;
    temporaryImageView.frame = [cell.imageView.superview convertRect:cell.imageView.frame toView:self.view];
    [self.view addSubview:temporaryImageView];
    
    self.collectionView.hidden = YES;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString *originalKey = [manager cacheKeyForURL:[NSURL URLWithString:self.originalImageURLArray[self.currentIndex]]];
    temporaryImageView.image = [manager.imageCache imageFromDiskCacheForKey:originalKey] ? : GetImage(@"feed_default_image.png");

    [UIView animateWithDuration:kAnimationDuration animations:^{
        temporaryImageView.frame = [self.imageFrameArray[self.currentIndex] CGRectValue];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView =  ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.minimumInteritemSpacing = 0.0f;
            flowLayout.minimumLineSpacing = 0.0f;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                  collectionViewLayout:flowLayout];
            collectionView.translatesAutoresizingMaskIntoConstraints = NO;
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = [UIColor clearColor];
            collectionView.pagingEnabled = YES;
            [collectionView registerClass:[MedPhotoCollectionViewCell class]
               forCellWithReuseIdentifier:kCollectionViewCellReuseID];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView;
        });
    }
    return _collectionView;
}

- (UILabel *)indexLable
{
    if (!_indexLable) {
        _indexLable = ({
            UILabel *label = [[UILabel alloc] init];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:18];
            label;
        });
    }
    return _indexLable;
}

- (UIButton *)saveButton
{
    if (!_saveButton) {
        _saveButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.translatesAutoresizingMaskIntoConstraints = NO;
            [button setTitle:@"保存" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.layer.cornerRadius = 3.0;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            [button addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _saveButton;
}

- (UIImageView *)rotationTemporaryImageView
{
    if (!_rotationTemporaryImageView) {
        _rotationTemporaryImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _rotationTemporaryImageView;
}

@end
