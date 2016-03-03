//
//  SearchTableViewController.m
//  medtree
//
//  Created by tangshimi on 5/14/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "SearchBarTableViewController.h"

@interface SearchBarTableViewController () <UISearchBarDelegate>

@end

@implementation SearchBarTableViewController

@synthesize searchBar = searchBar_;

- (void)createUI
{
    [super createUI];
    [self.view addSubview:self.searchBar];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.searchBar.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 44);
    table.frame = CGRectMake(0,
                             CGRectGetMaxY(self.searchBar.frame),
                             CGRectGetWidth(self.view.frame),
                             CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.searchBar.frame));
}

#pragma mark -
#pragma mark - setter and getter

- (UISearchBar *)searchBar
{
    if (!searchBar_) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"搜索";
        searchBar.delegate                  = self;
        searchBar.backgroundColor           = [UIColor clearColor];
        searchBar.autoresizesSubviews       = YES;
        searchBar.showsCancelButton         = NO;
        
        for (UIView *view in searchBar.subviews) {
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        
        searchBar_ = searchBar;
    }
    
    return searchBar_;
}

@end
