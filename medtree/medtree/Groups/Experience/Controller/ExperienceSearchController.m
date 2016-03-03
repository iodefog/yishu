//
//  ExperienceSearchController.m
//  medtree
//
//  Created by 边大朋 on 15/6/13.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "ExperienceSearchController.h"
#import "ColorUtil.h"
#import "InfoAlertView.h"

@interface  ExperienceSearchController ()<UISearchBarDelegate, RegisterOrganizationAddViewDelegate,ExperienceTableViewDelegate>

@end

@implementation ExperienceSearchController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    searchView = [[UISearchBar alloc] init];
    [self createSearchBar:searchView Cancel:YES];
    
    dataArray = [[NSMutableArray alloc] init];
    searchArray = [[NSMutableArray alloc] init];
    
    [self createCommonView];
    
    searchView.hidden = YES;
}

- (void)createSearchView
{
    NSLog(@"create search view ========================================================>");
}

- (void)searchViewClickAdd
{
    NSLog(@"search View Click Add ========================================================>");
}

#pragma mark - ExperienceTableViewDelegate
- (void)selectTitle:(id)dto
{
    NSLog(@"select title ========================================================>");
}

- (void)getMoreData
{
    NSLog(@"get More Data ========================================================>");
}

#pragma mark - private
- (void)createSearchBar:(UISearchBar *)searchBar Cancel:(BOOL)cancel
{
    searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
    searchBar.placeholder               = @"搜索|添加";
    searchBar.autocapitalizationType    = UITextAutocapitalizationTypeNone;
    searchBar.delegate                  = self;
    searchBar.backgroundColor           = [UIColor clearColor];
    searchBar.alpha                     = 1;
    searchBar.userInteractionEnabled    = YES;
    searchBar.autoresizesSubviews       = YES;
    searchBar.showsCancelButton         = cancel;
    
    searchBar.hidden = NO;
    
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchBar];
}

- (void)createCommonView
{
    commonTable = [[ExperienceTableView alloc] init];
    commonTable.parent = self;
    [self.view addSubview:commonTable];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
//    CGFloat searchBarH = 24;
//    CGFloat searchBgH = searchBarH + 6 * 2;
    if (searchView.hidden) {
//        searchBgH = 0;
    }
    
    CGSize size = self.view.frame.size;
    CGFloat searchViewH = 44;
    searchView.frame = CGRectMake(0, [self getOffset], size.width, searchViewH);
    CGFloat naviBarY = CGRectGetMaxY(naviBar.frame);
    registerOrganizationAddView.frame = CGRectMake(0, naviBarY, size.width, 60);
    searchTable.frame = CGRectMake(0, CGRectGetMaxY(registerOrganizationAddView.frame), size.width, size.height - CGRectGetMaxY(registerOrganizationAddView.frame));
    
//    commonTable.frame = CGRectMake(0, naviBarY, size.width, size.height - naviBarY);
    coverView.frame = CGRectMake(0, naviBarY, size.width, size.height - naviBarY);
}

#pragma mark - public
- (void)searchBecomeFirstResponder
{
    coverView.hidden = NO;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSInteger number = [searchView.text length];
    if (number > 20)
    {
        searchView.text = [searchView.text substringToIndex:20];
        [InfoAlertView showInfo:@"搜索仅限20字" inView:self.view duration:2.0f];
    } else {
        [self searchAction:searchBar];
    }
    [registerOrganizationAddView setData:searchView.text.length>0?[NSString stringWithFormat:@"%@",searchView.text]:@""];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearch = NO;
    [registerOrganizationAddView setData:@""];
    [searchView resignFirstResponder];
    [searchTable reloadArray];
    registerOrganizationAddView.hidden = YES;
    searchView.hidden = YES;
    coverView.hidden = YES;
    searchTable.hidden = YES;
    searchView.text = @"";
}

#pragma mark - private
- (void)searchAction:(UISearchBar *)searchBar
{
    if (searchBar.text.length == 0) {
        [searchTable setInfo:nil];
        return;
    }
    
    [registerOrganizationAddView setData:searchView.text];
    [searchArray removeAllObjects];
    [searchTable setInfo:[NSArray array]];
    searchTable.hidden = NO;
    isSearch = YES;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObject:[NSNumber numberWithInteger:0] forKey:@"from"];
    [param setObject:[searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"q"];
    if ([typeTitle isEqualToString:@"organization"]) {
        [self getOrganizationDataWithDict:param];
    } else {
        [self getDepartmentDataWithDict:param];
    }
}

#pragma mark - click
- (void)clickTap
{
    isSearch = NO;
    searchTable.hidden = YES;
    [searchTable reloadArray];
    [searchView resignFirstResponder];
    [searchView setText:@""];
    
    registerOrganizationAddView.hidden = NO;
    searchView.hidden = NO;
    coverView.hidden = NO;
}

#pragma mark - private
- (void)getOrganizationDataWithDict:(NSMutableDictionary *)dict
{
    
}

- (void)getDepartmentDataWithDict:(NSMutableDictionary *)dict
{
    
}

@end
