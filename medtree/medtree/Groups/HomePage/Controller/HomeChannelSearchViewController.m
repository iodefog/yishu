//
//  HomeChannelSearchViewController.m
//  medtree
//
//  Created by tangshimi on 9/25/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelSearchViewController.h"
#import <FontUtil.h>
#import "NewPersonDetailController.h"
#import "MedFeedDTO.h"
#import "EventFeedTableViewCell.h"
#import "FeedLineCell.h"
#import "ChannelManager.h"
#import <JSONKit.h>
#import <InfoAlertView.h>
#import "HomeRecommendChannelDetailDTO.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "HomeArticleAndDiscussionTableViewCell.h"
#import "EmptyDTO.h"
#import "HomeChannelArticleDetailViewController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"

@interface HomeChannelSearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation HomeChannelSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.startIndex = 0;
    self.pageSize = 10;
    
    self.dataArray = [[NSMutableArray alloc] init];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchBar.frame = naviBar.bounds;
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image = GetImage(@"whiteColor_naviBar_background_top.png");
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor whiteColor];
    [table setRegisterCells:@{ @"EmptyDTO" : [SectionSpaceTableViewCell class],
                               @"HomeArticleAndDiscussionDTO" : [HomeArticleAndDiscussionTableViewCell class] }];
    
    [naviBar addSubview:self.searchBar];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self searchRequest];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self searchRequest];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[HomeArticleAndDiscussionDTO class]]) {
        HomeArticleAndDiscussionDTO *DTO = dto;
        if (DTO.type == HomeArticleAndDiscussionTypeArticle ||
            DTO.type == HomeArticleAndDiscussionTypeEvent) {
            HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
            vc.articleDTO = dto;
            vc.updateBlock = ^(HomeArticleAndDiscussionDTO *dto) {
                self.dataArray[index.row] = dto;
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (DTO.type == HomeArticleAndDiscussionTypeDiscussion) {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.articleAndDiscussionDTO = dto;
            vc.updateBlock = ^(HomeArticleAndDiscussionDTO *dto) {
                self.dataArray[index.row] = dto;
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)clickCell:(HomeArticleAndDiscussionDTO *)dto action:(NSNumber *)action
{
    if ([action integerValue] == HomeArticleAndDiscussionTableViewCellActionTypeHeadImage) {
        NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userDTO = dto.userDTO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
#pragma mark - request -

- (void)searchRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelSquare),
                              @"channel_id" : self.channelDetailDTO.channelID,
                              @"key_word" : self.searchBar.text,
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)handleRequest:(NSDictionary *)resultDic
{
    [self stopLoading];
    
    NSArray *articleAndDiscussionArray = resultDic[@"ArticleAndDiscussion"];
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    
    if (articleAndDiscussionArray.count > 0) {
        [articleAndDiscussionArray enumerateObjectsUsingBlock:^(HomeArticleAndDiscussionDTO *dto, NSUInteger idx, BOOL *stop) {
            if (self.startIndex == 0 && idx == 0) {
                EmptyDTO *emptyDTO = [[EmptyDTO alloc] init];
                EmptyDTO *emptyDTO1 = [[EmptyDTO alloc] init];
                
                [self.dataArray addObject:@[ emptyDTO, dto, emptyDTO1 ]];
            } else {
                EmptyDTO *emptyDTO = [[EmptyDTO alloc] init];
                
                [self.dataArray addObject:@[ dto, emptyDTO ]];
            }
        }];
        
        self.startIndex += articleAndDiscussionArray.count;
    }
    
    self.enableFooter = (articleAndDiscussionArray.count == self.pageSize);

    if (articleAndDiscussionArray.count == 0) {
        [InfoAlertView showInfo:@"未搜索到您要搜索的内容" inView:self.view duration:2];
    }
    
    [table setData:self.dataArray];
}

#pragma mark -
#pragma mark - UISearchBarDelegate -

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    self.startIndex = 0;
    [self searchRequest];
}

#pragma mark -
#pragma mark - setter and getter

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"搜索内容";
        searchBar.delegate                  = self;
        searchBar.backgroundColor           = [UIColor clearColor];
        searchBar.autoresizesSubviews       = YES;
        searchBar.showsCancelButton         = YES;
        
        for (UIView *view in searchBar.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                [[view.subviews objectAtIndex:0] removeFromSuperview];
                break;
            }
        }
        
        _searchBar = searchBar;
    }
    
    return _searchBar;
}


@end
