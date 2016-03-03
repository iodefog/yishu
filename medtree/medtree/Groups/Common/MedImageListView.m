//
//  MedImageListView.m
//  medtree
//
//  Created by tangshimi on 9/22/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedImageListView.h"
#import "MedGlobal.h"
#import "UIImageView+setImageWithURL.h"
#import "BrowseImagesController.h"
#import "RootViewController.h"
#import "AcademicTagLayout.h"
#import "MedPhotoBrowerView.h"
#import "UIView+FindUIViewController.h"
#import "UIColor+Colors.h"

static NSString *const kCollectionViewReuseID = @"MedImageListViewCollectionViewCell";
static NSInteger const kMaxImageNumber = 9;

@interface MedImageListView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MedImageListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        _dataArray = [[NSMutableArray alloc] init];

        [self addSubview:self.collectionView];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha <= 0.01 || !self.userInteractionEnabled || self.hidden) {
        return nil;
    }
    BOOL inside = [self pointInside:point withEvent:event];
    UIView *hitView = nil;
    if (inside) {
        NSEnumerator *enumerator = [self.subviews reverseObjectEnumerator];
        for (UIView *subview in enumerator) {
            hitView = [subview hitTest:point withEvent:event];
            if (hitView) {
                break;
            }
        }
        if (hitView == self.collectionView) {
            hitView = nil;
        }
        return hitView;
    } else {
        return nil;
    }
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout -

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == MedImageListViewTypeOnlyShow) {
        CGSize size;
        
        if (self.dataArray.count == 1) {
            size = CGSizeMake(182, 182);
        } else {
            CGFloat width = (GetViewWidth(self) - 30 -  2 * 6) / 3.0;
            size = CGSizeMake(width, width);
        }
        return size;
    } else if (self.type == MedImageListViewTypeShowAndAdd) {
        CGFloat width = (GetViewWidth(self) - 30 - 2 * 6) / 3.0;
        
        return CGSizeMake(width, width);
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return MIN(self.dataArray.count, kMaxImageNumber) ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedImageListViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewReuseID
                                                                                         forIndexPath:indexPath];
    cell.deleteBlock = ^(NSInteger index) {
        if (self.imageArray.count < kMaxImageNumber) {
            [self.dataArray removeLastObject];
        }
        
        [self.dataArray removeObjectAtIndex:index];

        _imageArray = [self.dataArray copy];
        
        [self.dataArray addObject:@"icon_add_image.png"];
        [self.collectionView reloadData];
    };
    
    if (self.type == MedImageListViewTypeOnlyShow) {
        [cell setImage:self.dataArray[indexPath.row] networkImage:YES hideDeleteButton:YES indexPath:indexPath];
    } else if (self.type == MedImageListViewTypeShowAndAdd) {
        if (indexPath.row == self.imageArray.count && self.imageArray.count < kMaxImageNumber) {
            [cell setImage:self.dataArray[indexPath.row] networkImage:NO hideDeleteButton:YES indexPath:indexPath];
        } else {
            [cell setImage:self.dataArray[indexPath.row] networkImage:YES hideDeleteButton:NO indexPath:indexPath];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == MedImageListViewTypeShowAndAdd) {
        if (indexPath.row == self.dataArray.count - 1) {
            if (self.addImageBlock) {
                self.addImageBlock();
            }
            return;
        }
    }
    
    if (self.clickBlock) {
        self.clickBlock(indexPath.row);
    }
    
    NSMutableArray *bigPicUrlArray = [NSMutableArray new];
    NSMutableArray *originalUrlArray = [NSMutableArray new];
    for (NSString *picID in self.imageArray) {
        [bigPicUrlArray addObject:[NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], picID]];
        [originalUrlArray addObject:[NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], picID]];
    }
    
    NSMutableArray *originalFrameArray = [NSMutableArray new];
    
    if (self.imageArray.count == 1) {
        for (MedImageListViewCollectionViewCell *cell in collectionView.visibleCells) {
            CGRect rect = [cell.superview convertRect:cell.frame toView:[UIApplication sharedApplication].keyWindow];
            
            [originalFrameArray addObject:[NSValue valueWithCGRect:rect]];
        }
    } else {
        CGFloat width = (GetViewWidth(self) - 30 - 2 * 6) / 3.0;
        for (NSInteger i = 0; i < self.imageArray.count; i ++) {
            CGFloat x = (width + 6) * (i % 3);
            CGFloat y = (width + 6) * (i / 3);
            CGRect frame = CGRectMake(x, y, width, width);
            
            CGRect convertFrame = [self convertRect:frame toView:[UIApplication sharedApplication].keyWindow];
            
            [originalFrameArray addObject:[NSValue valueWithCGRect:convertFrame]];
        }
    }
    
    MedPhotoBrowerView *view = [[MedPhotoBrowerView alloc] init];
    view.currentIndex = indexPath.row;
    view.imageURLArray = bigPicUrlArray;
    view.originalImageURLArray = originalUrlArray;
    view.imageFrameArray = originalFrameArray;
    
    [[self firstAvailableUIViewController] presentViewController:view animated:NO completion:nil];
    
    //[view show];
}

#pragma mark -
#pragma mark - height -
/**
 * 默认左右两边有 15px 间隔
 */
+ (CGFloat)heightWithWidth:(CGFloat)width type:(MedImageListViewType)type imageArray:(NSArray *)imageArray
{
    if (type == MedImageListViewTypeOnlyShow) {
        if (imageArray.count == 1) {
            return 182;
        } else {
            CGFloat signalImageHeight = (width - 30 - 2 * 6) / 3.0;
            
            NSInteger lines = 1;
            
            if (imageArray.count == 0) {
                lines = 0;
            } else {
                lines = (imageArray.count - 1) / 3 + 1;
            }
            
            lines = MIN(lines, 3);
            
            return MAX(signalImageHeight * lines +  6 * (lines - 1), 0);
        }
    } else if (type == MedImageListViewTypeShowAndAdd) {
        CGFloat signalImageHeight = (width - 30 - 2 * 6) / 3.0;
        
        NSInteger lines = imageArray.count / 3 + 1;
        
        lines = MIN(lines, 3);
        
        return signalImageHeight * lines + 6 * (lines - 1);
    }
    return 0;
}

#pragma mark -
#pragma mark - setter and getter -

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            AcademicTagLayout *flowLayout = [[AcademicTagLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 6;
            flowLayout.minimumLineSpacing = 6;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            [view registerClass:[MedImageListViewCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewReuseID];
            view.backgroundColor = [UIColor clearColor];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
    }
    return _collectionView;
}

- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = [imageArray copy];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:_imageArray];
    
    if (self.type == MedImageListViewTypeShowAndAdd) {
        if (imageArray.count < kMaxImageNumber) {
            [self.dataArray addObject:@"icon_add_image.png"];
        }
    }
    
    [self.collectionView reloadData];
}

- (void)setType:(MedImageListViewType)type
{
    _type = type;
    if (type == MedImageListViewTypeShowAndAdd) {
        self.collectionView.backgroundColor = [UIColor colorFromHexString:@"#F4F4F7"];
        [self.dataArray addObject:@"icon_add_image.png"];
        [self.collectionView reloadData];
    } else {
        self.collectionView.scrollEnabled = NO;
    }
}

@end

@interface MedImageListViewCollectionViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation MedImageListViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.deleteButton];
                
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsZero);
        }];
        
        [self.deleteButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.right.equalTo(@0);
        }];
    }
    return self;
}

- (void)setImage:(NSString *)image
    networkImage:(BOOL)networkImage
hideDeleteButton:(BOOL)hideDeletButton
       indexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    self.deleteButton.hidden = hideDeletButton;;
    
    if (networkImage) {
        NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], image];
        [self.imageView med_setImageWithUrl:[NSURL URLWithString:imageURL]
                           placeholderImage:GetImage(@"feed_default_image.png")];
    } else {
        self.imageView.image = GetImage(image);
    }
}

#pragma mark -
#pragma mark - response event -

- (void)deleteButtonAction:(UIButton *)button
{
    if (self.deleteBlock) {
        self.deleteBlock(self.indexPath.row);
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView;
        });
    }
    return _imageView;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"btn_academic_delete.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _deleteButton;
}

@end

