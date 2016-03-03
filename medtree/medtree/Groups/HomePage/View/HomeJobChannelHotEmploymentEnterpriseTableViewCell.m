//
//  HomeJobChannelHotEmploymentEnterpriseTableViewCell.m
//  medtree
//
//  Created by tangshimi on 11/2/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobChannelHotEmploymentEnterpriseTableViewCell.h"
#import "HomeJobChannelHotEmploymentDTO.h"
#import "HomeJobChannelHotEnterpriseCollectionViewCell.h"
#import "HomeJobHotEnterpriseFlowLayout.h"
#import "UIImageView+setImageWithURL.h"
#import "MedGlobal.h"
#import "HomeJobChannelHotEmploymentDetailDTO.h"

static NSString * const kCellReuseID = @"CollectionViewCell";

@interface HomeJobChannelHotEmploymentEnterpriseTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeJobChannelHotEmploymentEnterpriseTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)createUI
{
    [super createUI];
    
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.collectionView];
    
    self.collectionView.frame = CGRectMake(0, 0, GetScreenWidth, 180);
    self.collectionView.autoresizesSubviews = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)setInfo:(HomeJobChannelHotEmploymentDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    [self.dataArray removeAllObjects];
    
    if (dto.enterpriseArray.count > 0) {
        [self.dataArray addObjectsFromArray:dto.enterpriseArray];
        [self.dataArray insertObject:dto.enterpriseArray.lastObject atIndex:0];
    }
    
    [self.collectionView reloadData];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    return 180;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource / UICollectionViewDelegate -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeJobChannelHotEnterpriseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseID forIndexPath:indexPath];
    
    cell.detailDTO = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.parent respondsToSelector:@selector(clickCell:index:action:)]) {
        [self.parent clickCell:self.dataArray[indexPath.row] index:nil action:nil];
    }
}

#pragma mark -
#pragma mark - getter and setter -

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            HomeJobHotEnterpriseFlowLayout *flowLayout = [[HomeJobHotEnterpriseFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
            flowLayout.minimumLineSpacing = 10.0f;
            flowLayout.itemSize = CGSizeMake(280, 180);
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor clearColor];
            view.dataSource = self;
            view.delegate = self;
            [view registerClass:[HomeJobChannelHotEnterpriseCollectionViewCell class] forCellWithReuseIdentifier:kCellReuseID];
            view;
        });
    }
    return _collectionView;
}

@end
