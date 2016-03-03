//
//  MedBaseTableViewController.m
//  medtree
//
//  Created by tangshimi on 10/20/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "MedBaseTableViewController.h"
#import "SVPullToRefresh.h"
#import "UIColor+Colors.h"
#import "MedLoadingView.h"
#import "MedGlobal.h"
#import <InfoAlertView.h>
#import "Aspects.h"
#import "YYFPSLabel.h"

@interface MedBaseTableViewController ()<MedBaseTableViewDelegate>

@property (nonatomic, assign) BOOL firstAppear;
@property (nonatomic, strong) UIView *noNetworkImageView;

@end

@implementation MedBaseTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            if (!self.hideNoNetworkImage && ![MedGlobal checkNetworkStatus]) {
                [self.view addSubview:self.noNetworkImageView];
                
                [self.noNetworkImageView makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
                }];
            }
        } error:NULL];
    }
    return self;
}

- (void)createUI
{
    [super createUI];
    self.view.backgroundColor = [UIColor colorFromHexString:@"#F4F4F7"];
    
    [self.view addSubview:self.tableView];
    table = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstAppear = YES;
    
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(naviBar.frame), GetViewWidth(self.view), GetViewHeight(self.view) - CGRectGetMaxY(naviBar.frame));
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    __weak __typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(loadHeader:)]) {
        [self.tableView addPullToRefreshWithActionHandler:^{
            [weakSelf loadHeader:weakSelf.tableView];
        }];
    }
    
    if ([self respondsToSelector:@selector(loadFooter:)]) {
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadFooter:weakSelf.tableView];
        }];
    }
    
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateAll];
    [self.tableView.pullToRefreshView setTitle:@"释放刷新" forState:SVPullToRefreshStateTriggered];
    [self.tableView.pullToRefreshView setTitle:@"加载中..." forState:SVPullToRefreshStateLoading];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForgroundNotificaion:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
//    YYFPSLabel *fpsLabel = [[YYFPSLabel alloc] initWithFrame:CGRectMake(0, 300, 55, 20)];
//    [self.view addSubview:fpsLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.firstAppear) {
        [MedLoadingView restartAnimationInView:self.view];
    }
    self.firstAppear = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -
#pragma mark - public -

- (UIButton *)createBackButton
{
    UIButton *backButton = [NavigationBar createImageButton:@"btn_back.png"
                                              selectedImage:@"btn_back_click.png"
                                                     target:self
                                                     action:@selector(backButtonAction:)];
    [naviBar setLeftButton:backButton];
    return backButton;
}

- (void)triggerPullToRefresh
{
    [self.tableView triggerPullToRefresh];
}

- (void)stopLoading
{
    if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateLoading) {
        [self.tableView.pullToRefreshView stopAnimating];
    } else if (self.tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
        [self.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)showLoadingView
{
    [MedLoadingView showLoadingViewAddedTo:self.view];
}

- (void)hideLoadingView
{
    [MedLoadingView hideLoadingViewForView:self.view];
}

- (void)showDataEmptyView
{
    if (self.dataEmptyView) {
        [self.view addSubview:self.dataEmptyView];
        
        [self.dataEmptyView remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
        }];
    }
}

- (void)hideDataEmptyView
{
    if (self.dataEmptyView) {
        [self.dataEmptyView removeFromSuperview];
    }
}

#pragma mark -
#pragma mark - response event -

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)enterForgroundNotificaion:(NSNotification *)notification
{
    [MedLoadingView restartAnimationInView:self.view];
}

#pragma mark -
#pragma mark - setter and getter -

- (MedBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = ({
            MedBaseTableView *tableView = [[MedBaseTableView alloc] initWithFrame:CGRectZero
                                                                            style:UITableViewStylePlain];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.parent = self;
            tableView;
        });
    }
    return _tableView;
}

- (UIView *)noNetworkImageView
{
    if (!_noNetworkImageView) {
        _noNetworkImageView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor whiteColor];
            
            UIImageView *imageView = ({
                UIImageView *view = [[UIImageView alloc] initWithImage:GetImage(@"no_networks.png")];
                view;
            });
            
            [view addSubview:imageView];
            
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(0);
            }];
            
            view;
        });
    }
    return _noNetworkImageView;
}

- (void)setEnableHeader:(BOOL)enableHeader
{
    _enableHeader = enableHeader;
    self.tableView.showsPullToRefresh = enableHeader;
}

- (void)setEnableFooter:(BOOL)enableFooter
{
    _enableFooter = enableFooter;
    self.tableView.showNoMoreLogo = !enableFooter;
}

- (void)setShowNoMorelogo:(BOOL)showNoMorelogo
{
    _showNoMorelogo = showNoMorelogo;
    self.tableView.showsInfiniteScrolling = showNoMorelogo;
}

@end
