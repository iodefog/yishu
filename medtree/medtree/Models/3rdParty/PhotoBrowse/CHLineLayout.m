//
//  CHLineLayout.m
//  medtree
//
//  Created by 孙晨辉 on 15/10/30.
//  Copyright © 2015年 sam. All rights reserved.
//

#import "CHLineLayout.h"

static const CGFloat CHLineLayoutItemWH = 200;

@implementation CHLineLayout

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(CHLineLayoutItemWH, CHLineLayoutItemWH);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumInteritemSpacing = CHLineLayoutItemWH / 4;
    CGFloat inset = (self.collectionView.frame.size.width - CHLineLayoutItemWH) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    CGRect visibleRect = CGRectZero;
    visibleRect.size = self.collectionView.frame.size;
    visibleRect.origin = self.collectionView.contentOffset;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in array)
    {
        if (!CGRectIntersectsRect(visibleRect, attrs.frame)) continue;
        // 每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        // 跟屏幕最中间的距离计算缩放比例
        if (ABS(itemCenterX - centerX) <= 150) {
            CGFloat scale = 1 + (1 - (ABS(itemCenterX - centerX) / 150)) * 0.7;
            // 差距越小，缩放比例越大
            attrs.transform3D = CATransform3DMakeScale(scale, scale, 1);
        } else {
            attrs.transform3D = CATransform3DIdentity;
        }
    }
    
    return array;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 计算出scollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    // 计算屏幕中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 取出这个范围内的所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
