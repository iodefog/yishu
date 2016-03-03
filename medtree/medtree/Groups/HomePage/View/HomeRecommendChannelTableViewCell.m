//
//  SlideByCollectionViewTableViewCell.m
//  medtree
//
//  Created by tangshimi on 8/18/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeRecommendChannelTableViewCell.h"
#import "SlideTableViewCellCollectionViewCell.h"
#import "HomeRecommendChannelDTO.h"
#import "UIColor+Colors.h"
#import "HomeRecommendChannelDetailDTO.h"

static NSString * const kSlideTableViewCellCollectionViewCellReuseID = @"SlideTableViewCellCollectionViewCell";

@interface HomeRecommendChannelTableViewCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HomeRecommendChannelTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}

- (void)createUI
{
    [super createUI];
    
    [self.contentView addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    footerLine.hidden = YES;
    
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)setInfo:(HomeRecommendChannelDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    index = indexPath;
    
    [self.dataArray removeAllObjects];
    
    if (dto.channelArray.count > 0) {
        [self.dataArray addObjectsFromArray:dto.channelArray];
        
        if (dto.channelArray.count < 6) {
            for (NSInteger i = 0; i < 6 - dto.channelArray.count; i ++) {
                HomeRecommendChannelDetailDTO *dto = [[HomeRecommendChannelDetailDTO alloc] init];
                
                [self.dataArray addObject:dto];
            }
        }
    }
        
    [self.collectionView reloadData];
}

+ (CGFloat)getCellHeight:(id)dto width:(CGFloat)width
{
    CGFloat swidth = (GetScreenWidth - 2) / 3;
    CGFloat height = swidth * (200 / 245.0);
    
    return height * 2 + 1;
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
    SlideTableViewCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSlideTableViewCellCollectionViewCellReuseID forIndexPath:indexPath];
    
    cell.channelDetailDTO = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeRecommendChannelDetailDTO *dto = self.dataArray[indexPath.row];
    
    if (!dto.channelName && !dto.channelID) {
        return;
    }
    
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
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
            flowLayout.minimumLineSpacing = 1.0f;
            flowLayout.minimumInteritemSpacing = 1.0f;
            CGFloat width = (GetScreenWidth - 2) / 3;
            CGFloat height = width * (200 / 245.0);
            flowLayout.itemSize = CGSizeMake(width, height);
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            view.scrollEnabled = NO;
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
            view.dataSource = self;
            view.delegate = self;
            [view registerClass:[SlideTableViewCellCollectionViewCell class] forCellWithReuseIdentifier:kSlideTableViewCellCollectionViewCellReuseID];
            view;
        });
    }
    return _collectionView;
}

@end
