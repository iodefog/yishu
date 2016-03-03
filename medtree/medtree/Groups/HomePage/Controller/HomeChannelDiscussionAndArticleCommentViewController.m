//
//  HomeChannelHelpDetailViewController.m
//  medtree
//
//  Created by tangshimi on 8/21/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "HomeChannelDetailTableViewCell.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "UIColor+Colors.h"
#import "EmptyDTO.h"
#import "SectionSpaceTableViewCell.h"
#import "SectionTitleDTO.h"
#import "SectionTitleTableViewCell.h"
#import "HomeChannelDetailBottomOperateView.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "PopupListView.h"
#import "MessagePopupListViewTableViewCell.h"
#import "NewPersonDetailController.h"
#import "ChannelManager.h"
#import "EventFeedCommentInputView.h"
#import <InfoAlertView.h>
#import "HomeChannelWriteViewController.h"
#import "EventFeedTableViewCell.h"
#import "NewFeedCommentCell.h"
#import "FeedLineCell.h"
#import "FeedLikesCell.h"
#import "WXApi.h"
#import <JSONKit.h>
#import "ServiceManager.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"
#import "Pair2DTO.h"
#import "PairDTO.h"
#import "EventFeedCommentAndLikePopView.h"
#import "HomeChannelInviteFriendsViewController.h"
#import "BrowseImagesController.h"

typedef NS_ENUM(NSInteger, FavourType) {
    FavourTypeDiscussion = 1,
    FavourTypeDiscussionComment = 10,
    FavourTypeEmploymentComment
};

typedef NS_ENUM(NSInteger, InputBoxViewType) {
    InputBoxViewTypeCommentFeed,
    InputBoxViewTypeReplyComment
};

typedef NS_ENUM(NSInteger, ReportType) {
    ReportTypeDiscussion,
    ReportTypeFeed,
    ReportTypeComment,
};

typedef NS_ENUM(NSInteger, DeleteType) {
    DeleteTypeFeed,
    DeleteTypeComment
};

@interface HomeChannelDiscussionAndArticleCommentViewController () <HomeChannelDetailBottomOperateViewDelegate, BaseTableViewDelegate,
    PopupListViewDelegate, EventFeedCommentInputViewDelegate, UIActionSheetDelegate, EventFeedCommentAndLikePopViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *headArray;
@property (nonatomic, strong) HomeChannelDetailBottomOperateView *bottomOperationView;
@property (nonatomic, strong) UIButton *speakButton;
@property (nonatomic, strong) PopupListView *popView;
@property (nonatomic, strong) EventFeedCommentAndLikePopView *commentAndLikePopView;
@property (nonatomic, strong) EventFeedCommentInputView *inputBoxView;
@property (nonatomic, assign) InputBoxViewType currentInputBoxViewType;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexpath;
@property (nonatomic, assign) ReportType currentReportType;
@property (nonatomic, assign) DeleteType currentDeleteType;
@property (nonatomic, strong) UIImageView *articleEmptyView;
@property (nonatomic, strong) UIView *discussionEmptyView;

@end

@implementation HomeChannelDiscussionAndArticleCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.startIndex = 0;
    self.pageSize = 10;
    
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 45, 0));
    }];

    [self showLoadingView];
    
    self.articleAndDiscussionDTO.cellHeight = 0;
    
    if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
        if(self.articleAndDiscussionID && ![self.articleAndDiscussionID isEqualToString:@""]) {
            [self articleAndDiscussionByIDRequest];
        } else {
            [self dealWithArticleAndDiscussionDTO];
        }
    } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        [naviBar setTopTitle:@"评论"];
        
        [self.view addSubview:self.speakButton];
        
        [self.speakButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(45);
        }];
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [self.speakButton addSubview:topLineView];
        
        [topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 44.5, 0));
        }];
    
        [self triggerPullToRefresh];
    }
    
    if (self.articleAndDiscussionDTO && self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
        [ClickUtil event:@"homepage_open_article" attributes:@{ @"discuss_id" : self.articleAndDiscussionDTO.id }];
    }    
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

- (void)createUI
{
    [super createUI];
    
    [self createBackButton];
    
    if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
        [naviBar setRightButton:[NavigationBar createImageButton:@"home_detail_discussion_more.png"
                                                          target:self
                                                          action:@selector(moreButtonAction:)]];
    } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle ||
               self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent ||
               self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        [self.view addSubview:self.articleEmptyView];
        
        [self.articleEmptyView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.centerY.equalTo(-50);
        }];
        self.articleEmptyView.hidden = YES;
    }
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table setRegisterCells:@{ @"HomeArticleAndDiscussionDTO" : [HomeChannelDetailTableViewCell class],
                               @"EmptyDTO" : [SectionSpaceTableViewCell class],
                               @"SectionTitleDTO" : [SectionTitleTableViewCell class],
                               @"MedFeedDTO" : [EventFeedTableViewCell class],
                               @"MedFeedCommentDTO" : [NewFeedCommentCell class],
                               @"Pair2DTO" : [FeedLineCell class],
                               @"PairDTO" : [FeedLikesCell class] }];
}

- (void)loadData
{
    EmptyDTO *dto1 = [[EmptyDTO alloc] init];    
    [self.dataArray addObject:@[ self.articleAndDiscussionDTO, dto1 ]];

    SectionTitleDTO *titleDto = [[SectionTitleDTO alloc] init];
    titleDto.verticalViewColor = [UIColor orangeColor];
    titleDto.title = @"全部发言";
    
    [self.dataArray addObject:@[ titleDto ]];
    
    self.headArray = @[ @[ self.articleAndDiscussionDTO, dto1 ], @[ titleDto ] ];
    
    [table setData:self.dataArray];
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
            vc.hidesBottomBarWhenPushed = YES;
            vc.userId = feedDTO.creatorID;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case EventFeedTableViewCellActionTypeCommentView: {
            MedFeedDTO *feedDTO = dto;
            CGRect frame = [table rectForRowAtIndexPath:index];
            CGPoint point = CGPointMake(CGRectGetMaxX(frame) - 100, CGRectGetMaxY(frame) - 12);
            CGPoint newPoint = [table convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
            
            self.commentAndLikePopView.like = feedDTO.favoured;
            [self.commentAndLikePopView showAtPoint:newPoint inView:[UIApplication sharedApplication].keyWindow];
            
            break;
        }
        case EventFeedTableViewCellActionTypeReport: {
            self.currentReportType = ReportTypeFeed;
            [self showReportActionSheet];

            break;
        }
        case EventFeedTableViewCellActionTypeDelete: {
            [self deleteRequestWithType:DeleteTypeFeed];
           
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
            [self deleteRequestWithType:DeleteTypeComment];
            
            break;
        }
        case FeedCommentCellActionTypeReport: {
            self.currentReportType = ReportTypeComment;
            [self showReportActionSheet];
            
            break;
        }
        case HomeChannelDetailTableViewCellActionTypeHeadImage: {
            HomeArticleAndDiscussionDTO *discussionDto = dto;
            NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.userDTO = discussionDto.userDTO;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case HomeChannelDetailTableViewCellActionTypeDelete: {
            [self deleteDiscussionRequest];
            break;
        }
        default:
            break;
    }
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
        [self commentListRequest];
    } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        [self employmentCommentListRequest];
    }
}

- (void)loadFooter:(BaseTableView *)table
{
    if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
        [self commentListRequest];
    } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        [self employmentCommentListRequest];
    }
}

#pragma mark -
#pragma mark - HomeChannelDetailBottomOperateViewDelegate -

- (void)homeChannelDetailBottomOperateViewDidSelectWithType:(HomeChannelDetailBottomOperateViewOperationType)type
{
    switch (type) {
        case HomeChannelDetailBottomOperateViewOperationTypeRespond: {
            HomeChannelWriteViewController *vc = [[HomeChannelWriteViewController alloc] init];
            vc.type = HomeChannelWriteViewControllerTypeComment;
            vc.articleAndDiscussionDTO = self.articleAndDiscussionDTO;
            vc.updateBlock = ^ {
                self.startIndex = 0;
                [self commentListRequest];
            };
            
            NavigationController *nvc = [[NavigationController alloc] initWithRootViewController:vc];
            nvc.navigationBarHidden = YES;
            [self presentViewController:nvc animated:YES completion:nil];
            break;
        }
        case HomeChannelDetailBottomOperateViewOperationTypeFavour:
            if (self.bottomOperationView.favour) {
                [self cancleFavourRequest:FavourTypeDiscussion];
            } else {
                [self favourRequest:FavourTypeDiscussion];
            }
            break;
        case HomeChannelDetailBottomOperateViewOperationTypeInvite: {
            HomeChannelInviteFriendsViewController *vc = [[HomeChannelInviteFriendsViewController alloc] init];
            vc.discussionDTO = self.articleAndDiscussionDTO;
            [self presentViewController:vc animated:YES completion:nil];
            
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark - PopupListViewDelegate -

- (CGSize)contentSizeOfPopupListView:(PopupListView *)listView
{
    return CGSizeMake(120, 50);
}

- (NSInteger)numberOfItemsOfPopupListView:(PopupListView *)listView
{
    return 1;
}

- (CGFloat)popupListView:(PopupListView *)listView cellHeightAtIndex:(NSInteger)index
{
    return 50;
}

- (NSDictionary *)popuplistView:(PopupListView *)listView infoDictionaryAtIndex:(NSInteger)index
{
    NSArray *infoArray = @[ @{ @"image" : @"home_report.png", @"title" : @"举报" } ];
    
    return infoArray[index];
}

- (Class)cellClassOfPopuoListView:(PopupListView *)listView
{
    return [MessagePopupListViewTableViewCell class];
}

- (void)popupListView:(PopupListView *)listView didSelectedAtIndex:(NSInteger)index
{
    self.currentReportType = ReportTypeDiscussion;
    [self showReportActionSheet];
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
        if (popView.like) {
            if(self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
                [self cancleFavourRequest:FavourTypeDiscussionComment];
            } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
                [self cancleFavourRequest:FavourTypeEmploymentComment];
            }
        }  else {
            if(self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
                [self favourRequest:FavourTypeDiscussionComment];
            } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
                [self favourRequest:FavourTypeEmploymentComment];
            }
        }
    }
}

#pragma mark -
#pragma mark - EventFeedCommentInputViewDelegate -

- (void)eventFeedCommentInputView:(EventFeedCommentInputView *)inputView didClickSend:(NSString *)text
{
    InputBoxViewType type;
    
    if (self.currentSelectedIndexpath.row == 0) {
        type = InputBoxViewTypeCommentFeed;
    } else {
        type = InputBoxViewTypeReplyComment;
    }
    
    [self commentRequestWithText:text type:type];
}

#pragma mark -
#pragma mark - response event -

- (void)moreButtonAction:(UIButton *)button
{
    [self.popView showAtPoint:CGPointMake(GetScreenWidth - 75, 64) inView:self.view];
}

- (void)speakButtonAction:(UIButton *)button
{
    HomeChannelWriteViewController *vc = [[HomeChannelWriteViewController alloc] init];
    vc.articleAndDiscussionDTO = self.articleAndDiscussionDTO;
    if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
        vc.type = HomeChannelWriteViewControllerTypeComment;
        vc.updateBlock = ^{
            self.startIndex = 0;
            [self commentListRequest];
            
            if (self.addSpeakBlock) {
                self.addSpeakBlock();
            }
        };
    } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        vc.employmentID = self.employmentID;
        vc.type = HomeChannelWriteViewControllerTypeEmploymentComment;
        vc.updateBlock = ^{
            self.startIndex = 0;
            [self employmentCommentListRequest];
        };
    }
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    if (self.currentSelectedIndexpath.row == 0) {
        return;
    }
    
    NSDictionary *infoDic = notification.userInfo;
    CGFloat height = [infoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    CGFloat space = GetScreenHeight - height - 64 - 45;
    CGPoint tableViewContentOffset = table.contentOffset;
    CGRect rect = [table rectForRowAtIndexPath:self.currentSelectedIndexpath];
    
    CGFloat offsetY = (rect.origin.y - tableViewContentOffset.y) - space + CGRectGetHeight(rect);
    
    CGFloat finalOffsetY;
    
    if (tableViewContentOffset.y + offsetY < 0) {
        finalOffsetY = 0;
    } else {
        finalOffsetY = tableViewContentOffset.y + offsetY;
    }
    
    [table setContentOffset:CGPointMake(0, finalOffsetY) animated:YES];
}

#pragma mark -
#pragma mark - network -

- (void)commentListRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelComment),
                              @"id" : self.articleAndDiscussionDTO.id,
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleCommentListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        [self stopLoading];
        
        if ((self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle ||
             self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent) && self.startIndex == 0) {
            self.articleEmptyView.hidden = NO;
        } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion && self.startIndex == 0) {
            self.tableView.tableFooterView = self.discussionEmptyView;
        }
        
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)employmentCommentListRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeJobChannelEmploymentComment),
                              @"employmentID" : self.employmentID };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleCommentListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self hideLoadingView];
        [self stopLoading];
        
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)handleCommentListRequest:(NSDictionary *)dic
{
    if (self.startIndex == 0) {
        [self hideLoadingView];
    }
    
    [self stopLoading];
    
    
    NSArray *commentArray = dic[@"commentArray"];
    
    if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle ||
        self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent ||
        self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        if (self.startIndex == 0) {
            self.articleEmptyView.hidden = (commentArray.count > 0);
        }
    } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
        if (self.startIndex == 0) {
            self.tableView.tableFooterView = commentArray.count == 0 ? self.discussionEmptyView : nil;
        }
    }
    
    if ([dic[@"status"] boolValue]) {
        if (self.startIndex == 0) {
            [self.dataArray removeAllObjects];
            
            [self.dataArray addObjectsFromArray:self.headArray];
        }
        
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

        if (self.startIndex == 0 && commentArray.count == 0) {
            self.showNoMorelogo = NO;
        } else {
            self.enableFooter = (commentArray.count == self.pageSize);
        }
        self.startIndex += commentArray.count;
    } else {
        self.enableFooter = NO;
        
        [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
    }
}

- (void)articleAndDiscussionByIDRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeChannelCommentByID), @"id" : self.articleAndDiscussionID };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        self.articleAndDiscussionDTO = JSON;
        [self dealWithArticleAndDiscussionDTO];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)favourRequest:(FavourType)type
{
    NSDictionary *params =  nil;
    if (type == FavourTypeDiscussion) {
        params = @{ @"method" : @(MethodTypeChannelFavour),
                    @"id" : self.articleAndDiscussionDTO.id,
                    @"type" : @(type) };
    } else if (type == FavourTypeDiscussionComment) {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
        
        NSInteger favorur = 10;
        if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
            favorur = 10;
        } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle) {
            favorur = 20;
        } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent) {
            favorur = 50;
        }
        params = @{ @"method" : @(MethodTypeChannelFavour),
                    @"id" : feedDTO.feedID,
                    @"type" : @(favorur) };
    } else if (type == FavourTypeEmploymentComment) {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
        
        params = @{ @"method" : @(MethodTypeJobChannelEmploymenFeedFavour),
                    @"id" : feedDTO.feedID };
    }
  
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if (![[JSON objectForKey:@"success"] boolValue]) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            if (type == FavourTypeDiscussion) {
                NSInteger favourCount = [JSON[@"result"][@"like_count"] integerValue];
                self.bottomOperationView.favourNumber = favourCount;
                self.bottomOperationView.favour = !self.bottomOperationView.favour;
                
                self.articleAndDiscussionDTO.favour = YES;
                self.articleAndDiscussionDTO.favourCount = favourCount;
                
                if (self.updateBlock) {
                    self.updateBlock(self.articleAndDiscussionDTO);
                }
            } else if (type == FavourTypeDiscussionComment || type == FavourTypeEmploymentComment) {
                MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
                feedDTO.favoured = YES;
                feedDTO.favourNumber = [JSON[@"result"][@"like_count"] integerValue];
                if (type == FavourTypeDiscussionComment) {
                    feedDTO.favourContent =  JSON[@"result"][@"like_summary"];
                } else {
                    feedDTO.favourContent =  JSON[@"result"][@"likes_summary"];
                }
                
                NSMutableArray *sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
                
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
                
                self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
                
                [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section]
                     withRowAnimation:UITableViewRowAnimationNone];
            }
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

- (void)cancleFavourRequest:(FavourType)type
{
    NSDictionary *params =  nil;
    if (type == FavourTypeDiscussion) {
        params = @{ @"method" : @(MethodTypeChannelUnFavour),
                    @"id" : self.articleAndDiscussionDTO.id,
                    @"type" : @(type) };
    } else if (type == FavourTypeDiscussionComment) {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];

        NSInteger favorur = 10;
        if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
            favorur = 10;
        } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle) {
            favorur = 20;
        } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent) {
            favorur = 50;
        }
        
        params = @{ @"method" : @(MethodTypeChannelUnFavour),
                    @"id" : feedDTO.feedID,
                    @"type" : @(favorur) };
    } else if (type == FavourTypeEmploymentComment) {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
        
        params = @{ @"method" : @(MethodTypeJobChannelEmploymenFeedUnFavour),
                    @"id" : feedDTO.feedID };
    }
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if (![[JSON objectForKey:@"success"] boolValue]) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            if (type == FavourTypeDiscussion) {
                NSInteger favourCount = [JSON[@"result"][@"like_count"] integerValue];
                self.bottomOperationView.favourNumber = favourCount;
                self.bottomOperationView.favour = !self.bottomOperationView.favour;
                
                self.articleAndDiscussionDTO.favour = NO;
                self.articleAndDiscussionDTO.favourCount = favourCount;
                
                if (self.updateBlock) {
                    self.updateBlock(self.articleAndDiscussionDTO);
                }                
            } else if (type == FavourTypeDiscussionComment || type == FavourTypeEmploymentComment) {
                MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
                feedDTO.favoured = NO;
                feedDTO.favourNumber = [JSON[@"result"][@"like_count"] integerValue];
                if (type == FavourTypeDiscussionComment) {
                    feedDTO.favourContent =  JSON[@"result"][@"like_summary"];
                } else {
                    feedDTO.favourContent =  JSON[@"result"][@"likes_summary"];
                }
                
                BOOL showFavourContent = NO;
                
                if(feedDTO.favourContent && ![feedDTO.favourContent isEqualToString:@""]) {
                    showFavourContent = YES;
                }
                
                NSMutableArray *sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
                
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
                
                self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
                
                [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section]
                     withRowAnimation:UITableViewRowAnimationNone];
            }
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

- (void)commentRequestWithText:(NSString *)text type:(InputBoxViewType)type
{
    NSMutableDictionary *param = nil;
    if (type == InputBoxViewTypeCommentFeed) {
        MedFeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];

        if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
            param = @{ @"content" : text,
                       @"reply_to_feed_id" : feedDto.feedID}.mutableCopy;
        } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
            param = @{ @"content" : text,
                       @"feed_id" : feedDto.feedID }.mutableCopy;
        }
    } else if (type == InputBoxViewTypeReplyComment) {
        MedFeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
            param = @{ @"content": text,
                       @"reply_to_feed_id": feedCommentDto.replyFeedID,
                       @"reply_to_user_id": feedCommentDto.creatorID }.mutableCopy;
        } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
            MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
            
            param = @{ @"content" : text,
                       @"feed_id" : feedDTO.feedID,
                       @"reply_to_comment_id" :  feedCommentDto.replyFeedID,
                       @"reply_to_user_id" :  feedCommentDto.creatorID }.mutableCopy;
        }
    }
    
    if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
        param[@"method"] =  @(MethodTypeChannelCommentFeed);
    } else if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
        param[@"method"] = @(MethodTypeJobChannelEmploymentCommentFeed);
    }
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        [self handleCommentRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)handleCommentRequest:(NSDictionary *)dic
{
    if (dic[@"success"]) {
        MedFeedCommentDTO *commentDTO = dic[@"comment"];
        
        NSMutableArray *sectionArray = [NSMutableArray new];
        sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
        
        if ([sectionArray[1] isKindOfClass:[Pair2DTO class]]) {
            commentDTO.showSharpCorner = YES;
        }
        
        [sectionArray insertObject:commentDTO atIndex:sectionArray.count - 1];
        
        self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
        
        [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
    }
}

- (void)reportRequestWithType:(ReportType)reportType reasonType:(NSInteger)reasonType
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (reportType == ReportTypeDiscussion) {
        //举报帖子
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:self.articleAndDiscussionDTO.id forKey:@"item_id"];
    } else if (reportType == ReportTypeFeed) {
        MedFeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][0];
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:feedDto.feedID forKey:@"item_id"];
    } else {
        //举报评论
        MedFeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        [dict setObject:@(11) forKey:@"report_type"];
        [dict setObject:feedCommentDto.commentID forKey:@"item_id"];
    }
    [dict setObject:@(reasonType) forKey:@"reason"];
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

- (void)deleteRequestWithType:(DeleteType)type
{
    NSDictionary *params = nil;
    if (type == DeleteTypeFeed) {
        MedFeedDTO *feedDTO = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
        
        if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
            params = @{ @"method" : @(MethodTypeJobChannelDeleteFeed),
                        @"feed_id" : feedDTO.feedID };
        } else {
            params = @{ @"method" : @(MethodTypeChannelDeleteCommentFeed),
                        @"feed_id" : feedDTO.feedID };
        }
    } else if (type == DeleteTypeComment) {
        MedFeedCommentDTO *commentDTO = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        
        if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
            params = @{ @"method" : @(MethodTypeJobChannelDeleteComment),
                        @"comment_id" : commentDTO.commentID };
        } else {
            params = @{ @"method" : @(MethodTypeChannelDeleteCommentFeed),
                        @"feed_id" : commentDTO.commentID };
        }
    }
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            if (type == DeleteTypeFeed) {
                [self.dataArray removeObjectAtIndex:self.currentSelectedIndexpath.section];
                [table setData:self.dataArray];
                
                if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle ||
                    self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent ||
                    self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment) {
                    self.articleEmptyView.hidden = (self.dataArray.count > 0);
                } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
                    self.tableView.tableFooterView = self.dataArray.count < 3 ? self.discussionEmptyView : nil;
                }
                
                if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
                    if (self.deleteBlock) {
                        self.deleteBlock();
                    }
                }
            } else if (type == DeleteTypeComment) {
                NSMutableArray *sectionArray = self.dataArray[self.currentSelectedIndexpath.section];
                [sectionArray removeObjectAtIndex:self.currentSelectedIndexpath.row];
                
                self.dataArray[self.currentSelectedIndexpath.section] = sectionArray;
                
                [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section]
                     withRowAnimation:UITableViewRowAnimationNone];
            }
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

- (void)deleteDiscussionRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeChannelDeleteDiscussion), @"content_id" : self.articleAndDiscussionDTO.id };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        if ([JSON[@"success"] boolValue]) {
            if(self.deleteBlock) {
                self.deleteBlock();
            }
            [InfoAlertView showInfo:@"删除成功！" inView:self.view duration:1];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
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
#pragma mark - helper -

- (void)dealWithArticleAndDiscussionDTO
{
    if(self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeDiscussion) {
        [naviBar setTopTitle:@"讨论详情"];
        
        [self loadData];
        [self.view addSubview:self.bottomOperationView];
        self.bottomOperationView.favourNumber = self.articleAndDiscussionDTO.favourCount;
        self.bottomOperationView.favour = self.articleAndDiscussionDTO.favour;
    } else if (self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeArticle ||
               self.articleAndDiscussionDTO.type == HomeArticleAndDiscussionTypeEvent) {
        [naviBar setTopTitle:@"发言"];
        
        [self.view addSubview:self.speakButton];
        
        [self.speakButton makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.right.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(45);
        }];
        
        UIView *topLineView = [[UIView alloc] init];
        topLineView.backgroundColor = [UIColor lightGrayColor];
        [self.speakButton addSubview:topLineView];
        
        [topLineView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 44.5, 0));
        }];
    }
    
    [self triggerPullToRefresh];
}

- (void)showReportActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
    sheet.tag = 100;
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

#pragma mark -
#pragma mark - setter and getter -

- (HomeChannelDetailBottomOperateView *)bottomOperationView
{
    if (!_bottomOperationView) {
        _bottomOperationView = ({
            HomeChannelDetailBottomOperateView *view = [[HomeChannelDetailBottomOperateView alloc] initWithFrame:CGRectMake(0, GetScreenHeight - 45.0, GetScreenWidth, 45.0) type:HomeChannelDetailBottomOperateViewTypeDiscussion];
            view.delegate = self;
            view;
        });
    }
    return _bottomOperationView;
}

- (UIButton *)speakButton
{
    if (!_speakButton) {
        _speakButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            if(self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
                [button setTitle:@"发言" forState:UIControlStateNormal];
            } else {
                [button setTitle:@"评论" forState:UIControlStateNormal];
            }
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setImage:GetImage(@"home_response.png") forState:UIControlStateNormal];
            [button addTarget:self action:@selector(speakButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            button;
        });
    }
    return _speakButton;
}

- (PopupListView *)popView
{
    if (!_popView) {
        _popView = ({
            PopupListView *view = [[PopupListView alloc] initWithArrowType:PopupListViewArrowTypeRight];
            view.delegate = self;
            view;
        });
    }
    return _popView;
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

- (UIImageView *)articleEmptyView
{
    if (!_articleEmptyView) {
        _articleEmptyView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            if (self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeDiscussionAndArticle) {
                imageView.image = GetImage(@"home_channel_comment_empty.png");
            } else if(self.type == HomeChannelDiscussionAndArticleCommentViewControllerTypeEmployment ) {
                imageView.image = GetImage(@"home_channel_comment_empty1.png");
            };
            imageView;
        });
    }
    return _articleEmptyView;
}

- (UIView *)discussionEmptyView
{
    if (!_discussionEmptyView) {
        _discussionEmptyView =  ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 155)];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"home_channel_comment_empty.png");
            [view addSubview:imageView];
            [imageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(0);
                make.bottom.equalTo(-5);
            }];
            
            view;
        });
    }
    return _discussionEmptyView;
}

@end

