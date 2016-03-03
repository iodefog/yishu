//
//  DropdownChoseListView.h
//  medtree
//
//  Created by tangshimi on 8/20/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownChoseListView;

@protocol DropdownChoseListViewDelegate <NSObject>

- (CGSize)contentViewSizeOfDropdownChoseListView:(DropdownChoseListView *)listView;

- (CGFloat)dropdownChoseListView:(DropdownChoseListView *)listView heightForRowAtIndex:(NSIndexPath *)indexPath;

- (NSString *)dropdownChoseListView:(DropdownChoseListView *)listView titleForRowAtIndex:(NSIndexPath *)indexPath;

- (NSInteger)numberOfItemsForDropdownChoseListView:(DropdownChoseListView *)listView;

- (void)dropdownChoseListView:(DropdownChoseListView *)listView didSelectedAtIndex:(NSIndexPath *)indexPath;

@end

@interface DropdownChoseListView : UIView

@property (nonatomic, weak) id<DropdownChoseListViewDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

- (void)showInView:(UIView *)inView frame:(CGRect)frame animated:(BOOL)animated;

@end
