//
//  HomeChannelInviteFriendsViewController.m
//  medtree
//
//  Created by tangshimi on 9/21/15.
//  Copyright © 2015 sam. All rights reserved.
//

#import "HomeChannelInviteFriendsViewController.h"
#import "SZTextView.h"
#import "HomeChannelInviteFriendsTableViewCell.h"
#import "UserDTO.h"
#import "ChannelManager.h"
#import <JSONKit.h>
#import <InfoAlertView.h>
#import "HomeArticleAndDiscussionDTO.h"
#import <MBProgressHUD.h>

@interface HomeChannelInviteFriendsViewController () <BaseTableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) SZTextView *textView;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *seletecdIndexArray;

@end

@implementation HomeChannelInviteFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.seletecdIndexArray = [[NSMutableArray alloc] init];
    self.startIndex = 0;
    self.pageSize = 10;
    
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@50);
    }];
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.bottom);
        make.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
    [self triggerPullToRefresh];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"邀请好友参与讨论"];
    [naviBar setLeftButton:[NavigationBar createButton:@"取消" type:0 target:self action:@selector(cancleButtonAction:)]];
    [naviBar setRightButton:[NavigationBar createButton:@"确定" type:0 target:self action:@selector(inviteButtonAction:)]];
    
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.textView];
    
    [table setRegisterCells:@{ @"UserDTO" : [HomeChannelInviteFriendsTableViewCell class] }];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(UserDTO *)dto index:(NSIndexPath *)index
{
    [self.view endEditing:YES];

    if (dto.isSelect) {
        [self.seletecdIndexArray removeObject:dto];
    } else {
        [self.seletecdIndexArray addObject:dto];
    }
    
    dto.isSelect = !dto.isSelect;
    
    self.dataArray[index.row] = dto;
    
    [table setData:@[ self.dataArray ]];
}

- (void)loadHeader:(BaseTableView *)table
{
    self.startIndex = 0;
    [self friendListRequest];
}

- (void)loadFooter:(BaseTableView *)table
{
    [self friendListRequest];
}

#pragma mark -
#pragma mark - response event -

- (void)cancleButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteButtonAction:(UIButton *)button
{
    if (self.seletecdIndexArray.count == 0) {
        [InfoAlertView showInfo:@"请至少选择一人" inView:self.view duration:1];
        return;
    }
    
    [self inviteFriendRequest];
}

#pragma mark -
#pragma mark - network -

- (void)friendListRequest
{
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelInvitePeopleList),
                              @"channel_id" : self.discussionDTO.channelID,
                              @"from" : @(self.startIndex),
                              @"size" : @(self.pageSize) };
    
    [ChannelManager getChannelParam:params success:^(id JSON) {
        [self handleFriendListRequest:JSON];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
        
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
    }];
}

- (void)handleFriendListRequest:(id)json
{
    [self stopLoading];
    NSArray *array = json;
    
    if (self.startIndex == 0) {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
    self.startIndex += array.count;
    self.enableFooter = (array.count == self.pageSize);
    
    [table setData:@[ self.dataArray ]];
}

- (void)inviteFriendRequest
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSMutableArray *selectedUserIDArray = [NSMutableArray new];
    [self.seletecdIndexArray enumerateObjectsUsingBlock:^(UserDTO *dto, NSUInteger idx, BOOL *stop) {
        [selectedUserIDArray addObject:dto.userID];
    }];
    
    NSDictionary *params = @{ @"method" : @(MethodTypeChannelInvitePeople),
                              @"message" : self.textView.text,
                              @"content_id" : self.discussionDTO.id,
                              @"users" :  selectedUserIDArray };
    [ChannelManager getChannelParam:params success:^(id JSON) {
        NSString *message = nil;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([JSON[@"success"] boolValue]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
            message = @"邀请成功";
        } else {
            message = JSON[@"message"];
        }
        
        [InfoAlertView showInfo:message inView:self.view duration:1];
        
    } failure:^(NSError *error, id JSON) {
        if (JSON != nil && [JSON isKindOfClass:[NSString class]]) {
            NSDictionary *result = [JSON objectFromJSONString];
            if ([result objectForKey:@"message"] != nil) {
                [InfoAlertView showInfo:[result objectForKey:@"message"] inView:self.view duration:1];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    CGRect rect = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(rect.origin.y - textView.frame.size.height + rect.size.height, 0);
    if (textView.contentOffset.y < caretY && rect.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (SZTextView *)textView
{
    if (!_textView) {
        _textView = ({
            SZTextView *textView = [[SZTextView alloc] init];
            textView.font = [UIFont systemFontOfSize:13];
            textView.delegate = self;
            textView.textColor = [UIColor grayColor];
            textView.textContainerInset = UIEdgeInsetsMake(12, 15, 0, 15);
            textView.text = @"快来参与这个讨论吧！";
            textView.backgroundColor = [UIColor clearColor];
            textView;
        });
    }
    return _textView;
}

@end
