//
//  MessageNotificationController.m
//  medtree
//
//  Created by 孙晨辉 on 15/9/16.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "MessageNotificationController.h"
// view
#import "MessageNotificationHistoryController.h"
#import "NotifyMessageCell.h"
#import "SectionSpaceTableViewCell.h"
#import "NewPersonDetailController.h"
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeChannelArticleDetailViewController.h"
#import "EventFeedDetailViewController.h"
#import "EventFeedViewController.h"
#import "HomeJobChannelUnitJobViewController.h"
// dto
#import "UserDTO.h"
#import "EmptyDTO.h"
#import "PostDTO.h"
#import "NotifyMessageDTO.h"
// manager
#import "MessageManager.h"
#import <InfoAlertView.h>

@interface MessageNotificationController ()

@property (nonatomic, strong) NSMutableArray    *dataList;
@property (nonatomic, strong) UIButton          *historyButton;
@property (nonatomic, strong) UIImageView       *emptyView;

@end

@implementation MessageNotificationController

#pragma mark - UI
- (void)createUI
{
    [super createUI];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{@"NotifyMessageDTO":[NotifyMessageCell class],
                           @"EmptyDTO":[SectionSpaceTableViewCell class]}];
    [naviBar setTopTitle:@"通知"];
    [self createBackButton];
    
    [self.view addSubview:self.historyButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    
    [self getLastestData];
}

- (void)viewDidLayoutSubviews
{

}

- (void)setupView
{
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
    }];
    
    [self.historyButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor lightGrayColor];
    [self.historyButton addSubview:topLineView];
    
    [topLineView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 43.5, 0));
    }];
}

#pragma mark - data
- (void)getLastestData
{
    [self showProgress];
    __unsafe_unretained typeof(self) weakSelf = self;
    [MessageManager getData:@{@"method":@(MethodType_Message_Notify_New)} success:^(NSArray *data) {
        [weakSelf hideProgress];
        if (data.count > 0) {
            for (NSDictionary *dict in data) {
                NotifyMessageDTO *dto = [[NotifyMessageDTO alloc] init:dict];
                EmptyDTO *empty = [[EmptyDTO alloc] init];
                [self.dataList addObject:@[dto, empty]];
            }
            [table setData:weakSelf.dataList];
        } else {
            weakSelf->table.enableHeader = NO;
            weakSelf->table.enableFooter = NO;
            [weakSelf.view addSubview:weakSelf.emptyView];
            [weakSelf.emptyView makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(UIEdgeInsetsMake(64, 0, 44, 0));
            }];
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

#pragma mark - click
- (void)clickHistoryNotifyMessage
{
    MessageNotificationHistoryController *vc = [[MessageNotificationHistoryController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - click
- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if (action.integerValue == kClickHeadAction) {
        if ([dto isKindOfClass:[UserDTO class]]) {
            if (![(UserDTO *)dto isAnonymous]) {
                NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
                vc.userDTO = dto;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
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
                case PostRefTypePosition: {
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
        case PostRefTypeHomeEvent:
        case PostRefTypeArticle: {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.articleAndDiscussionID = dto.refID;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case PostRefTypePosition:{
            HomeJobChannelUnitJobViewController *vc = [[HomeJobChannelUnitJobViewController alloc] init];
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

- (UIButton *)historyButton
{
    if (!_historyButton) {
        _historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_historyButton setBackgroundColor:[UIColor whiteColor]];
        [_historyButton setTitle:@"查看历史通知" forState:UIControlStateNormal];
        [_historyButton setTitleColor:[ColorUtil getColor:@"505050" alpha:1.0] forState:UIControlStateNormal];
        [_historyButton addTarget:self action:@selector(clickHistoryNotifyMessage) forControlEvents:UIControlEventTouchUpInside];
        _historyButton.titleLabel.font = [MedGlobal getMiddleFont];
    }
    return _historyButton;
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
