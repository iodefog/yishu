//
//  PersonCardInfoAcademicTagCell.m
//  medtree
//
//  Created by 边大朋 on 15/8/12.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "PersonCardInfoAcademicTagCell.h"
#import "AcademicTagCell.h"
#import "AcademicTagLayout.h"
#import "UserDTO.h"
#import "AcademicTagDTO.h"
#import "NSString+Extension.h"
#import "AcademicTagsDTO.h"
#import "AcademicTagDTO.h"

#define TagMargin 15
#define CellH 32

@interface PersonCardInfoAcademicTagCell ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, AcademicTagDelegate>
{
    UICollectionView *collection;
    NSMutableArray *dataArray;
    /** 存放标签背景色，防止点赞操作刷新cell时候，获取重用cell的时候index.item取出来的与初始值不对应 */
    NSMutableArray *colorArray;
}

@end

@implementation PersonCardInfoAcademicTagCell

#pragma  mark - UI
- (void)createUI
{
    [super createUI];
    AcademicTagLayout *layout = [[AcademicTagLayout alloc] init];
    layout.minimumLineSpacing = 10;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor whiteColor];
    [collection registerClass:[AcademicTagCell class] forCellWithReuseIdentifier:@"AcademicTagCell"];
    [self.contentView addSubview:collection];
    collection.scrollEnabled = NO;
    
    collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    colorArray = [[NSMutableArray alloc] init];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - load data
- (void)setInfo:(AcademicTagsDTO *)dto indexPath:(NSIndexPath *)indexPath
{
    idto = dto;
    dataArray = dto.dataArray;
    index = indexPath;
    
    [collection reloadData];
}

#pragma mark - AcademicTagDelegate
- (void)likeTag:(NSString *)tag index:(NSIndexPath *)indexPatch
{
    [self.parent clickCell:tag index:index action:@5];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AcademicTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AcademicTagCell" forIndexPath:indexPath];
    
    if (colorArray.count != dataArray.count) {
        [colorArray addObject:[cell getBgView].backgroundColor];
    }
    [cell setInfo:dataArray[indexPath.row] index:indexPath];
    [cell getBgView].backgroundColor = [colorArray objectAtIndex:indexPath.item];
    cell.parent = self;
    if (indexPath.item == dataArray.count - 1) {
        AcademicTagsDTO *dto = (AcademicTagsDTO *)idto;
        
        if (dto.height <= 0) {
            dto.height = CGRectGetMaxY(cell.frame);
            [self.parent clickCell:dto action:@(200)];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark -  UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        AcademicTagDTO *dto = dataArray[indexPath.row];
        CGSize tagNameSize = [NSString sizeForString:dto.tagName Size:CGSizeMake(CGFLOAT_MAX, CellH)
                                                Font:[UIFont systemFontOfSize:14]];
        CGSize tagCountSize = [NSString sizeForString:dto.tagCount Size:CGSizeMake(CGFLOAT_MAX, CellH)
                                                 Font:[UIFont systemFontOfSize:14]];
        
        CGFloat textW = tagNameSize.width + tagCountSize.width + 12 + CellH;
        
        if (textW > CGRectGetWidth(self.frame) - TagMargin * 2) {
            textW = CGRectGetWidth(self.frame) - TagMargin * 2;
        }
    return CGSizeMake(textW, 32);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, TagMargin, TagMargin, TagMargin);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return TagMargin;
}

#pragma mark - cell height

+ (CGFloat)getCellHeight:(AcademicTagsDTO *)dto width:(CGFloat)width
{
    if (dto.dataArray.count <= 0) {
        return 0;
    }
    
    return dto.height > 0 ? dto.height + 15 : GetScreenHeight;
}

@end
