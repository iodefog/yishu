   //
//  HomeViewController.m
//  medtree
//
//  Created by tangshimi on 8/17/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationBarHeadView.h"
#import "RootViewController.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "UIColor+Colors.h"
#import "HomeRecommendChannelDTO.h"
#import "HomeRecommendChannelTableViewCell.h"
#import "HomeChannelViewController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeArticleAndDiscussionTableViewCell.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "HomePosterView.h"
#import "HomeChannelArticleDetailViewController.h"
#import "ChannelManager.h"
#import "NewPersonDetailController.h"
#import "HomeRecommendChannelDetailDTO.h"
#import "HomeChannelMyInterestViewController.h"
#import <InfoAlertView.h>
#import <JSONKit.h>
#import "UrlParsingHelper.h"
#import "NewPersonIdentificationController.h"
#import "HomeGuideView.h"
#import "HomeJobChannelViewController.h"
#import "MedLoadingView.h"
#import "HomeJobChannelIntersetViewController.h"
#import "UrlParsingHelper.h"
#import "HomeChannelMoreViewController.h"
#import "MedHorizontalScrollTabView.h"

@interface HomeViewController () <BaseTableViewDelegate, MedHorizontalScrollTabViewDelegate>

@property (nonatomic, strong) NavigationBarHeadView *leftBarItem;
@property (nonatomic, strong) HomePosterView *posterView;
@property (nonatomic, assign) BOOL showPosterView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) MedHorizontalScrollTabView *tabView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSMutableArray alloc] init];
    self.hideNoNetworkImage = YES;
    self.pageSize = 10;
    self.showPosterView = YES;
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfoChangeNotificationAction:)
                                                 name:UserInfoChangeNotification
                                               object:nil];
    
    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    self.tableView.backgroundColor = [UIColor colorFromHexString:@"#F4F4F7"];
    
    [self showLoadingView];    
}

- (void)createUI
{
    [super createUI];
    [naviBar setTopTitle:@"首页"];
    
    [naviBar setLeftButton:self.leftBarItem];
    
    table.registerCells = @{ @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                             @"HomeRecommendChannelDTO" : [HomeRecommendChannelTableViewCell class],
                             @"HomeArticleAndDiscussionDTO" : [HomeArticleAndDiscussionTableViewCell class] };
    
    [self.view addSubview:self.topView];
    self.topView.frame = CGRectMake(0, 64, GetScreenWidth, 40);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
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
            vc.articleDTO = dto;
            [ClickUtil event:@"homepage_recommend_articlanddiscuss" attributes:@{@"article_id":DTO.id, @"title":DTO.title}];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (DTO.type == HomeArticleAndDiscussionTypeDiscussion) {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.articleAndDiscussionDTO = dto;
            [ClickUtil event:@"homepage_recommend_articlanddiscuss" attributes:@{@"discuss_id":DTO.id, @"title":DTO.title}];
            vc.updateBlock = ^(HomeArticleAndDiscussionDTO *dto) {
                NSMutableArray *sectionArray = [self.dataArray[index.section] mutableCopy];
                sectionArray[0] = dto;
                
                self.dataArray[index.section] = sectionArray;
            };
            
            vc.deleteBlock = ^{
                [self.dataArray removeObjectAtIndex:index.section];
                [self.tableView setData:self.dataArray];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)clickCell:(HomeRecommendChannelDetailDTO *)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    if (!dto.channelID) {
        HomeChannelMoreViewController *vc = [[HomeChannelMoreViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    [ClickUtil event:@"homepage_open_channel" attributes:@{@"channel_id":dto.channelID, @"title":dto.channelName}];
    
    if (dto.canEnter) {
        if (dto.channelHaveTags && !dto.alreadySetTags) {
            if (dto.type == HomeRecommendChannelDetailDTOTypeNormalChannel || dto.type == HomeRecommendChannelDetailDTOTypeUnKnow) {
                HomeChannelMyInterestViewController *vc = [[HomeChannelMyInterestViewController alloc] init];
                vc.updateBlock = ^ {
                    dto.alreadySetTags = YES;
                    if ([[self.dataArray firstObject][1] isKindOfClass:[HomeRecommendChannelDTO class]]) {
                        HomeRecommendChannelDTO *channelDTO = [self.dataArray firstObject][1];
                        NSMutableArray *array = [channelDTO.channelArray mutableCopy];
                        array[[action integerValue]] = dto;
                        
                        channelDTO.channelArray = array;
                        
                        HomeRecommendChannelTableViewCell *cell = [table cellForRowAtIndexPath:index];
                        [cell setInfo:channelDTO indexPath:index];
                    }
                };
                vc.channelDatailDTO = dto;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (dto.type == HomeRecommendChannelDetailDTOTypeJobChannel) {
                HomeJobChannelIntersetViewController *vc = [[HomeJobChannelIntersetViewController alloc] init];
                vc.type = HomeJobChannelIntersetViewControllerTypeChoseInterest;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        } else {
            if (dto.type == HomeRecommendChannelDetailDTOTypeNormalChannel || dto.type == HomeRecommendChannelDetailDTOTypeUnKnow) {
                HomeChannelViewController *channelVC = [[HomeChannelViewController alloc] init];
                channelVC.channelDetailDTO = dto;
                channelVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:channelVC animated:YES];
            } else if (dto.type == HomeRecommendChannelDetailDTOTypeJobChannel) {
                HomeJobChannelViewController *vc = [[HomeJobChannelViewController alloc] init];
                vc.title = dto.channelName;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else {
        [InfoAlertView showInfo:@"认证身份后才可以进入哦！" inView:self.view duration:1];
        self.view.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.view.userInteractionEnabled = YES;
            NewPersonIdentificationController *identification = [[NewPersonIdentificationController alloc] init];
            identification.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:identification animated:YES];
            [identification loadData];
        });
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
    [self getDataFromNet];    
}

- (void)loadFooter:(BaseTableView *)table
{
    [self getDataFromNet];
}

#pragma mark -
#pragma mark - HorizontalScrollTabViewDelegate -

- (void)horizontalScrollTabViewItemDidClick:(NSInteger)selectedIndex
{
    if ([[self.dataArray firstObject] count] > 1) {
        if ([self.dataArray.firstObject[1] isKindOfClass:[HomeRecommendChannelDTO class]]) {
            HomeRecommendChannelDTO *dto = [self.dataArray firstObject][1];
            
            [self clickCell:dto.channelArray[selectedIndex] index:nil action:nil];
        }
    }
}

#pragma mark -
#pragma mark - response event -

- (void)userInfoChangeNotificationAction:(NSNotification *)notification
{
    self.tableView.contentOffset = CGPointMake(0, 0);
    self.posterView.posterArray = nil;
    
    [self advertisementRequest];

    //[self getdataFromLocal];
    [self triggerPullToRefresh];
    
    self.showPosterView = YES;
    table.tableHeaderView = self.posterView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat offsetY ;
    if (self.posterView.posterArray.count > 0 && self.showPosterView) {
        offsetY =  125 + 30 + 180 + 30;
    } else {
        offsetY = 30 + 180 + 30;
    }
    
    if (self.tableView.contentOffset.y > offsetY) {
        self.topView.hidden = NO;
    } else {
        self.topView.hidden = YES;
    }
}

#pragma mark -
#pragma mark - network -

- (void)getDataFromNet
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelHomePage),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self hideLoadingView];
        [self handleRequest:JSON];
    } failure:^(NSError *error, id JSON){
        [self stopLoading];
        [self hideLoadingView];
        
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
    }];
}

- (void)getdataFromLocal
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelHomePage),
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    [ChannelManager getChannelFromLocalParam:params success:^(id JSON) {
        if (JSON) {
            [self hideLoadingView];
            [self handleRequest:JSON];
        }
    }];
}

- (void)handleRequest:(NSDictionary *)resultDic
{
    [self stopLoading];
    
    NSMutableArray *channelArray = [resultDic[@"recommandChannel"] mutableCopy];
    NSArray *articleAndDiscussionArray = resultDic[@"ArticleAndDiscussion"];

    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    
    if (channelArray.count > 0 && self.startIndex == 0) {
        SectionTitleDTO *titleDTO = [[SectionTitleDTO alloc] init];
        titleDTO.verticalViewColor = [UIColor colorFromHexString:@"#eb6100"];
        titleDTO.title = @"频道精选";
        titleDTO.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
        titleDTO.hideFooterLine = YES;
        
        HomeRecommendChannelDTO *recommendChannelDTO = [[HomeRecommendChannelDTO alloc] init];
        recommendChannelDTO.moreChannel = [resultDic[@"hasMoreChannel"] boolValue];
        if (recommendChannelDTO.moreChannel) {
            HomeRecommendChannelDetailDTO *dto = [[HomeRecommendChannelDetailDTO alloc] init];
            dto.channelName = @"查看更多";
            [channelArray addObject:dto];
        }
        recommendChannelDTO.channelArray = channelArray;
        
        [self.dataArray addObject:@[ titleDTO,recommendChannelDTO ]];
        
        NSMutableArray *array = [NSMutableArray new];
        for (HomeRecommendChannelDetailDTO *dto in channelArray) {
            [array addObject:dto.channelName];
        }
        self.tabView.itemsArray = array;
    }
    
    if (articleAndDiscussionArray.count > 0) {
        [articleAndDiscussionArray enumerateObjectsUsingBlock:^(HomeArticleAndDiscussionDTO *dto, NSUInteger idx, BOOL *stop) {
            if (self.startIndex == 0 && idx == 0) {
                SectionTitleDTO *titleDTO = [[SectionTitleDTO alloc] init];
                titleDTO.verticalViewColor = [UIColor colorFromHexString:@"#365c8a"];
                titleDTO.title = @"内容精选";
                titleDTO.backgroundColor = [UIColor colorFromHexString:@"#f4f4f7"];
                titleDTO.hideFooterLine = YES;
                
                [self.dataArray addObject:@[ titleDTO, dto ]];
            } else {
                [self.dataArray addObject:@[ dto ]];
            }
        }];
        
        if (self.isViewLoaded && self.view.window && self.startIndex == 0) {
            if ([HomeGuideView showInView:self.tabBarController.view]) {
                if (self.posterView.posterArray.count > 0) {
                    [self.tableView setContentOffset:CGPointMake(0, 125) animated:YES];
                }
            }
        }
        
        self.startIndex += articleAndDiscussionArray.count;
    }
    
    self.enableFooter = (articleAndDiscussionArray.count == self.pageSize);
    
    [table setData:self.dataArray];
}

- (void)advertisementRequest
{
    [ChannelManager getChannelParam:@{ @"method" : @(MethodTypeChannelHomepageAdvertisement) } success:^(id JSON) {
        if ([JSON count] > 0) {
            self.tableView.tableHeaderView = self.posterView;
            self.posterView.posterArray = JSON;
        } else {
            self.tableView.tableHeaderView = nil;
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (NavigationBarHeadView *)leftBarItem
{
    if (!_leftBarItem) {
        _leftBarItem = ({
            NavigationBarHeadView *headView = [[NavigationBarHeadView alloc] init];
            headView.clickBlock = ^{
                [[RootViewController shareRootViewController] showLeftSideMenuViewController];
            };
            headView;
        });
    }
    return _leftBarItem;
}

- (HomePosterView *)posterView
{
    if (!_posterView) {
        _posterView = ({            
            HomePosterView *view = [[HomePosterView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 125)];
            view.clickBlock = ^(NSString *url, NSString *title) {
                [ClickUtil event:@"AD_click" attributes:nil];
                
                [UrlParsingHelper operationUrl:url controller:self title:title];
            };
            
            __weak typeof(self) weakSelf = self;
            view.closeBlock = ^{
                table.tableHeaderView = nil;
                weakSelf.showPosterView = NO;
            };
            
            view;
        });
    }
    return _posterView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            view.userInteractionEnabled = YES;
            
            UILabel *titleLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"频道";
                label.font = [UIFont systemFontOfSize:15];
                label;
            });
            [view addSubview:titleLabel];
            
            UIView *seperateView = ({
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor lightGrayColor];
                view;
            });
            [view addSubview:seperateView];
            
            
            [titleLabel makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(0);
                make.left.equalTo(10);
            }];
            
            [seperateView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(5);
                make.bottom.equalTo(-5);
                make.left.equalTo(50);
                make.width.equalTo(1);
            }];
            
            MedHorizontalScrollTabView *tabView = [[MedHorizontalScrollTabView alloc] initWithFrame:CGRectMake(51, 0, GetScreenWidth - 50, 40)];
            tabView.itemSpace = 20;
            tabView.edgeSpace = 20;
            tabView.delegate = self;
            [view addSubview:tabView];
            _tabView = tabView;
            
            UIView *bottomView = ({
                UIView *view = [UIView new];
                view.backgroundColor = [UIColor lightGrayColor];
                view;
            });
            
            [view addSubview:bottomView];
            
            [bottomView makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.equalTo(0);
                make.height.equalTo(0.5);
            }];
            
            view;
        });
    }
    return _topView;
}

@end
