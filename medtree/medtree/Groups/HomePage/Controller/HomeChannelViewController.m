//
//  HomeViewController.m
//  medtree
//
//  Created by tangshimi on 7/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelViewController.h"
#import "HorizontalScrollTabView.h"
#import "HomeChannelRecommendAndSquareViewController.h"
#import "HomeChannelGroupViewController.h"
#import "HomeChannelWriteViewController.h"
#import "HomeChannelWriteViewController.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "HomeChannelSearchViewController.h"
#import "HomeChannelGuideView.h"

@interface HomeChannelViewController () <HorizontalScrollTabViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) HorizontalScrollTabView *tabView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *viewControllerArray;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *writeFeedButton;

@end

@implementation HomeChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), CGRectGetWidth(self.view.frame), 40);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.tabView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - CGRectGetMaxY(self.tabView.frame));
    self.scrollView.contentSize = CGSizeMake(GetViewWidth(self.scrollView) * 2, GetViewHeight(self.view) - CGRectGetMaxY(self.tabView.frame));
    
    UIView *bottomLineView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        view;
    });
    
    [self.tabView addSubview:bottomLineView];
    
    [bottomLineView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.left.equalTo(@0);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(@0);
    }];

    [naviBar setTopTitle:self.channelDetailDTO.channelName];
    [naviBar setRightButton:self.searchButton];
    
    self.viewControllerArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 3; i ++) {
        [self.viewControllerArray addObject:[NSNull null]];
    }
    
    [self addChildViewControllerViewWithIndex:0];
    
    if (self.channelDetailDTO.canPublish) {
        [self.view addSubview:self.writeFeedButton];
        
        [self.writeFeedButton makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-15);
            make.bottom.equalTo(@-45);
        }];
    }
    
    [HomeChannelGuideView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)createUI
{
    [super createUI];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    
    [self createBackButton];
    
    [self.view addSubview:self.tabView];
    [self.view addSubview:self.scrollView];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / GetScreenWidth;
    [self.tabView setSelectedItemIndex:index];
    [self addChildViewControllerViewWithIndex:index];
    
    self.searchButton.hidden = (index != 0);
    self.writeFeedButton.hidden = (index != 0);
}

#pragma mark -
#pragma mark - HorizontalScrollTabViewDelegate -

- (BOOL)horizontalScrollTabViewItemShouldClick:(NSInteger)selectedIndex
{
    return YES;
}

- (void)horizontalScrollTabViewItemDidClick:(NSInteger)selectedIndex
{
    self.scrollView.contentOffset = CGPointMake(GetScreenWidth * selectedIndex, 0);
    [self addChildViewControllerViewWithIndex:selectedIndex];
    
    self.searchButton.hidden = (selectedIndex != 0);
    self.writeFeedButton.hidden = (selectedIndex != 0);
}

#pragma mark -
#pragma mark - response event -

- (void)searchButtonAction:(UIButton *)button
{
    HomeChannelSearchViewController *vc = [[HomeChannelSearchViewController alloc] init];
    vc.channelDetailDTO = self.channelDetailDTO;
    
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBar.hidden = YES;
    
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)writeFeedButtonAction:(UIButton *)button
{
    HomeChannelWriteViewController *vc = [[HomeChannelWriteViewController alloc] init];
    vc.channelDetailDTO = self.channelDetailDTO;
    vc.updateBlock = ^{
        if ([self.viewControllerArray[0] isKindOfClass:[HomeChannelRecommendAndSquareViewController class]]) {
            HomeChannelRecommendAndSquareViewController *vc = self.viewControllerArray[0];
            [vc reloadData];
        };
    };
    
    NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
    nvc.navigationBarHidden = YES;
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - 
#pragma mark - helper -

- (void)addChildViewControllerViewWithIndex:(NSInteger)index
{
    if (index > 3 || ![self.viewControllerArray[index] isEqual:[NSNull null]]) {
        return;
    }
    
    switch (index) {
        case 0: {
            HomeChannelRecommendAndSquareViewController *vc = [[HomeChannelRecommendAndSquareViewController alloc] init];
            vc.type = HomeChannelRecommendAndSquareViewControllerTypeSquare;
            vc.channelDetailDTO = self.channelDetailDTO;
            vc.view.frame = CGRectMake(0, 0, GetScreenWidth, GetViewHeight(self.scrollView));
            [self.scrollView addSubview:vc.view];
            
            [self addChildViewController:vc];
            
            [self.viewControllerArray replaceObjectAtIndex:index withObject:vc];
            break;
        }
        case 1:{
            HomeChannelRecommendAndSquareViewController *vc = [[HomeChannelRecommendAndSquareViewController alloc] init];
            vc.type = HomeChannelRecommendAndSquareViewControllerTypeRecommend;
            vc.channelDetailDTO = self.channelDetailDTO;
            vc.view.frame = CGRectMake(GetScreenWidth * index, 0, GetScreenWidth, GetViewHeight(self.scrollView));
            [self.scrollView addSubview:vc.view];
            
            [self addChildViewController:vc];
            
            [self.viewControllerArray replaceObjectAtIndex:index withObject:vc];
            break;
        }
        case 2: {
            HomeChannelGroupViewController *vc = [[HomeChannelGroupViewController alloc] init];
            vc.view.frame = CGRectMake(GetScreenWidth * index, 0, GetScreenWidth, GetViewHeight(self.scrollView));
            [self.scrollView addSubview:vc.view];
            
            [self addChildViewController:vc];
            
            [self.viewControllerArray replaceObjectAtIndex:index withObject:vc];
            break;
        }
    }
}

#pragma mark - 
#pragma mark - response event -

- (void)clickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - setter and getter -

- (HorizontalScrollTabView *)tabView
{
    if (!_tabView) {
        _tabView = ({
            HorizontalScrollTabView *tabView = [[HorizontalScrollTabView alloc] initWithFrame:CGRectZero];
            tabView.delegate = self;
            tabView.minItemWidth = 100;
            tabView.edgeSpace = GetScreenWidth > 320 ? 32.5 : 25;
            tabView.itemSpace = (GetScreenWidth - 65 - 180) / 2.0;
            tabView.itemFont = [UIFont systemFontOfSize:15];
            tabView.selectedItemColor = [UIColor blackColor];
            tabView.unSelectedItemColor = [UIColor blackColor];
            tabView.showBottomLine = YES;
            tabView.selectedItemIndex = 0;
           // tabView.items = @[ @"推荐", @"广场", @"群组"];
             tabView.items = @[ @"广场", @"推荐" ];
            tabView;
        });
    }
    return _tabView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView;
        });
    }
    return _scrollView;
}

- (UIButton *)searchButton
{
    if (!_searchButton) {
        _searchButton = [NavigationBar createImageButton:@"home_search.png" target:self action:@selector(searchButtonAction:)];
    }
    return _searchButton;
}

- (UIButton *)writeFeedButton
{
    if (!_writeFeedButton) {
        _writeFeedButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"home_channel_write_feed.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(writeFeedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _writeFeedButton;
}

@end
