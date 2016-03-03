//
//  PopUpListView.h
//  medtree
//
//  Created by tangshimi on 5/12/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopupListView;

typedef NS_ENUM(NSInteger, PopupListViewArrowType) {
    PopupListViewArrowTypeRight,
    PopupListViewArrowTypeMiddle,
    PopupListViewArrowTypeLeft
};

@protocol PopupListViewDelegate <NSObject>

@required

- (CGSize)contentSizeOfPopupListView:(PopupListView *)listView;

- (NSInteger)numberOfItemsOfPopupListView:(PopupListView *)listView;

- (CGFloat)popupListView:(PopupListView *)listView cellHeightAtIndex:(NSInteger)index;

- (void)popupListView:(PopupListView *)listView didSelectedAtIndex:(NSInteger)index;

- (Class)cellClassOfPopuoListView:(PopupListView *)listView;

- (NSDictionary *)popuplistView:(PopupListView *)listView infoDictionaryAtIndex:(NSInteger)index;

@end

@interface PopupListView : UIView

@property (nonatomic, weak) id<PopupListViewDelegate> delegate;

- (instancetype)initWithArrowType:(PopupListViewArrowType)type;

- (void)showAtPoint:(CGPoint)point inView:(UIView *)inView;

@end
