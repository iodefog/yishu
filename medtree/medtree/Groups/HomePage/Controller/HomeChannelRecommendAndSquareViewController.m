//
//  HomeChannelRecommendViewController.m
//  medtree
//
//  Created by tangshimi on 8/19/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelRecommendAndSquareViewController.h"
#import "EmptyDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "UIColor+Colors.h"
#import "HomeChannelMyInterestViewController.h"
#import "DropdownChoseListView.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeArticleAndDiscussionTableViewCell.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "ChannelManager.h"
#import <JSONKit.h>
#import <InfoAlertView.h>
#import "NewPersonDetailController.h"
#import "HomeChannelArticleDetailViewController.h"

@interface HomeChannelRecommendAndSquareViewController () <DropdownChoseListViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *tableViewHeaderView;
@property (nonatomic, strong) DropdownChoseListView *choseListView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *tagsArray;
@property (nonatomic, assign) NSInteger currentSquareTagIndex;
@property (nonatomic, strong) UIImageView *emptyImageView;

@end

@implementation HomeChannelRecommendAndSquareViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc] init];
    self.tagsArray = [[NSMutableArray alloc] init];
    self.startIndex = 0;
    self.pageSize = 10;
    
    if (self.channelDetailDTO.channelHaveTags) {
        table.tableHeaderView = self.tableViewHeaderView;
    }
    
    table.frame = self.view.bounds;
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self triggerPullToRefresh];
    
    [self getTagsRequest];
}

- (void)createUI
{
    [super createUI];
    
    statusBar.hidden = YES;
    naviBar.hidden = YES;
    
    table.frame = self.view.bounds;
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setRegisterCells:@{ @"EmptyDTO" : [SectionSpaceTableViewCell class],
                               @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                               @"HomeArticleAndDiscussionDTO" : [HomeArticleAndDiscussionTableViewCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[HomeArticleAndDiscussionDTO class]]) {
        HomeArticleAndDiscussionDTO *DTO = dto;
        if (DTO.type == HomeArticleAndDiscussionTypeArticle ||
            DTO.type == HomeArticleAndDiscussionTypeEvent) {
            HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.articleDTO = dto;
            vc.updateBlock = ^(HomeArticleAndDiscussionDTO *dto) {
                self.dataArray[index.row] = dto;
            };
            [self.navigationController pushViewController:vc animated:YES];
        } else if (DTO.type == HomeArticleAndDiscussionTypeDiscussion) {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.articleAndDiscussionDTO = dto;
            vc.updateBlock = ^(HomeArticleAndDiscussionDTO *dto) {
                self.dataArray[index.row] = dto;
            };
            
            vc.deleteBlock = ^{
                [self.dataArray removeObjectAtIndex:index.section];
                [self.tableView setData:self.dataArray];
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

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    if (self.type == HomeChannelRecommendAndSquareViewControllerTypeRecommend) {
        [self getRecommendRequest];
    } else if (self.type == HomeChannelRecommendAndSquareViewControllerTypeSquare) {
        [self getSquareRequest];
    }
}

- (void)loadFooter:(BaseTableView *)table
{
    if (self.type == HomeChannelRecommendAndSquareViewControllerTypeRecommend) {
        [self getRecommendRequest];
    } else if (self.type == HomeChannelRecommendAndSquareViewControllerTypeSquare) {
        [self getSquareRequest];
    }
}

#pragma mark -
#pragma mark - DropdownChoseListViewDelegate -

- (CGSize)contentViewSizeOfDropdownChoseListView:(DropdownChoseListView *)listView
{
    return CGSizeMake(GetViewWidth(self.view), MIN(self.tagsArray.count * 45.0, 225));
}

- (CGFloat)dropdownChoseListView:(DropdownChoseListView *)listView heightForRowAtIndex:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (NSInteger)numberOfItemsForDropdownChoseListView:(DropdownChoseListView *)listView
{
    return self.tagsArray.count;
}

- (NSString *)dropdownChoseListView:(DropdownChoseListView *)listView titleForRowAtIndex:(NSIndexPath *)indexPath
{
    return self.tagsArray[indexPath.row][@"name"];
}

- (void)dropdownChoseListView:(DropdownChoseListView *)listView didSelectedAtIndex:(NSIndexPath *)indexPath
{
    self.currentSquareTagIndex = indexPath.row;

    self.startIndex = 0;
    [self getSquareRequest];    
}

#pragma mark -
#pragma mark - public -

- (void)reloadData
{
    if (self.type == HomeChannelRecommendAndSquareViewControllerTypeSquare) {
        self.startIndex = 0;
        [self getSquareRequest];
    }
}

#pragma mark - 
#pragma mark - response event -

- (void)titleButtonAction:(UIButton *)button
{
    if (self.type == HomeChannelRecommendAndSquareViewControllerTypeRecommend) {
        HomeChannelMyInterestViewController *vc = [[HomeChannelMyInterestViewController alloc] init];
        vc.type = HomeChannelMyInterestViewControllerTypeNormalChoseInterest;
        vc.channelDatailDTO = self.channelDetailDTO;
        vc.updateBlock = ^{
            self.startIndex = 0;
            [self getRecommendRequest];
        };
        [self presentViewController:vc animated:YES completion:nil];
    } else if (self.type == HomeChannelRecommendAndSquareViewControllerTypeSquare) {
        self.choseListView.selectedIndexPath = [NSIndexPath indexPathForRow:self.currentSquareTagIndex inSection:0];
        [self.choseListView showInView:self.view
                                 frame:CGRectMake(0,
                                                  GetViewHeight(self.tableViewHeaderView),
                                                  GetViewWidth(self.view),
                                                  GetViewHeight(self.view) - GetViewHeight(self.tableViewHeaderView))
                              animated:YES];
    }
}

#pragma mark -
#pragma mark - netWork -

- (void)getRecommendRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelRecommend),
                              @"channel_id" : self.channelDetailDTO.channelID,
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

- (void)getSquareRequest
{
    NSString *tag = nil;
    if (self.tagsArray.count > self.currentSquareTagIndex) {
        tag = self.tagsArray[self.currentSquareTagIndex][@"id"];
    }
    
    NSDictionary *params = nil;
    
    if (tag) {
        params = @{ @"method" : @(MethodTypeChannelSquare),
                    @"channel_id" : self.channelDetailDTO.channelID,
                    @"tag" : tag,
                    @"from" : @(self.startIndex),
                    @"size" : @(self.pageSize) };
    } else {
        params = @{ @"method" : @(MethodTypeChannelSquare),
                    @"channel_id" : self.channelDetailDTO.channelID,
                    @"from" : @(self.startIndex),
                    @"size" : @(self.pageSize) };
    }
    
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
                [self.dataArray addObject:@[ dto ]];
            } else {
                [self.dataArray addObject:@[ dto ]];
            }
        }];
        
        self.startIndex += articleAndDiscussionArray.count;
    }
    
    self.enableFooter = (articleAndDiscussionArray.count == self.pageSize);
    
    if (articleAndDiscussionArray.count == 0 && self.dataArray.count == 0) {
        [self.view addSubview:self.emptyImageView];
        [self.emptyImageView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.centerX);
            make.centerY.equalTo(self.view.centerY);
        }];
    } else {
        [self.emptyImageView removeFromSuperview];
    }
    
    [table setData:self.dataArray];
}

- (void)getTagsRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelRecommendTags), @"channel_id" : self.channelDetailDTO.channelID };
    [ChannelManager getChannelParam:params success:^(id JSON) {
        NSDictionary *resultDic = JSON;
        if ([resultDic[@"status"] boolValue]) {
            [self.tagsArray addObjectsFromArray:resultDic[@"allTags"]];
            [self.tagsArray insertObject: @{ @"name" : @"全部标签" } atIndex:0];
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - 
#pragma mark - setter and getter -

- (UIButton *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [UIColor whiteColor];
            button.frame = CGRectMake(0, 0, GetScreenWidth, 35);
            [button addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            NSString *title = (self.type == HomeChannelRecommendAndSquareViewControllerTypeRecommend ? @"我感兴趣的内容" : @"全部标签");
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 35)];
            label.textAlignment = NSTextAlignmentLeft;
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [UIColor blackColor];
            label.text = title;
            [button addSubview:label];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(GetScreenWidth - 20, 0, 5, 35)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = GetImage(@"img_next.png");
            [button addSubview:imageView];
            
            button;
        });
    }
    
    return _tableViewHeaderView;
}

- (DropdownChoseListView *)choseListView
{
    if (!_choseListView) {
        _choseListView = ({
            DropdownChoseListView *listView = [[DropdownChoseListView alloc] initWithFrame:CGRectZero];
            listView.delegate = self;
            listView;
        });
    }
    return _choseListView;
}

- (UIImageView *)emptyImageView
{
    if (!_emptyImageView) {
        _emptyImageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            NSString *imageName = self.type == HomeChannelRecommendAndSquareViewControllerTypeRecommend ?  @"home_ recommend_empty.png" : @"home_ square_empty.png";
            imageView.image = GetImage(imageName);
            imageView;
        });
    }
    return _emptyImageView;
}

@end
