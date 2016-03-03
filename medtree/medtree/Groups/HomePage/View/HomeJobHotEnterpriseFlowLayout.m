//
//  HomeJobHotEnterpriseFlowLayout.m
//  medtree
//
//  Created by tangshimi on 11/28/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeJobHotEnterpriseFlowLayout.h"

#define ACTIVE_DISTANCE 200
#define DecoTemplateSectionTopInset 80
#define DecoTemplateItemCellMinumPadding 8

@implementation HomeJobHotEnterpriseFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (proposedContentOffset.x < GetScreenWidth / 2) {
        return CGPointZero;
    }
    
    if (proposedContentOffset.x > self.collectionViewContentSize.width - GetScreenWidth * 1.5 + self.sectionInset.right) {
        return CGPointMake(self.collectionViewContentSize.width - GetScreenWidth, 0);
    }
    
    CGFloat proposedContentOffsetCenterX = proposedContentOffset.x + self.collectionView.bounds.size.width * 0.5f;
    
    UICollectionViewLayoutAttributes* candidateAttributes;
    for (UICollectionViewLayoutAttributes* attributes in [self layoutAttributesForElementsInRect:self.collectionView.bounds]) {
        if (attributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        
        // 判断是否第一次
        if(!candidateAttributes) {
            candidateAttributes = attributes;
            continue;
        }
        
        if (fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
            candidateAttributes = attributes;
        }
    }
    
    return CGPointMake(candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f, proposedContentOffset.y);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / (GetScreenWidth / 2 + 1);
            if (ABS(distance) > (GetScreenWidth / 2 + 1)) {
                CGFloat zoom = 1 + 0.4 * (1 - ABS(normalizedDistance));
                if (zoom > 1.55) {
                    zoom = 1.55;
                }
                attributes.transform3D = CATransform3DMakeScale(1, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

@end
