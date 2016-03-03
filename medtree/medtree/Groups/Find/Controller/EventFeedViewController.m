//
//  EventFeedViewController.m
//  medtree
//
//  Created by tangshimi on 8/5/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedViewController.h"
#import "newEventFeedHeaderView.h"
#import "EventDTO.h"
#import "EventFeedSearchViewController.h"
#import "NavigationController.h"
#import "EventChildActivityController.h"
#import "LoadingView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "ActivityRecommendView.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "PairDTO.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"
#import "Pair2DTO.h"
#import "NewFeedCommentCell.h"
#import "FeedLineCell.h"
#import "FeedLikesCell.h"
#import "EventFeedTableViewCell.h"
#import "EventFeedCommentAndLikePopView.h"
#import "EventFeedCommentInputView.h"
#import "OperationHelper.h"
#import "JSONKit.h"
#import "WriteFeedViewController.h"
#import "UrlParsingHelper.h"
#import "CommonWebController.h"
#import "NewPersonDetailController.h"

typedef NS_ENUM(NSInteger, EventFeedViewControllerInputBoxViewType) {
    EventFeedViewControllerInputBoxViewCommentType,
    EventFeedViewControllerInputBoxViewReplyCommentType
};

@interface EventFeedViewController () <NewEventFeedHeaderViewDelegate, BaseTableViewDelegate, EventFeedCommentAndLikePopViewDelegate,
    EventFeedCommentInputViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) newEventFeedHeaderView *headerView;
@property (nonatomic, assign) BOOL tableViewFullView;
@property (nonatomic, strong) ActivityRecommendView *activityRecommendView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EventFeedCommentAndLikePopView *commentAndLikePopView;
@property (nonatomic, strong) EventFeedCommentInputView *inputBoxView;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexpath;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *writeFeedButton;

@end

@implementation EventFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.eventDTO) {
        [self showRecommendView];
        [self triggerPullToRefresh];
    } else {
        [self geteVentDTOByEventID];
    }
    
    [ClickUtil event:@"discover_active_view" attributes:@{ @"event_id" : self.eventDTO.sysid ? : self.eventID }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [table removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)createUI
{
    [super createUI];
    
    statusBar.alpha = 0;
    naviBar.alpha = 0;
    
    self.dataArray = [NSMutableArray new];
    self.startIndex = 0;
    self.pageSize = 10;
    
    [table setTableHeaderView:self.headerView];
    self.headerView.eventDTO = self.eventDTO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [table setRegisterCells:@{ @"MedFeedDTO" : [EventFeedTableViewCell class],
                               @"MedFeedCommentDTO" : [NewFeedCommentCell class],
                               @"Pair2DTO" : [FeedLineCell class],
                               @"PairDTO" : [FeedLikesCell class]}];
    self.tableViewFullView = YES;
    
    [table addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view bringSubviewToFront:naviBar];
    [self.view bringSubviewToFront:statusBar];

    [self.view addSubview:self.backButton];
    [self.view addSubview:self.writeFeedButton];
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsZero);
    }];
    
    [self.backButton makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@20);
    }];
    
    [self.writeFeedButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-25);
        make.bottom.equalTo(@-30);
    }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    self.currentSelectedIndexpath = index;
    
    switch ([action integerValue]) {
        case EventFeedTableViewCellActionTypeHeadView: {
            MedFeedDTO *feedDTO = dto;
            NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
            vc.userId = feedDTO.creatorID;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case EventFeedTableViewCellActionTypeCommentView: {
            CGRect frame = [table rectForRowAtIndexPath:index];
            CGPoint point = CGPointMake(CGRectGetMaxX(frame) - 100, CGRectGetMaxY(frame) - 12);
            CGPoint newPoint = [table convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
            
            self.commentAndLikePopView.like = ((MedFeedDTO *)dto).favoured;
            [self.commentAndLikePopView showAtPoint:newPoint inView:[UIApplication sharedApplication].keyWindow];
            
            break;
        }
        case EventFeedTableViewCellActionTypeReport: {
            [self showReportActionSheet];

            break;
        }
        case EventFeedTableViewCellActionTypeDelete: {
            [self deleteFeedRequest];
            
            break;
        }
        case FeedCommentCellActionTypeTap: {
            if ([dto isKindOfClass:[MedFeedCommentDTO class]]) {
                self.currentSelectedIndexpath = index;
                MedFeedCommentDTO *feedCommentDto = dto;
                
                self.inputBoxView.placeholder = [NSString stringWithFormat:@"回复：%@", feedCommentDto.creatorName];
                [self.inputBoxView showInView:[UIApplication sharedApplication].keyWindow];
            }
            
            break;
        }
        case FeedCommentCellActionTypeReply: {
            if ([dto isKindOfClass:[MedFeedCommentDTO class]]) {
                MedFeedCommentDTO *commentDto = dto;
                NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.userId = commentDto.creatorID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        }
        case FeedCommentCellActionTypeReplyTo: {
            if ([dto isKindOfClass:[MedFeedCommentDTO class]]) {
                MedFeedCommentDTO *commentDto = dto;
                NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                vc.userId = commentDto.replyUserID;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            break;
        }
        case FeedCommentCellActionTypeDelete: {
            [self deleteFeedCommentRequest];
            
            break;
        }
        case FeedCommentCellActionTypeReport: {
            [self showReportActionSheet];
            
            break;
        }
        default:
            break;
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[MedFeedCommentDTO class]]) {
        self.currentSelectedIndexpath = index;
        MedFeedCommentDTO *feedCommentDto = dto;
        
        self.inputBoxView.placeholder = [NSString stringWithFormat:@"回复：%@", feedCommentDto.creatorName];
        [self.inputBoxView showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)clickCell:(id)dto action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_OpenURL) {
        if (dto != nil) {
            [UrlParsingHelper operationUrl:dto controller:self title:@"详情"];
        }
    } else if ([action integerValue] == ClickAction_FeedReplyToUser) {
        NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
        detail.userId = ((MedFeedCommentDTO *)dto).replyFeedID;
        detail.parent = self;
        [self.navigationController pushViewController:detail animated:YES];
    } else if ([action integerValue] == ClickAction_FeedReplyUser) {
        NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
        detail.parent = self;
        detail.userId = ((MedFeedCommentDTO *)dto).replyUserID;
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self commentListRequest];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self commentListRequest];
}

#pragma mark -
#pragma mark - NewEventFeedHeaderViewDelegate -

- (void)eventFeedHeaderViewClickSearchBar
{
    if (self.eventDTO == nil) {
        return;
    }
    EventFeedSearchViewController *searchVC = [[EventFeedSearchViewController alloc] init];
    searchVC.searchTitle = self.eventDTO.tag;
    
    NavigationController *navi = [[NavigationController alloc] initWithRootViewController:searchVC];
    navi.navigationBarHidden = YES;
    
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)eventFeedHeaderViewJionSubActivity
{
    EventChildActivityController *vc = [[EventChildActivityController alloc] init];
    vc.eventDTO = self.eventDTO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)eventFeedHeaderViewSeeAbouActivityDetail
{
    CommonWebController *web = [[CommonWebController alloc] init];
    web.urlPath = self.eventDTO.url;
    web.naviTitle = self.eventDTO.title;
    web.isShowShare = YES;
    web.shareImageID = @"";
    web.shareTitle = self.eventDTO.title;
    web.shareDescription = self.eventDTO.summary;
    
    [self.navigationController pushViewController:web animated:YES];
}

#pragma mark -
#pragma mark - EventFeedCommentAndLikePopViewDelegate -

- (void)eventFeedCommentAndLikePopView:(EventFeedCommentAndLikePopView *)popView
                       didSelectedType:(EventFeedCommentAndLikePopViewSelectedType)type
{
    if (type == EventFeedCommentAndLikePopViewCommentSelectedType) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.currentSelectedIndexpath.section]
                     atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        self.inputBoxView.placeholder = @"评论";
        [self.inputBoxView showInView:[UIApplication sharedApplication].keyWindow];
    } else if (type == EventFeedCommentAndLikePopViewLikeSelectedType) {
        [self postLikeRequest];
    }
}

#pragma mark -
#pragma mark - EventFeedCommentInputViewDelegate -

- (void)eventFeedCommentInputView:(EventFeedCommentInputView *)inputView didClickSend:(NSString *)text
{
    EventFeedViewControllerInputBoxViewType type;
    
    if (self.currentSelectedIndexpath.row == 0) {
        type = EventFeedViewControllerInputBoxViewCommentType;
    } else {
        type = EventFeedViewControllerInputBoxViewReplyCommentType;
    }
    
    [self commentRequestWithText:text type:type];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 5) {
        return;
    }
    [self reportRequestWithType:buttonIndex + 1];
}

#pragma mark -
#pragma mark - 评论 -

- (void)commentRequestWithText:(NSString *)text type:(EventFeedViewControllerInputBoxViewType)type
{
    NSDictionary *param = nil;
    if (type == EventFeedViewControllerInputBoxViewCommentType) {
        MedFeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        param = @{ @"content" : text, @"feed_id" : feedDto.feedID, @"method" :@(MethodType_FeedComment_Send) };
    } else if (type == EventFeedViewControllerInputBoxViewReplyCommentType) {
        MedFeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        param = @{ @"content": text,
                   @"feed_id": feedCommentDto.replyFeedID,
                   @"reply_to_user_id": feedCommentDto.replyUserID,
                   @"method": @(MethodType_FeedComment_Send) };
    }
 
    [ServiceManager setData:param success:^(id JSON) {
        if (JSON[@"success"]) {
            MedFeedCommentDTO *commentDTO = [[MedFeedCommentDTO alloc] init:JSON[@"result"]];;
            commentDTO.creatorName = [AccountHelper getAccount].name;
            commentDTO.creatorID = [AccountHelper getAccount].userID;
            
            if (type == EventFeedViewControllerInputBoxViewReplyCommentType) {
                MedFeedCommentDTO *replyCommentDTO = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
                commentDTO.replyUserName = replyCommentDTO.creatorName;
                commentDTO.replyUserID = replyCommentDTO.creatorID;
            }
            
            NSMutableArray *sectionArray = [NSMutableArray new];
            sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
            
            if ([sectionArray[1] isKindOfClass:[Pair2DTO class]]) {
                commentDTO.showSharpCorner = YES;
            }
            
            [sectionArray insertObject:commentDTO atIndex:sectionArray.count - 1];
            
            self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
            
            [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

#pragma mark -
#pragma mark - network -

- (void)commentListRequest
{
    NSDictionary *params =  @{@"method": @(MethodTypeEventFeedList),
                              @"eventid": self.eventDTO.sysid,
                              @"from": @(self.startIndex),
                              @"size": @(self.pageSize) };
    
    [EventManager getData:params success:^(id JSON) {
        [self handleCommentListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
    }];
}

- (void)handleCommentListRequest:(NSDictionary *)dic
{
    [self stopLoading];
    
    if ([dic[@"status"] boolValue]) {
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
        }
        
        NSArray *commentArray = dic[@"commentArray"];
        
        for (MedFeedDTO *feedDTO in commentArray) {
            __block NSMutableArray *sectionArray = [NSMutableArray new];
            Pair2DTO *dto = [[Pair2DTO alloc] init];
            [sectionArray addObject:feedDTO];
            
            BOOL showFavourContent = NO;
            
            if (feedDTO.favourContent && ![feedDTO.favourContent isEqualToString:@""]) {
                showFavourContent = YES;
            }
            
            if (showFavourContent) {
                PairDTO *pairDTO = [[PairDTO alloc] init];
                pairDTO.key = feedDTO.favourContent;
                pairDTO.isHideFootLine = (!(feedDTO.commentArray.count > 0));
                [sectionArray addObject:pairDTO];
            }
            
            [feedDTO.commentArray enumerateObjectsUsingBlock:^(MedFeedCommentDTO *dto, NSUInteger idx, BOOL * stop) {
                dto.showSharpCorner = (idx == 0 && !showFavourContent );
                
                [sectionArray addObject:dto];
            }];
            
            [sectionArray addObject:dto];
            [self.dataArray addObject: sectionArray];
        }
        [table setData:self.dataArray];
        
        self.startIndex += commentArray.count;
        self.enableFooter = (commentArray.count == self.pageSize);
    }
}

#pragma mark -
#pragma mark - 喜欢 -

- (void)postLikeRequest
{
    MedFeedDTO *feedDto = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
    NSInteger type = MethodType_Feed_Like_Send;
    if (feedDto.favoured) {
        type = MethodType_Feed_Unlike_Send;
    }
    
    NSDictionary *dict = @{ @"feed_id" : feedDto.feedID, @"method" : @(type) };

    [ServiceManager setData:dict success:^(id JSON) {
        [self handlePostLikeReques:JSON];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)handlePostLikeReques:(NSDictionary *)resultDic
{
    if (![[resultDic objectForKey:@"success"] boolValue]) {
        [InfoAlertView showInfo:[resultDic objectForKey:@"message"] inView:self.view duration:1];
    } else {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
        feedDTO.favoured = [resultDic[@"result"][@"is_liked"] boolValue];
        feedDTO.favourNumber = [resultDic[@"result"][@"like_count"] integerValue];
        feedDTO.favourContent =  resultDic[@"result"][@"likes_summary"];
        
        NSMutableArray *sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
        
        if (feedDTO.favoured) {
            if ([sectionArray[1] isKindOfClass:[PairDTO class]]) {
                PairDTO *pairDTO = sectionArray[1];
                pairDTO.key = feedDTO.favourContent;
            } else {
                PairDTO *pairDTO = [[PairDTO alloc] init];
                pairDTO.key = feedDTO.favourContent;
                pairDTO.isHideFootLine = !(feedDTO.commentArray.count > 0);
                [sectionArray insertObject:pairDTO atIndex:1];
                
                if ([sectionArray[2] isKindOfClass:[MedFeedCommentDTO class]]) {
                    MedFeedCommentDTO *commentDTO = sectionArray[2];
                    commentDTO.showSharpCorner = NO;
                }
            }
        } else {
            BOOL showFavourContent = NO;
            
            if(feedDTO.favourContent && ![feedDTO.favourContent isEqualToString:@""]) {
                showFavourContent = YES;
            }
    
            if ([sectionArray[1] isKindOfClass:[PairDTO class]]) {
                if (showFavourContent) {
                    PairDTO *pairDTO = sectionArray[1];
                    pairDTO.key = feedDTO.favourContent;
                } else {
                    [sectionArray removeObjectAtIndex:1];
                    
                    if ([sectionArray[1] isKindOfClass:[MedFeedCommentDTO class]]) {
                        MedFeedCommentDTO *commentDTO = sectionArray[1];
                        commentDTO.showSharpCorner = YES;
                    }
                }
            }
        }
        
        self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
        
        [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section]
             withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark -
#pragma makr - report -

- (void)reportRequestWithType:(NSInteger)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.currentSelectedIndexpath.row == 0) {
        //举报帖子
        MedFeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:feedDto.feedID forKey:@"item_id"];
    } else {
        //举报评论
        MedFeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        [dict setObject:@(11) forKey:@"report_type"];
        [dict setObject:feedCommentDto.commentID forKey:@"item_id"];
    }
    [dict setObject:@(type) forKey:@"reason"];
    [dict setObject:@(MethodType_Feed_Report) forKey:@"method"];
    [ServiceManager setData:dict success:^(id JSON) {
        [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

#pragma mark - 
#pragma mark - deleteFeed -

- (void)deleteFeedRequest
{
    MedFeedDTO *feedDto = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
    
    NSDictionary *dict = @{ @"feed_id" : feedDto.feedID, @"method" : @(MethodType_Feed_Delete) };
    [ServiceManager setData:dict success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            [self.dataArray removeObjectAtIndex:self.currentSelectedIndexpath.section];
            
            [table setData:self.dataArray];
        } else {
            [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark - deleteFeedComment -

- (void)deleteFeedCommentRequest
{
    MedFeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
    
    NSDictionary *dict = @{ @"comment_id" : feedCommentDto.commentID, @"method" : @(MethodType_FeedComment_Delete) };
    [ServiceManager setData:dict success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSMutableArray *sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
            [sectionArray removeObjectAtIndex:self.currentSelectedIndexpath.row];
            
            self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
            
            [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section]
                 withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark - response event -

- (void)backButtonAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeFeedButtonAction:(UIButton *)button
{
    if (self.eventDTO == nil) {
        return;
    }
    
    WriteFeedViewController *vc = [[WriteFeedViewController alloc] init];
    vc.navigationTitle = self.eventDTO.tag;
    vc.publishFeedSuccessBlock = ^ {
        self.startIndex = 0;
        [self commentListRequest];
    };
    NavigationController *nc = [[NavigationController alloc] initWithRootViewController:vc];
    nc.navigationBarHidden = YES;
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if (self.currentSelectedIndexpath.row == 0) {
        return;
    }
    
    NSDictionary *infoDic = notification.userInfo;
    CGFloat height = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat space = GetScreenHeight - height - 44;
    CGPoint tableViewContentOffset = table.contentOffset;
    CGRect rect = [table rectForRowAtIndexPath:self.currentSelectedIndexpath];
    
    CGFloat offsetY = (rect.origin.y - tableViewContentOffset.y) - space + CGRectGetHeight(rect);
    
    CGFloat finalOffsetY;
    
    if (tableViewContentOffset.y + offsetY < 0) {
        finalOffsetY = 0;
    } else {
        finalOffsetY = tableViewContentOffset.y + offsetY;
    }
    
    [table setContentOffset:CGPointMake(0, tableViewContentOffset.y + offsetY) animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.eventDTO == nil) {
        return;
    }
    if (self.eventDTO.event_type == EventConferenceType) {
        statusBar.alpha = 1;
        naviBar.alpha = 1;
    } else {
        if (table.contentOffset.y < 0) {
            statusBar.alpha = 0;
            naviBar.alpha = 0;
        } else if (table.contentOffset.y >=0 && table.contentOffset.y <= 64) {
            CGFloat alpha = 1 / 64.0 * table.contentOffset.y;
            
            statusBar.alpha = alpha;
            naviBar.alpha = alpha;
        } else {
            statusBar.alpha = 1;
            naviBar.alpha = 1;
        }
    }
}

#pragma mark -
#pragma mark - public -

- (void)geteVentDTOByEventID
{
    NSDictionary *params = @{ @"eventid" : self.eventID, @"method" : @(MethodTypeEventFeedByID) };
    [EventManager getData:params success:^(id JSON) {
        [self showRecommendView];
        self.eventDTO = JSON;
        self.headerView.eventDTO = self.eventDTO;
       
        [self triggerPullToRefresh];
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"未获取到数据" inView:self.view duration:2];
    }];
}

#pragma mark -
#pragma mark - private -

- (void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

- (void)showRecommendView
{
    NSString *key = [NSString stringWithFormat:@"%@%@", [[AccountHelper getAccount] userID], self.eventDTO.sysid];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (![userDefault objectForKey:key]) {
        [self.view addSubview:self.activityRecommendView];
        self.activityRecommendView.frame = self.view.bounds;
        [self.activityRecommendView setActivityRecommendURL:self.eventDTO.url];
        
        [userDefault setObject:@"notFirstBrowse" forKey:key];
        [userDefault synchronize];
    }
    
    [self.headerView setEventDTO:self.eventDTO];
    
    [naviBar setTopTitle:self.eventDTO.title];
}

#pragma mark -
#pragma mark - setter and getter -

- (newEventFeedHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = ({
            newEventFeedHeaderView *headerView = [[newEventFeedHeaderView alloc] initWithFrame:CGRectMake(0, 0, GetViewWidth(self.view), 250)];
            headerView.delegate =self;
            headerView;
        });
    }
    return _headerView;
}

- (ActivityRecommendView *)activityRecommendView
{
    if (!_activityRecommendView) {
        ActivityRecommendView *activityRecommendView = [[ActivityRecommendView alloc] initWithFrame:CGRectZero];
        activityRecommendView.parentVC = self;
        _activityRecommendView = activityRecommendView;
    }
    return _activityRecommendView;
}

- (EventFeedCommentAndLikePopView *)commentAndLikePopView
{
    if (!_commentAndLikePopView) {
        _commentAndLikePopView = ({
            EventFeedCommentAndLikePopView *view = [[EventFeedCommentAndLikePopView alloc] init];
            view.delegate = self;
            view;
        });
    }
    return _commentAndLikePopView;
}

- (EventFeedCommentInputView *)inputBoxView
{
    if (!_inputBoxView) {
        _inputBoxView = ({
            EventFeedCommentInputView *inputView = [[EventFeedCommentInputView alloc] initWithFrame:CGRectZero];
            inputView.delegate = self;
            inputView;
        });
    }
    return _inputBoxView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:GetImage(@"btn_back.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
    }
    return _backButton;
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
