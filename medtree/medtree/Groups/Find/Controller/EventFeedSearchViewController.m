//
//  EventFeedSearchViewController.m
//  medtree
//
//  Created by tangshimi on 8/12/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedSearchViewController.h"
#import <FontUtil.h>
#import <ColorUtil.h>
#import "MedFeedDTO.h"
#import "EventFeedTableViewCell.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import <JSONKit.h>
#import "FeedLineCell.h"
#import "Pair2DTO.h"
#import "NewPersonDetailController.h"
#import "EventFeedDetailViewController.h"
#import "StatusView.h"

@interface EventFeedSearchViewController () <UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) StatusView *statusView;

@end

@implementation EventFeedSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc] init];
    table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchBar.frame = naviBar.bounds;
    
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [FontUtil setBtnTitleFontColor:[UIColor whiteColor]];
    [FontUtil setBarFontColor:[UIColor whiteColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)createUI
{
    [FontUtil setBtnTitleFontColor:[ColorUtil getColor:@"365c8a" alpha:1]];
    [FontUtil setBarFontColor:[UIColor blackColor]];
    
    [super createUI];
    
    [naviBar changeBackGroundImage:@"whiteColor_naviBar_background.png"];
    statusBar.image =  GetImage(@"whiteColor_naviBar_background_top.png");
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setRegisterCells:@{ @"MedFeedDTO" : [EventFeedTableViewCell class],
                               @"Pair2DTO" : [FeedLineCell class] }];
    
    [naviBar addSubview:self.searchBar];
}

#pragma mark -
#pragma mark - request -

- (void)searchRequest
{
    [self.view addSubview:self.statusView];
    [self.statusView showWithStatusType:StatusViewLoadingStatusType];
    
    NSDictionary *param = @{ @"title" : self.searchTitle,
                             @"keyword" : self.searchBar.text,
                             @"method" : @(MethodTypeEventFeedSearch) };

    [EventManager getData:param success:^(id JSON) {
        [self stopLoading];
        
        [self.dataArray removeAllObjects];
        
        if ([JSON[@"status"] boolValue] == YES) {
            NSArray *commentArray = JSON[@"commentArray"];
            
            for (MedFeedDTO *feedDTO in commentArray) {
                NSMutableArray *sectionArray = [NSMutableArray new];
                feedDTO.searchFeed = YES;
                
                [sectionArray addObject:feedDTO];
                Pair2DTO *pairDto = [[Pair2DTO alloc] init];
                [sectionArray addObject:pairDto];
                
                [self.dataArray addObject:sectionArray];
            }
        }
    
        if (self.dataArray.count == 0) {
            [self.statusView showWithStatusType:StatusViewEmptyStatusType];
            [InfoAlertView showInfo:@"未找到您要搜索的信息"  inView:self.view duration:1];
        } else {
            [self.statusView removeFromSuperViewWhenHide];
            [table setData:self.dataArray];
        }
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];

        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                if ([[table getData] count] == 0) {
                    [self.statusView showWithStatusType:StatusViewEmptyStatusType];
                }
                [InfoAlertView showInfo:[result objectForKey:@"message"]  inView:self.view duration:1];
            }
        }
    }];
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
    
    [self searchRequest];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)loadHeader:(BaseTableView *)table
{
    [self searchRequest];
}

- (void)clickCell:(MedFeedDTO *)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    switch ([action integerValue]) {
        case EventFeedTableViewCellActionTypeHeadView: {
            NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
            vc.userId = dto.creatorID;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    [self.view endEditing:YES];
    
    EventFeedDetailViewController *vc = [[EventFeedDetailViewController alloc] init];
    vc.feedDTO = dto;
    vc.updateBlock = ^{
        [self searchRequest];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - setter and getter

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.autocorrectionType        = UITextAutocorrectionTypeNo;
        searchBar.placeholder               = @"搜索姓名/动态";
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

- (StatusView *)statusView
{
    if (!_statusView) {
        _statusView = ({
            StatusView *view = [[StatusView alloc] initWithInView:self.view];
            view.removeFromSuperViewWhenHide = YES;
            view;
        });
    }
    return _statusView;
}

@end
