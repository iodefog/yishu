//
//  MedEquivalentWidthView.h
//  medtree
//
//  Created by tangshimi on 10/30/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MedEquivalentWidthView;

@protocol MedEquivalentWidthViewDelegate <NSObject>

- (void)equivalentWidthView:(MedEquivalentWidthView *)view clickAtIndex:(NSInteger)index;

@end

@interface MedEquivalentWidthView : UIView

@property (nonatomic, weak) id<MedEquivalentWidthViewDelegate> delegate;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *imageArray;

- (void)setupView;

//- (void)setCustomView:(UIView *)customView atIndex:(NSInteger)index;

@end

@interface MedEquivalentWidthViewSeperateView : UIView

@end
