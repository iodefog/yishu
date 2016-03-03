//
//  SearchBarEx.h
//  medtree
//
//  Created by 无忧 on 14-9-23.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import "BaseView.h"

@protocol SearchBarExDelegate <NSObject>

- (void)searchBecomeFirstResponder;
- (void)searchBarSearchButtonClicked:(NSString *)text;

@optional
- (void)searchBarCancelButtonClicked;

@optional
- (void)searchViewClickAdd;

@end

@interface SearchBarEx : BaseView <UISearchBarDelegate>
{
    UIButton            *cancelButton;
    UIImageView         *imageView;
    UISearchBar         *searchView;
    BOOL                isCanAdd;
    BOOL                isAdd;
}

@property (nonatomic, assign) id<SearchBarExDelegate> parent;

- (void)setButtonTitleBlackColor;
- (void)searchViewResignFirstResponder;
- (void)searchViewBecomeFirstResponder;
- (void)setSearchPlaceholder:(NSString *)text;
- (void)setIsAdd;

@end
