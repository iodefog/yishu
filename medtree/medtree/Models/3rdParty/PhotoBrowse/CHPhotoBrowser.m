//
//  CHPhotoBrowser.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "CHPhotoBrowser.h"
#import "CHPhotoViewCell.h"
#import "CHLineLayout.h"
#import <InfoAlertView.h>

NSString *const kCHPhotoViewCell = @"CHPHOTOVIEWCELL";

@interface CHPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate>
{
    UIImage *_image;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation CHPhotoBrowser

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - life cycle
- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
}

- (void)setupView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CHPhotoViewCell class] forCellWithReuseIdentifier:kCHPhotoViewCell];
    [self.view addSubview:self.collectionView];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCHPhotoViewCell forIndexPath:indexPath];
    cell.total = self.photos.count;
    cell.photoDTO = self.photos[indexPath.row];
    cell.clickTapBlock = ^() {
        [UIView animateWithDuration:0.25 animations:^{
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }];
    };
    cell.clickLongPressBlock = ^(UIImage *image) {
        _image = image;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"保存图片", nil];
        [actionSheet showInView:self.view];
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(GetScreenWidth, GetScreenHeight);
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = nil;
    if (!error) {
        message = @"图片已保存";
        
    } else {
        message = [error description];
    }
    
    [InfoAlertView showInfo:message inView:self.view duration:1.0];
}

#pragma mark - public
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPhotoIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)dealloc
{
    NSLog(@"clean ---------------------------------------------");
}

@end
