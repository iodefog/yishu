//
//  EventFeedDetailViewController.m
//  medtree
//
//  Created by tangshimi on 8/13/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "EventFeedDetailViewController.h"
#import "EventFeedTableViewCell.h"
#import "MedFeedDTO.h"
#import "MedFeedCommentDTO.h"
#import "NewFeedCommentCell.h"
#import "Pair2DTO.h"
#import "FeedLineCell.h"
#import "PairDTO.h"
#import "FeedLikesCell.h"
#import "EventFeedCommentAndLikePopView.h"
#import "EventFeedCommentInputView.h"
#import "LoadingView.h"
#import "ServiceManager.h"
#import "InfoAlertView.h"
#import <JSONKit.h>
#import "NewPersonDetailController.h"
#import "OperationHelper.h"
#import "AccountHelper.h"
#import "UserDTO.h"

typedef NS_ENUM(NSInteger, EventFeedViewControllerInputBoxViewType) {
    EventFeedViewControllerInputBoxViewCommentType,
    EventFeedViewControllerInputBoxViewReplyCommentType
};

@interface EventFeedDetailViewController () <EventFeedCommentAndLikePopViewDelegate, EventFeedCommentInputViewDelegate,
    UIActionSheetDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) EventFeedCommentAndLikePopView *commentAndLikePopView;
@property (nonatomic, strong) EventFeedCommentInputView *inputBoxView;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexpath;

@end

@implementation EventFeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [[NSMutableArray alloc] init];
    
    [self parseCommentData];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"详情"];
    [naviBar setTopLabelColor:[UIColor whiteColor]];
    
    [self createBackButton];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.enableHeader = NO;
    [table registerCells:@{@"MedFeedDTO" : [EventFeedTableViewCell class],
                           @"MedFeedCommentDTO" : [NewFeedCommentCell class],
                           @"Pair2DTO" : [FeedLineCell class],
                           @"PairDTO" : [FeedLikesCell class]}];
}

- (void)parseCommentData
{
    if (!self.feedDTO) {
        return;
    }
    
    self.feedDTO.searchFeed = NO;
    [self.dataArray addObject:self.feedDTO];
    
    BOOL showFavourContent = NO;
    
    if (self.feedDTO.favourContent && ![self.feedDTO.favourContent isEqualToString:@""]) {
        showFavourContent = YES;
    }
    
    if (showFavourContent) {
        PairDTO *pairDTO = [[PairDTO alloc] init];
        pairDTO.key = self.feedDTO.favourContent;
        pairDTO.isHideFootLine = (!(self.feedDTO.commentArray.count > 0));
        [self.dataArray addObject:pairDTO];
    }
    
    [self.feedDTO.commentArray enumerateObjectsUsingBlock:^(MedFeedCommentDTO *dto, NSUInteger idx, BOOL * stop) {
        dto.showSharpCorner = (idx == 0 && !showFavourContent );
        
        [self.dataArray addObject:dto];
    }];
    
    Pair2DTO *pair2DTO = [[Pair2DTO alloc] init];
    [self.dataArray addObject:pair2DTO];
    
    [table setData:@[ self.dataArray ]];
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
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    self.currentSelectedIndexpath = index;
    
    switch ([action integerValue]) {
        case EventFeedTableViewCellActionTypeHeadView: {
            MedFeedDTO *feedDTO = dto;
            
            NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
            detail.userId = feedDTO.creatorID;
            [self.navigationController pushViewController:detail animated:YES];
            break;
        }
        case EventFeedTableViewCellActionTypeCommentView: {
            CGRect frame = [table rectForRowAtIndexPath:index];
            CGPoint point = CGPointMake(CGRectGetMaxX(frame) - 100, CGRectGetMaxY(frame) - 8);
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
        case FeedCommentCellActionTypeDelete: {
            [self deleteFeedCommentRequest];
            break;
        }
        case FeedCommentCellActionTypeReply: {
            MedFeedCommentDTO *feedCommentDTO = dto;
            
            NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
            vc.userId = feedCommentDTO.creatorID;
            [self.navigationController pushViewController:vc animated:YES];

            break;
        }
        case FeedCommentCellActionTypeReplyTo: {
            MedFeedCommentDTO *feedCommentDTO = dto;
            
            NewPersonDetailController *vc = [[NewPersonDetailController alloc] init];
            vc.userId = feedCommentDTO.replyUserID;
            [self.navigationController pushViewController:vc animated:YES];
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
        case FeedCommentCellActionTypeReport: {
            [self showReportActionSheet];

            break;
        }
    }
}

#pragma mark -
#pragma mark - EventFeedCommentAndLikePopViewDelegate -

- (void)eventFeedCommentAndLikePopView:(EventFeedCommentAndLikePopView *)popView
                       didSelectedType:(EventFeedCommentAndLikePopViewSelectedType)type
{
    if (type == EventFeedCommentAndLikePopViewCommentSelectedType) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection: 0]
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
#pragma mark - 评论 -

- (void)commentRequestWithText:(NSString *)text type:(EventFeedViewControllerInputBoxViewType)type
{
    NSDictionary *param = nil;
    if (type == EventFeedViewControllerInputBoxViewCommentType) {
        param = @{ @"content" : text, @"feed_id" : self.feedDTO.feedID, @"method" : @(MethodType_FeedComment_Send) };
    } else if (type == EventFeedViewControllerInputBoxViewReplyCommentType) {
        MedFeedCommentDTO *feedCommentDTO = self.dataArray[self.currentSelectedIndexpath.row];
        param = @{ @"content": text,
                   @"feed_id": feedCommentDTO.replyFeedID,
                   @"reply_to_user_id": feedCommentDTO.replyUserID,
                   @"method": @(MethodType_FeedComment_Send) };
    }
    
    [ServiceManager setData:param success:^(id JSON) {        
        if (JSON[@"success"]) {
            MedFeedCommentDTO *commentDTO = [[MedFeedCommentDTO alloc] init:JSON[@"result"]];;
            
            commentDTO.creatorName = [AccountHelper getAccount].name;
            commentDTO.creatorID = [AccountHelper getAccount].userID;
            
            if (type == EventFeedViewControllerInputBoxViewReplyCommentType) {
                MedFeedCommentDTO *replyCommentDTO = self.dataArray[self.currentSelectedIndexpath.row];
                commentDTO.replyUserName = replyCommentDTO.creatorName;
                commentDTO.replyUserID = replyCommentDTO.creatorID;
            }

            if ([self.dataArray[1] isKindOfClass:[Pair2DTO class]]) {
                commentDTO.showSharpCorner = YES;
            }
            [self.dataArray insertObject:commentDTO atIndex:self.dataArray.count - 1];
            
            [table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1];
        }
        
        if (self.updateBlock) {
            self.updateBlock();
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
#pragma mark - 喜欢 -

- (void)postLikeRequest
{
    NSInteger type = MethodType_Feed_Like_Send;
    if (self.feedDTO.favoured) {
        type = MethodType_Feed_Unlike_Send;
    }
    
    NSDictionary *dict = @{ @"feed_id" : self.feedDTO.feedID, @"method" : @(type) };
    [ServiceManager setData:dict success:^(id JSON) {
        [self handlePostLikeReques:JSON];
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:[dic objectForKey:@"message"] inView:self.view duration:1];
    }];
}

- (void)handlePostLikeReques:(NSDictionary *)resultDic
{
    if (![[resultDic objectForKey:@"success"] boolValue]) {
        [InfoAlertView showInfo:[resultDic objectForKey:@"message"] inView:self.view duration:1];
    } else {
        MedFeedDTO *feedDTO = [self.dataArray firstObject];
        feedDTO.favoured = [resultDic[@"result"][@"is_liked"] boolValue];
        feedDTO.favourNumber = [resultDic[@"result"][@"like_count"] integerValue];
        feedDTO.favourContent =  resultDic[@"result"][@"likes_summary"];
        
        if (feedDTO.favoured) {
            if ([self.dataArray[1] isKindOfClass:[PairDTO class]]) {
                PairDTO *pairDTO = self.dataArray[1];
                pairDTO.key = feedDTO.favourContent;
            } else {
                PairDTO *pairDTO = [[PairDTO alloc] init];
                pairDTO.key = feedDTO.favourContent;
                pairDTO.isHideFootLine = !(feedDTO.commentArray.count > 0);
                [self.dataArray insertObject:pairDTO atIndex:1];
                
                if ([self.dataArray[2] isKindOfClass:[MedFeedCommentDTO class]]) {
                    MedFeedCommentDTO *commentDTO = self.dataArray[2];
                    commentDTO.showSharpCorner = NO;
                }
            }
        } else {
            BOOL showFavourContent = NO;
            
            if(feedDTO.favourContent && ![feedDTO.favourContent isEqualToString:@""]) {
                showFavourContent = YES;
            }
            
            if ([self.dataArray[1] isKindOfClass:[PairDTO class]]) {
                if (showFavourContent) {
                    PairDTO *pairDTO = self.dataArray[1];
                    pairDTO.key = feedDTO.favourContent;
                } else {
                    [self.dataArray removeObjectAtIndex:1];
                    
                    if ([self.dataArray[1] isKindOfClass:[MedFeedCommentDTO class]]) {
                        MedFeedCommentDTO *commentDTO = self.dataArray[1];
                        commentDTO.showSharpCorner = YES;
                    }
                }
            }
        }
        
        [table reloadSections:[NSIndexSet indexSetWithIndex:0]
             withRowAnimation:UITableViewRowAnimationNone];
        
        if (self.updateBlock) {
            self.updateBlock();
        }
    }
}

#pragma mark -
#pragma makr - report -

- (void)reportRequestWithType:(NSInteger)type
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.currentSelectedIndexpath.row == 0) {
        //举报帖子
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:self.feedDTO.feedID forKey:@"item_id"];
    } else {
        //举报评论
        MedFeedCommentDTO *feedCommentDTO = self.dataArray[self.currentSelectedIndexpath.row];
        [dict setObject:@(11) forKey:@"report_type"];
        [dict setObject:feedCommentDTO.commentID forKey:@"item_id"];
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
    NSDictionary *dict = @{ @"feed_id": self.feedDTO.feedID, @"method": @(MethodType_Feed_Delete) };
    [ServiceManager setData:dict success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            [self.dataArray removeAllObjects];
            
            [table setData:self.dataArray];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            if (self.updateBlock) {
                self.updateBlock();
            }
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
    MedFeedCommentDTO *feedCommentDTO = self.dataArray[self.currentSelectedIndexpath.row];
    
    NSDictionary *dict = @{ @"comment_id" : feedCommentDTO.commentID, @"method" : @(MethodType_FeedComment_Delete) };
    [ServiceManager setData:dict success:^(id JSON) {
        if ([[JSON objectForKey:@"success"] boolValue]) {
            [self.dataArray removeObjectAtIndex:self.currentSelectedIndexpath.row];
            
            if (self.dataArray.count == 3) {
                if ([self.dataArray[1] isKindOfClass:[PairDTO class]]) {
                    PairDTO *likesDTO = self.dataArray[1];
                    likesDTO.isShowFootLine = NO;
                }
            }
            [table reloadData];
            
            if (self.updateBlock) {
                self.updateBlock();
            }
        } else {
            [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
        }
    } failure:^(NSError *error, id JSON) {
        [InfoAlertView showInfo:@"删除失败，请重试" inView:self.view duration:1];
    }];
}

#pragma mark -
#pragma mark -  response event -

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
