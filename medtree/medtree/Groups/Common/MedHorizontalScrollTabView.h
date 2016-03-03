//
//  MedHorizontalScrollTabView.h
//  medtree
//
//  Created by tangshimi on 12/4/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MedHorizontalScrollTabViewDelegate <NSObject>

- (void)horizontalScrollTabViewItemDidClick:(NSInteger)selectedIndex;

@end

@interface MedHorizontalScrollTabView : UIView

@property (nonatomic, copy) NSArray *itemsArray;
@property (nonatomic, weak) id<MedHorizontalScrollTabViewDelegate> delegate;

@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) CGFloat edgeSpace;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIImage *backgroundImage;

@end
