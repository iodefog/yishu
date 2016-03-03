//
//  HomeChannelArticleDetailViewController.m
//  medtree
//
//  Created by tangshimi on 8/31/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "HomeChannelArticleDetailViewController.h"
#import "HomeChannelDetailBottomOperateView.h"
#import "HomeArticleAndDiscussionDTO.h"
#import "PopupListView.h"
#import "MessagePopupListViewTableViewCell.h"
#import "ChannelManager.h"
#import "HomeArticleAndDiscussionDTO.h"
#import <InfoAlertView.h>
#import "HomeChannelDiscussionAndArticleCommentViewController.h"
#import "CommonWebView.h"
#import <JSONKit.h>
#import "ServiceManager.h"
#import "MedShareManager.h"

typedef NS_ENUM(NSInteger, ReportType) {
    ReportTypeDiscussion = 10,
    ReportTypeComment = 11,
};

@interface HomeChannelArticleDetailViewController () <HomeChannelDetailBottomOperateViewDelegate, PopupListViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CommonWebView *webView;
@property (nonatomic, strong) HomeChannelDetailBottomOperateView *bottomOperationView;
@property (nonatomic, strong) PopupListView *popView;

@end

@implementation HomeChannelArticleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView.frame = CGRectMake(0,
                                    CGRectGetMaxY(naviBar.frame),
                                    GetViewWidth(self.view),
                                    GetViewHeight(self.view) - CGRectGetMaxY(naviBar.frame) - 55);
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    
    self.bottomOperationView.frame = CGRectMake(0, GetViewHeight(self.view) - 45, GetViewWidth(self.view), 45);
    self.bottomOperationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    if (self.articleID && ![self.articleID isEqualToString:@""]) {
        [self articleByIDRequest];
    } else {
        self.bottomOperationView.favour = self.articleDTO.favour;
        self.bottomOperationView.favourNumber = self.articleDTO.favourCount;
        self.bottomOperationView.speakCountNumber = self.articleDTO.commentCount;
        [self.webView loadRequestURL:self.articleDTO.articleURL];
    }
    if (self.articleDTO) {
        [ClickUtil event:@"homepage_open_article" attributes:@{ @"article_id" : self.articleDTO.id }];
    } else {
        [ClickUtil event:@"homepage_open_article" attributes:@{ @"article_id" : self.articleID }];
    }
}

- (void)createUI
{
    [super createUI];
    
    if (self.articleDTO.type == HomeArticleAndDiscussionTypeArticle) {
        [naviBar setTopTitle:@"文章详情"];
    } else {
        [naviBar setTopTitle:@"活动详情"];
    }
    
    [self createBackButton];
    [naviBar setRightButton:[NavigationBar createImageButton:@"home_detail_discussion_more.png"
                                                      target:self
                                                      action:@selector(moreButtonAction:)]];
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.bottomOperationView];
}

#pragma mark -
#pragma mark - UIActionSheetDelegate -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 5) {
            return;
        }
        
        [self reportRequestWithType:ReportTypeDiscussion reasonType:buttonIndex + 1];
    }
}

#pragma mark -
#pragma mark - HomeChannelDetailBottomOperateViewDelegate -

- (void)homeChannelDetailBottomOperateViewDidSelectWithType:(HomeChannelDetailBottomOperateViewOperationType)type
{
    switch (type) {
        case HomeChannelDetailBottomOperateViewOperationTypeRespond: {
            HomeChannelDiscussionAndArticleCommentViewController *vc = [[HomeChannelDiscussionAndArticleCommentViewController alloc] init];
            vc.articleAndDiscussionDTO = self.articleDTO;
            vc.deleteBlock = ^{
                self.articleDTO.commentCount --;
                self.bottomOperationView.speakCountNumber --;
            };
            
            vc.addSpeakBlock = ^{
                self.articleDTO.commentCount ++;
                self.bottomOperationView.speakCountNumber ++;
            };
        
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case HomeChannelDetailBottomOperateViewOperationTypeFavour:
            if (self.bottomOperationView.favour) {
                [self cancleFavourRequest];
            } else {
                [self favourRequest];
            }
            break;
        case HomeChannelDetailBottomOperateViewOperationTypeShare:
            [[MedShareManager sharedInstance]  showInView:self.view
                                                    title:self.articleDTO.title
                                                  deatail:self.articleDTO.summary
                                                    image:[self.articleDTO.images firstObject]
                                             defaultImage:self.articleDTO.type == HomeArticleAndDiscussionTypeArticle ? @"wechat_share_article.png" : @"wechat_share_event.png"
                                                 shareURL:self.articleDTO.shareURL];
            break;
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
    NSArray *infoArray = @[ @{ @"image" : @"home_report.png", @"title" : @"举报", @"showSeparation" : @(NO) } ];
    
    return infoArray[index];
}

- (Class)cellClassOfPopuoListView:(PopupListView *)listView
{
    return [MessagePopupListViewTableViewCell class];
}

- (void)popupListView:(PopupListView *)listView didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"举报"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"不实身份",@"垃圾营销",@"敏感信息",@"淫秽色情",@"不实信息", nil];
        sheet.tag = 1000;
        sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [sheet showInView:self.view];
    }
}

#pragma mark -
#pragma mark - response event -

- (void)moreButtonAction:(UIButton *)button
{
    [self.popView showAtPoint:CGPointMake(GetScreenWidth - 75, 64) inView:self.view];
}

#pragma mark -
#pragma mark - network -

- (void)articleByIDRequest
{
    NSDictionary *param = @{ @"method" : @(MethodTypeChannelCommentByID), @"id" : self.articleID };
    
    [ChannelManager getChannelParam:param success:^(id JSON) {
        self.articleDTO = JSON;
        self.bottomOperationView.favour = self.articleDTO.favour;
        self.bottomOperationView.favourNumber = self.articleDTO.favourCount;
        self.bottomOperationView.speakCountNumber = self.articleDTO.commentCount;
        if (self.articleDTO.articleURL.length > 0) {
            [self.webView loadRequestURL:self.articleDTO.articleURL];
        } else {
            [InfoAlertView showInfo:@"没有相应文章" inView:self.view duration:1.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:[dic objectForKey:@"message"] inView:self.view duration:1];
    }];
}

- (void)favourRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelFavour),
                              @"id" : self.articleDTO.id,
                              @"type" : @(self.articleDTO.type) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if (![[JSON objectForKey:@"success"] boolValue]) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            NSInteger favourCount = [JSON[@"result"][@"like_count"] integerValue];
            self.bottomOperationView.favourNumber = favourCount;
            self.bottomOperationView.favour = YES;
            
            self.articleDTO.favour = YES;
            self.articleDTO.favourCount = favourCount;
            if (self.updateBlock) {
                self.updateBlock(self.articleDTO);
            }
        }
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:[dic objectForKey:@"message"] inView:self.view duration:1];
    }];
}

- (void)cancleFavourRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelUnFavour),
                              @"id" : self.articleDTO.id,
                              @"type" : @(self.articleDTO.type) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        if (![[JSON objectForKey:@"success"] boolValue]) {
            [InfoAlertView showInfo:[JSON objectForKey:@"message"] inView:self.view duration:1];
        } else {
            NSInteger favourCount = [JSON[@"result"][@"like_count"] integerValue];
            self.bottomOperationView.favourNumber = favourCount;
            self.bottomOperationView.favour = NO;
            self.articleDTO.favour = NO;
            self.articleDTO.favourCount = favourCount;
            if (self.updateBlock) {
                self.updateBlock(self.articleDTO);
            }
        }
    } failure:^(NSError *error, id JSON) {
        NSDictionary *dic = [JSON objectFromJSONString];
        [InfoAlertView showInfo:[dic objectForKey:@"message"] inView:self.view duration:1];
    }];
}

- (void)reportRequestWithType:(ReportType)reportType reasonType:(NSInteger)reasonType
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (reportType == ReportTypeDiscussion) {        
        [dict setObject:@(10) forKey:@"report_type"];
        [dict setObject:self.articleDTO.id forKey:@"item_id"];
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

#pragma mark -
#pragma mark - setter and getter -

- (CommonWebView *)webView
{
    if (!_webView) {
        _webView = ({
            CommonWebView *view = [[CommonWebView alloc] initWithFrame:CGRectZero];
            view.isCanCyclic = NO;
            view.parentVC = self;
            view;
        });
    }
    return _webView;
}

- (HomeChannelDetailBottomOperateView *)bottomOperationView
{
    if (!_bottomOperationView) {
        _bottomOperationView = ({
            HomeChannelDetailBottomOperateView *view = [[HomeChannelDetailBottomOperateView alloc] initWithFrame:CGRectMake(0, 0, GetScreenWidth, 45) type:HomeChannelDetailBottomOperateViewTypeArticle];
            view.delegate = self;
            view;
        });
    }
    return _bottomOperationView;
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

@end
