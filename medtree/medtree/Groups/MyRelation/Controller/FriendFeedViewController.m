//
//  FriendFeedViewController.m
//  medtree
//
//  Created by tangshimi on 8/10/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "FriendFeedViewController.h"
#import "EventFeedCommentAndLikePopView.h"
#import "EventFeedCommentInputView.h"
#import "EventFeedTableViewCell.h"
#import "NewFeedCommentCell.h"
#import "FeedLineCell.h"
#import "FeedLikesCell.h"
#import "FeedDTO.h"
#import "PairDTO.h"
#import "FeedCommentDTO.h"
#import "Pair2DTO.h"
#import "LoadingView.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "OperationHelper.h"
#import "JSONKit.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import "NavigationController.h"
#import "NewPersonDetailController.h"
#import "WriteFeedViewController.h"
#import "UserDTO.h"
#import "UrlParsingHelper.h"

typedef NS_ENUM(NSInteger, EventFeedViewControllerInputBoxViewType) {
    EventFeedViewControllerInputBoxViewCommentType,
    EventFeedViewControllerInputBoxViewReplyCommentType
};

@interface FriendFeedViewController () <BaseTableViewDelegate, EventFeedCommentAndLikePopViewDelegate, EventFeedCommentInputViewDelegate,
    UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EventFeedCommentAndLikePopView *commentAndLikePopView;
@property (nonatomic, strong) EventFeedCommentInputView *inputBoxView;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexpath;

@end

@implementation FriendFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_feedType == FriendFeedViewControllerDataType_Friend) {
        [naviBar setTopTitle:@"好友动态"];
    } else if (_feedType == FriendFeedViewControllerDataType_Person) {
        [naviBar setTopTitle:[NSString stringWithFormat:@"%@的动态", _userDTO.name]];
        if (![_userDTO.userID isEqualToString:[AccountHelper getAccount].userID]) {
        } else {
            [naviBar setTopTitle:@"我的动态"];
        }
        UIButton *button = naviBar.rightButton;
        button.hidden = YES;
    }
    [self requestData];
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
    
    self.dataArray = [NSMutableArray new];
    self.startIndex = 0;
    self.pageSize = 10;
    
    dataLoading.hidden = NO;
    [dataLoading showNoData:NO];

    [self createBackButton];
    [naviBar setRightButton:[NavigationBar createImageButton:@"event_feed_edit.png"
                                               selectedImage:nil
                                                      target:self
                                                      action:@selector(writeFeedButtonAction:)]];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
  //  table.frame = self.view.bounds;
    [table registerCells:@{@"FeedDTO" : [EventFeedTableViewCell class],
                           @"FeedCommentDTO" : [NewFeedCommentCell class],
                           @"Pair2DTO" : [FeedLineCell class],
                           @"PairDTO" : [FeedLikesCell class]}];
}

- (void)parseData:(id)JSON
{
    NSArray *array = [JSON objectForKey:@"data"];
    if (_feedType == FriendFeedViewControllerDataType_Friend) { //好友动态
        if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList) {
//            [FeedManager deleteAllFeedCache];
            table.enableFooter = array.count == self.pageSize;
            [self.dataArray removeAllObjects];
        } else if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList_More) {
            self.startIndex += array.count;
            table.enableFooter = array.count == self.pageSize;
        } else if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList_Local) {
        }
    } else if (_feedType == FriendFeedViewControllerDataType_Person) {  //某人动态
        if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList_Person) {
//             [FeedManager deleteAllFeedCache];
            table.enableFooter = array.count == self.pageSize;
            [self.dataArray removeAllObjects];
        } else if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList_Person_More) {
            self.startIndex += array.count;
            table.enableFooter = array.count == self.pageSize;
        } else if ([[JSON objectForKey:@"method"] integerValue] == MethodType_FeedList_Person_Local) {
        }
    }
    
    if ([table getData].count > 0 || array.count > 0) {
        dataLoading.hidden = YES;
    } else {
        dataLoading.hidden = NO;
        [dataLoading showNoData:YES];
    }
    [self parseCommentData:array];
}

- (void)parseCommentData:(NSArray *)array
{
    if (array.count <= 0) {
        return;
    }
    
    for (int i = 0; i < array.count; i++) {
        NSMutableArray *sectionDataArray = [NSMutableArray new];
        [sectionDataArray addObject:array[i]];
        
        FeedDTO *feedDto = array[i];
        if (feedDto.likes_str.length > 0) {
            PairDTO *likeDTO = [[PairDTO alloc] init:nil];
            likeDTO.key = feedDto.likes_str;
            likeDTO.isShowFootLine = feedDto.comments.count > 0;
            [sectionDataArray addObject:likeDTO];
        }
        
        if (feedDto.comments.count > 0) {
            [feedDto.comments enumerateObjectsUsingBlock:^(NSDictionary *dic, NSUInteger idx, BOOL *stop) {
                FeedCommentDTO *feedCommentDto = [[FeedCommentDTO alloc] init:dic];
                
                if (feedDto.likes_str.length == 0 && idx == 0) {
                    feedCommentDto.cellType = 10;
                }
                
                [sectionDataArray addObject:feedCommentDto];
            }];
        }
        
        Pair2DTO *pair2DTO = [[Pair2DTO alloc] init:@{}];
        [sectionDataArray addObject:pair2DTO];
        
        [self.dataArray addObject:sectionDataArray];
    }
    [table setData:self.dataArray];
}

- (void)parseDataError:(id)JSON
{
    if ([table getData].count > 0) {
        dataLoading.hidden = YES;
    } else {
        dataLoading.hidden = NO;
        [dataLoading showNoData:NO];
    }
}

- (NSDictionary *)getParam_FromLocal
{
    NSDictionary *param;
    if (_feedType == FriendFeedViewControllerDataType_Friend) {
        param = @{@"method" : @(MethodType_FeedList_Local)};
    } else if (_feedType == FriendFeedViewControllerDataType_Person) {
        param = @{@"method" : @(MethodType_FeedList_Person_Local)};
    }
    return param;
}

- (NSDictionary *)getParam_FromNet
{
    self.startIndex = 0;
    NSDictionary *param;
    if (_feedType == FriendFeedViewControllerDataType_Friend) {
        param = @{@"method" : @(MethodType_FeedList), @"from" : @(self.startIndex), @"size" : @(self.pageSize)};
    } else if (_feedType == FriendFeedViewControllerDataType_Person) {
        param = @{@"method" : @(MethodType_FeedList_Person), @"userId":_userDTO.userID, @"from" : @(self.startIndex), @"size" : @(self.pageSize)};
    }
    return param;
}

- (NSDictionary *)getParam_FromNet_More
{
    NSDictionary *param;
    if (_feedType == FriendFeedViewControllerDataType_Friend) {
        param = @{@"method" : @(MethodType_FeedList_More), @"from" : @(self.startIndex), @"size" : @(self.pageSize)};
    } else if (_feedType == FriendFeedViewControllerDataType_Person) {
        param = @{@"method" : @(MethodType_FeedList_Person_More), @"userId":_userDTO.userID, @"from" : @(self.startIndex), @"size" : @(self.pageSize)};
    }
    return param;
}

#pragma mark -
#pragma mark - 评论 -

- (void)commentRequestWithText:(NSString *)text type:(EventFeedViewControllerInputBoxViewType)type
{
    NSDictionary *param = nil;
    if (type == EventFeedViewControllerInputBoxViewCommentType) {
        FeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        param = @{ @"content" : text, @"feed_id" : feedDto.feed_id, @"method": @(MethodType_FeedComment_Send) };
    } else if (type == EventFeedViewControllerInputBoxViewReplyCommentType) {
        FeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        param = @{ @"content": text,
                   @"feed_id": feedCommentDto.feed.feed_id,
                   @"reply_to_user_id": feedCommentDto.user_id,
                   @"method": @(MethodType_FeedComment_Send) };
    }
    
    [ServiceManager setData:param success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        
        FeedCommentDTO *feedCommentDto = [[FeedCommentDTO alloc] init:[JSON objectForKey:@"result"]];
        if (type == EventFeedViewControllerInputBoxViewCommentType) {
            feedCommentDto.reply_to_user_name = @"";
        } else {
            FeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
            feedCommentDto.reply_to_user_name = feedCommentDto.user_name;
        }
        
        NSMutableArray *sectionDataArray = self.dataArray[self.currentSelectedIndexpath.section];
        
        if (sectionDataArray.count == 3 && [sectionDataArray[1] isKindOfClass:[PairDTO class]]) {
            PairDTO *pairDTO = sectionDataArray[1];
            pairDTO.isShowFootLine = YES;
            [sectionDataArray replaceObjectAtIndex:1 withObject:pairDTO];
        }
        
        [sectionDataArray insertObject:feedCommentDto atIndex:sectionDataArray.count - 1];
        
        [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
    }];
}

#pragma mark -
#pragma mark - 喜欢 -

- (void)postLikeRequest
{
    FeedDTO *feedDto = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
    NSInteger type = MethodType_Feed_Like_Send;
    if (feedDto.is_liked) {
        type = MethodType_Feed_Unlike_Send;
    }
    
    NSDictionary *dict = @{ @"feed_id" : feedDto.feed_id, @"method" : @(type) };
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager setData:dict success:^(id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        if ([[JSON objectForKey:@"success"] boolValue]) {
            NSDictionary *result = [JSON objectForKey:@"result"];
            NSString *likes_summary = nil;
            if ([result objectForKey:@"likes_summary"]) {
                likes_summary = [result objectForKey:@"likes_summary"];
            }
            
            NSInteger count = [[result objectForKey:@"like_count"] integerValue];
            BOOL islike = !feedDto.is_liked;
            
            PairDTO *likesDTO = [[PairDTO alloc] init:@{}];
            likesDTO.key = likes_summary;
            
            /**
             *
             *  1.动下方没有数据
             *  2.动下方仅有评论
             *  3.动下方仅有赞
             *      3.1 下方有很多赞
             *      3.2 下方有一个赞
             *  4.动下方都有
             *      4.1 下方有很多赞
             *      4.2 下方有一个赞
             */
            
            NSMutableArray *sectionDataArray = self.dataArray[self.currentSelectedIndexpath.section];
            feedDto.likes_str = likes_summary;
            if (feedDto.like_count > 0) {// 原始有赞
                feedDto.is_liked = islike;
                feedDto.like_count = count;
                if (count > 0) {// 现在有赞
                    [sectionDataArray replaceObjectAtIndex:1 withObject:likesDTO];
                } else {// 现在没有赞
                    [sectionDataArray removeObjectAtIndex:1];
                }
            } else {// 原始无赞
                feedDto.is_liked = islike;
                feedDto.like_count = count;
                
                likesDTO.isShowFootLine = sectionDataArray.count > 2;
                
                [sectionDataArray insertObject:likesDTO atIndex:1];
            }
            
            [sectionDataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[FeedCommentDTO class]]) {
                    FeedCommentDTO *comment = (FeedCommentDTO *)obj;
                    if (likes_summary.length == 0) {
                        comment.cellType = 10;
                    }
                    else {
                        comment.cellType = 0; //普通情况
                    }
                    *stop = YES;
                    [sectionDataArray replaceObjectAtIndex:idx withObject:comment];
                }
            }];
            
            [table reloadSections:[NSIndexSet indexSetWithIndex:self.currentSelectedIndexpath.section] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:2];
        }
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
    }];
}

#pragma mark -
#pragma makr - report -

- (void)reportRequestWithType:(NSInteger)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.currentSelectedIndexpath.row == 0) {
        //举报帖子
        FeedDTO *feedDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:feedDto.feed_id forKey:@"item_id"];
    } else {
        //举报评论
        FeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
        [dict setObject:@(11) forKey:@"report_type"];
        [dict setObject:feedCommentDto.comment_id forKey:@"item_id"];
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
    FeedDTO *feedDto = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
    
    NSDictionary *dict = @{ @"feed_id": feedDto.feed_id, @"method": @(MethodType_Feed_Delete) };
    [ServiceManager setData:dict success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[JSON objectForKey:@"success"] boolValue]) {
                [self.dataArray removeObjectAtIndex:self.currentSelectedIndexpath.section];
                
                [table setData:self.dataArray];
            } else {
                [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
            }
        });
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark - deleteFeedComment -

- (void)deleteFeedCommentRequest
{
    FeedCommentDTO *feedCommentDto = self.dataArray[self.currentSelectedIndexpath.section][self.currentSelectedIndexpath.row];
    
    NSDictionary *dict = @{ @"comment_id": feedCommentDto.comment_id, @"method": @(MethodType_FeedComment_Delete) };
    [LoadingView showProgress:YES inView:self.view];
    [ServiceManager setData:dict success:^(id JSON) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView showProgress:NO inView:self.view];
            if ([[JSON objectForKey:@"success"] boolValue]) {
                NSMutableArray *sectionDataArray = self.dataArray[self.currentSelectedIndexpath.section];
                
                FeedDTO *tempDto = [self.dataArray[self.currentSelectedIndexpath.section] firstObject];
                tempDto.comment_count -- ;
                [sectionDataArray removeObjectAtIndex:self.currentSelectedIndexpath.row];
                
                if (sectionDataArray.count == 3) {
                    if ([sectionDataArray[1] isKindOfClass:[PairDTO class]]) {
                        PairDTO *likesDTO = sectionDataArray[1];
                        likesDTO.isShowFootLine = NO;
                    }
                }
                [table setData:self.dataArray];
            } else {
                [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
            }
        });
    } failure:^(NSError *error, id JSON) {
        [LoadingView showProgress:NO inView:self.view];
        [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark - response event -

- (void)writeFeedButtonAction:(UIButton *)button
{
    WriteFeedViewController *vc = [[WriteFeedViewController alloc] init];
    vc.publishFeedSuccessBlock = ^ {
        self.startIndex = 0;
        [self requestData];
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
    
    [table setContentOffset:CGPointMake(0, finalOffsetY) animated:YES];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    self.currentSelectedIndexpath = index;
    
    switch ([action integerValue]) {
        case EventFeedTableViewCellActionTypeHeadView: {
            NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
            detail.userDTO = dto;
            detail.parent = self;
            [self.navigationController pushViewController:detail animated:YES];
            break;
        }
        case EventFeedTableViewCellActionTypeCommentView: {
            CGRect frame = [table rectForRowAtIndexPath:index];
            CGPoint point = CGPointMake(CGRectGetMaxX(frame) - 100, CGRectGetMaxY(frame) - 8);
            CGPoint newPoint = [table convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
            
            self.commentAndLikePopView.like = ((FeedDTO *)dto).is_liked;
            [self.commentAndLikePopView showAtPoint:newPoint inView:[UIApplication sharedApplication].keyWindow];
            
            break;
        }
        case ClickAction_FeedReport: {
            [self showReportActionSheet];
            break;
        }
        case ClickAction_FeedDelete: {
            [self deleteFeedRequest];
            break;
        }
        case ClickAction_FeedCommentDelete: {
            [self showDeleteAlertView];
            break;
        }
        default:
            break;
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[FeedCommentDTO class]]) {
        self.currentSelectedIndexpath = index;
        FeedCommentDTO *feedCommentDto = dto;
        
        self.inputBoxView.placeholder = [NSString stringWithFormat:@"回复：%@", feedCommentDto.user_name];
        [self.inputBoxView showInView:[UIApplication sharedApplication].keyWindow];
    } else if ([dto isKindOfClass:[FeedDTO class]]) {
        if (((FeedDTO *)dto).reference.allKeys.count > 0) {
        }
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
        detail.userId = ((FeedCommentDTO *)dto).reply_to_user_id;
        detail.parent = self;
        [self.navigationController pushViewController:detail animated:YES];
    } else if ([action integerValue] == ClickAction_FeedReplyUser) {
        NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
        detail.parent = self;
        detail.userId = ((FeedCommentDTO *)dto).user_id;
        [self.navigationController pushViewController:detail animated:YES];
    }
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
#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.currentSelectedIndexpath.row == 0) {
            [self deleteFeedRequest];
        } else {
            [self deleteFeedCommentRequest];
        }
    }
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

- (void)showDeleteAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"是否确认删除"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma mark -
#pragma mark - setter and getter -

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

@end
