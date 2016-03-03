//
//  HomePosterView.m
//  medtree
//
//  Created by tangshimi on 8/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomePosterView.h"
#import "UIImageView+setImageWithURL.h"
#import "RecommendDTO.h"
#import "MedGlobal.h"

static NSString *const collectionViewCellReuesID = @"collectionViewCellReuesID";
static NSInteger kTimeInterval = 4;

@interface HomePosterView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
                              UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectiveView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) NSMutableArray<RecommendDTO *> *showPostArray;

@end

@implementation HomePosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showPostArray = [[NSMutableArray alloc] init];
        
        [self addSubview:self.collectiveView];
        [self addSubview:self.closeButton];
        [self addSubview:self.pageControl];
        
        [self.collectiveView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [self.pageControl makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.bottom).offset(8);
        }];
        
        [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@5);
            make.right.equalTo(@-5);
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource -

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showPostArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePosterViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellReuesID
                                                                                       forIndexPath:indexPath];
    NSString *imageURL = [NSString stringWithFormat:@"%@/%@", [MedGlobal getPicHost:ImageType_Orig], self.showPostArray[indexPath.row].image_id];
    [cell setImageULR:imageURL];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.clickBlock) {
        return;
    }
    
    RecommendDTO *dto = self.showPostArray[indexPath.row];
    self.clickBlock(dto.url, dto.title);
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showNext];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self changePageControlCurrentIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changePageControlCurrentIndex];
    
    if (scrollView.contentOffset.x > CGRectGetWidth(self.frame) * (self.posterArray.count + 1)) {
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    }
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame) * self.posterArray.count, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self showNext];
}

#pragma mark -
#pragma mark - response event -

- (void)closeButtonAction:(UIButton *)button
{
    if (!self.closeBlock) {
        return;
    }
    self.closeBlock();
}


#pragma mark -
#pragma mark - helper -

- (void)showNext
{
    if (self.showPostArray.count <= 1) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self performSelector:@selector(show) withObject:nil afterDelay:kTimeInterval inModes:@[ NSRunLoopCommonModes ]];
}

- (void)show
{
    NSInteger currentIndex = [[self.collectiveView indexPathsForVisibleItems] firstObject].row;
    NSInteger nextIndex;
    
    BOOL isAnimated = YES;
    if (currentIndex ==  self.showPostArray.count - 1) {
        isAnimated = NO;
    }
    
    nextIndex = currentIndex + 1;
    
    if (currentIndex == self.showPostArray.count - 1) {
        nextIndex = 1;
    }
    
    [self.collectiveView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:isAnimated];
    
    [self showNext];
}

- (void)changePageControlCurrentIndex
{
    NSInteger currentPage = self.collectiveView.contentOffset.x / CGRectGetWidth(self.frame);
    
    if (currentPage == 0) {
        self.pageControl.currentPage = self.posterArray.count;
    } else if (currentPage == self.posterArray.count + 1) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"home_poster_close.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _closeButton;
}

- (UICollectionView *)collectiveView
{
    if (!_collectiveView) {
        _collectiveView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 0.0;
            flowLayout.minimumLineSpacing = 0.0;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor whiteColor];
            view.pagingEnabled = YES;
            [view registerClass:[HomePosterViewCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellReuesID];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
    }
    return _collectiveView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.pageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            pageControl;
        });
    }
    return _pageControl;
}

- (void)setPosterArray:(NSArray *)posterArray
{
    _posterArray = [posterArray copy];
    
    if (posterArray.count == 0) {
        return;
    }
    
    [self.showPostArray removeAllObjects];
    
    [self.showPostArray addObjectsFromArray:posterArray];
    if (_posterArray.count > 1) {
        [self.showPostArray insertObject:posterArray.lastObject atIndex:0];
        [self.showPostArray addObject:posterArray.firstObject];
    }
    
    [self.collectiveView reloadData];
    
    if (_posterArray.count > 1) {
        self.pageControl.numberOfPages = _posterArray.count;
        self.collectiveView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
        [self showNext];
    }
}

@end

/**
 HomePosterViewCollectionViewCell
 */

@interface HomePosterViewCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HomePosterViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        
        [self.imageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter -

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

- (void)setImageULR:(NSString *)imageULR
{
    _imageULR = [imageULR copy];
    
    [self.imageView med_setImageWithUrl:[NSURL URLWithString:imageULR] placeholderImage:nil];
}

@end
