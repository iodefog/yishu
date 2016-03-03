//
//  MessageNotificationHistoryController.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MessageNotificationHistoryController.h"
// view
#import "NotifyMessageCell.h"
#import "SectionSpaceTableViewCell.h"
#import "NewPersonDetailController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "EventFeedDetailViewController.h"
#import "EventFeedViewController.h"
#import "HomeChannelArticleDetailViewController.h"
#import "HomeJobChannelUnitJobViewController.h"
// dto
#import "EmptyDTO.h"
#import "PostDTO.h"
#import "NotifyMessageDTO.h"
// manager
#import "MessageManager.h"
#import <InfoAlertView.h>

@interface MessageNotificationHistoryController ()
{
    NSUInteger from;
}

@property (nonatomic, strong) NSMutableArray    *dataList;
@property (nonatomic, strong) UIImageView       *emptyView;

@end

@implementation MessageNotificationHistoryController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"NotifyMessageDTO":[NotifyMessageCell class],
                           @"EmptyDTO":[SectionSpaceTableViewCell class]}];
    [naviBar setTopTitle:@"历史通知"];
    [self createBackButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    
    [self getHistoryData];
}

- (void)setupView
{
    table.enableFooter = true;
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
}

#pragma mark - data
- (void)getHistoryData
{
    [self showProgress];
    __unsafe_unretained typeof(self) weakSelf = self;
    [MessageManager getData:@{@"method":@(MethodType_Message_Notify_History), @"from":@(from), @"size":@20} success:^(NSArray *data) {
        [self hideProgress];
        if (data.count > 0) {
            if ([weakSelf.view.subviews containsObject:weakSelf.emptyView]) {
                [weakSelf.emptyView removeFromSuperview];
            }
            if (data.count < 20) {
                table.enableFooter = NO;
            }
            for (NSDictionary *dict in data) {
                NotifyMessageDTO *dto = [[NotifyMessageDTO alloc] init:dict];
                EmptyDTO *empty = [[EmptyDTO alloc] init];
                [weakSelf.dataList addObject:@[dto, empty]];
            }
            [table setData:self.dataList];
        } else {
            if (from == 0) {
                [weakSelf.view addSubview:weakSelf.emptyView];
                [weakSelf.emptyView makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
                }];
            }
        }
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"服务器出错啦" inView:self.view duration:1.5];
        [weakSelf hideProgress];
        weakSelf->table.enableHeader = NO;
        weakSelf->table.enableFooter = NO;
        [weakSelf.view addSubview:weakSelf.emptyView];
        [weakSelf.emptyView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
        }];
    }];
}

#pragma mark - private
- (void)showProgress
{
    
}

- (void)hideProgress
{
    
}

#pragma mark - mark 
- (void)loadHeader:(BaseTableView *)table
{
    from = 0;
    [self.dataList removeAllObjects];
    [self getHistoryData];
}

- (void)loadFooter:(BaseTableView *)table
{
    from = self.dataList.count;
    [self getHistoryData];
}

#pragma mark - click
- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if (action.integerValue == kClickHeadAction) {
        NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
        vc.userDTO = dto;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (action.integerValue == kClickPostAction) {
        if ([dto isKindOfClass:[PostDTO class]]) {
            PostDTO *post = (PostDTO *)dto;
            switch (post.type) {
                case PostRefTypeUnknown: {
                    
                    break;
                }
                case PostRefTypeDiscuss: {
                    HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
                    vc.articleAndDiscussionID = post.postID;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case PostRefTypePosition:{
                    HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
                    vc.employmentID = post.postID;
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case PostRefTypeHomeEvent:
                case PostRefTypeArticle: {
                    HomeChannelArticleDetailViewController *vc = [[HomeChannelArticleDetailViewController alloc] init];
                    vc.articleID = post.postID;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case PostRefTypeFriendFeed: {
                    EventFeedDetailViewController *vc = [[EventFeedDetailViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                case PostRefTypeEvent: {
                    EventFeedViewController *vc = [[EventFeedViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
            }
        }
    }
}

- (void)clickCell:(NotifyMessageDTO *)dto index:(NSIndexPath *)index
{
    switch (dto.refType) {
        case PostRefTypeUnknown: {
            
            break;
        }
        case PostRefTypeDiscuss: {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.articleAndDiscussionID = dto.refID;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PostRefTypePosition: {
            HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
            vc.employmentID = dto.refID;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case PostRefTypeHomeEvent:
        case PostRefTypeArticle: {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.articleAndDiscussionID = dto.refID;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PostRefTypeFriendFeed: {
            EventFeedDetailViewController *vc = [[EventFeedDetailViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PostRefTypeEvent: {
            EventFeedViewController *vc = [[EventFeedViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - getter & setter
- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.contentMode = UIViewContentModeCenter;
        _emptyView.image = [UIImage imageNamed:@"no_notify_message_bg"];
    }
    return _emptyView;
}

@end
