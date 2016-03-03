//
//  ChatViewController.m
//  medtree
//
//  Created by tangshimi on 8/25/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "MessageViewController.h"
#import "SessionDTO.h"
#import "MessageTableViewCell.h"
#import "UserDTO.h"
#import "NavigationBarHeadView.h"
#import "RootViewController.h"
#import "CHTitleView.h"
#import "IMUtil+Public.h"
#import "MessageManager.h"
#import "PopUpListView.h"
#import "NewFriendsViewController.h"
#import "MessageNotificationController.h"
#import "MessagePopupListViewTableViewCell.h"
#import "MessageController.h"
#import "MessageManager+Count.h"
#import "NewCountDTO.h"
#import "AccountHelper.h"
#import "ChatFriendListController.h"
#import "MessageGuideView.h"
#import "ApplyedJobListController.h"
#import "MessageJobPushViewController.h"

@interface MessageViewController () <BaseTableViewDelegate, PopupListViewDelegate, MessageControllerDelegate>

@property (nonatomic, strong) NavigationBarHeadView *leftBarItem;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) CHTitleView *titleView;
@property (nonatomic, strong) PopupListView *popView;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    [[IMUtil sharedInstance] checkConnect];
    
    [table makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    
    [self loadDefaultTableViewData];
    
    [MessageGuideView showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setLeftButton:self.leftBarItem];
    [naviBar setRightButton:[NavigationBar createImageButton:@"message_message.png"
                                               selectedImage:nil
                                                      target:self
                                                      action:@selector(clickFriends)]];
    [naviBar setTopView:self.titleView];

    table.enableHeader = NO;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerCells:@{ @"SessionDTO" : [MessageTableViewCell class] }];
}

- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newFriendCount:)
                                                 name:FriendListChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyNewNotify:)
                                                 name:NewCountListChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tcpStatusChange:)
                                                 name:ConnectTCPStatusChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyNewMessage:)
                                                 name:MessageListChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyNewJob:)
                                                 name:NewJobStateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyNewJobAssisant:)
                                                 name:NewJobAssisantNotification object:nil];
}

- (void)loadDefaultTableViewData
{
    [self.dataArray removeAllObjects];
    NSArray *defaultTitlesArray = @[ @"新朋友", @"通知", @"职位备忘", @"求职小助手" ];
    NSArray *defaultImagesArray = @[ @"message_new_friend.png", @"message_notificatin.png", @"message_resume.png", @"message_assistant.png" ];
    
    [defaultTitlesArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        SessionDTO *sessionDTO = [[SessionDTO alloc] init];
        sessionDTO.ext = @{ @"title" : title, @"image" : defaultImagesArray[idx] };
        sessionDTO.type = 1;
        [self.dataArray addObject:sessionDTO];
    }];
    
    NSDictionary *param = @{@"method":@(MethodType_SessionList)};
    [ServiceManager getData:param success:^(id JSON) {
        NSArray *array = (NSArray *)JSON;
        for (int i = 0; i < array.count; i++) {
            SessionDTO *dto = array[i];
            if (dto.sessionID.length > 1) {
                [self.dataArray addObject:dto];
            }
        }
        [table setData:@[self.dataArray]];
    } failure:^(NSError *error, id JSON) {
        
    }];
    
    [self newFriendCount:nil];
    [self notifyNewNotify:nil];
    [self notifyNewJob:nil];
    [self notifyNewJobAssisant:nil];
}

#pragma mark - click
- (void)clickFriends
{
    ChatFriendListController *vc = [[ChatFriendListController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - BaseTableViewDelegate -

- (void)clickCell:(SessionDTO *)dto index:(NSIndexPath *)index
{
    if (index.row == 0) {
        [MessageManager markNewCountAsRead:kMatchNewFriend];
        [self newFriendCount:nil];
        NewFriendsViewController *vc = [[NewFriendsViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [UserManager markAllNotificationAsRead];
        [self showBadge];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index.row == 1) {
        [MessageManager markNewCountAsRead:kNotifyMessage];
        [self notifyNewNotify:nil];
        MessageNotificationController *vc = [[MessageNotificationController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self showBadge];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index.row == 2) {
        [MessageManager markNewCountAsRead:kNotifyJob];
        [self notifyNewJob:nil];
        ApplyedJobListController *vc = [[ApplyedJobListController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self showBadge];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (index.row == 3) {
        [MessageManager markNewCountAsRead:kNotifyNewJob];
        [self notifyNewJobAssisant:nil];
        MessageJobPushViewController *vc = [[MessageJobPushViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self showBadge];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        MessageController *vc = [[MessageController alloc] init];
        vc.target = dto.target;
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        return NO;
    } else {
        return YES;
    }
}

- (void)deleteData:(SessionDTO *)dto
{
    [MessageManager deleteSession:dto success:^(id JSON) {
        
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - PopupListViewDelegate -

- (CGSize)contentSizeOfPopupListView:(PopupListView *)listView
{
    return CGSizeMake(120, 100);
}

- (NSInteger)numberOfItemsOfPopupListView:(PopupListView *)listView
{
    return 2;
}

- (CGFloat)popupListView:(PopupListView *)listView cellHeightAtIndex:(NSInteger)index
{
    return 50;
}

- (void)popupListView:(PopupListView *)listView didSelectedAtIndex:(NSInteger)index
{
    
}

- (Class)cellClassOfPopuoListView:(PopupListView *)listView
{
    return [MessagePopupListViewTableViewCell class];
}

- (NSDictionary *)popuplistView:(PopupListView *)listView infoDictionaryAtIndex:(NSInteger)index
{
    NSArray *infoArray = @[ @{ @"image" : @"message_send_message.png", @"title" : @"发消息" },
                            @{ @"image" : @"message_group_message.png", @"title" : @"发起群聊" } ];
    
    return infoArray[index];
}

#pragma mark -
#pragma mark - response event -

- (void)messageButtonAction:(UIButton *)button
{
    [self.popView showAtPoint:CGPointMake(GetScreenWidth - 75, 64) inView:self.view];
}

- (void)tcpStatusChange:(NSNotification *)noti
{
    int status = [noti.userInfo[@"status"] intValue];
    BOOL inHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    if (inHouse) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case ResultTypeConnecting: {
                    [self.titleView setTitle:@"连接中..."];
                    self.titleView.loading = YES;
                    break;
                }
                case ResultTypeNetError: {
                    [self.titleView setTitle:@"网络异常"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeSuccess: {
                    [self.titleView setTitle:@"消息"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeTCPError: {
                    [self.titleView setTitle:@"连接异常"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeAuthError: {
                    [self.titleView setTitle:@"认证异常"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeIPError: {
                    [self.titleView setTitle:@"ip获取异常"];
                    self.titleView.loading = YES;
                    break;
                }
                default: {
                    [self.titleView setTitle:@"消息"];
                    self.titleView.loading = NO;
                    break;
                }
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case ResultTypeConnecting: {
                    [self.titleView setTitle:@"连接中..."];
                    self.titleView.loading = YES;
                    break;
                }
                case ResultTypeNetError: {
                    [self.titleView setTitle:@"网络异常"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeSuccess: {
                    [self.titleView setTitle:@"消息"];
                    self.titleView.loading = NO;
                    break;
                }
                case ResultTypeTCPError: {
                    [self.titleView setTitle:@"连接异常"];
                    self.titleView.loading = NO;
                    break;
                }
                default: {
                    [self.titleView setTitle:@"连接中..."];
                    self.titleView.loading = YES;
                    break;
                }
            }
        });
    }
}

#pragma mark New Job Assisant Notify
- (void)notifyNewJobAssisant:(NSNotification *)notification
{
    [MessageManager getNewCountByKey:kNotifyNewJob success:^(NewCountDTO *dto) {
        SessionDTO *sessionDto = self.dataArray[3];
        sessionDto.unreadCount = dto.unread;
        dispatch_async(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:nil];
}

#pragma mark New Job Notify
- (void)notifyNewJob:(NSNotification *)notification
{
    [MessageManager getNewCountByKey:kNotifyJob success:^(NewCountDTO *dto) {
        SessionDTO *sessionDto = self.dataArray[2];
        sessionDto.unreadCount = dto.unread;
        dispatch_async(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:nil];
}

#pragma mark New Notify Count
- (void)notifyNewNotify:(NSNotification *)notification
{
    [MessageManager getNewCountByKey:kNotifyMessage success:^(NewCountDTO *dto) {
        SessionDTO *sessionDto = self.dataArray[1];
        sessionDto.unreadCount = dto.unread;
        dispatch_async(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:nil];
}

#pragma mark New Friend Count
- (void)newFriendCount:(NSNotification *)notification
{
    [MessageManager getNewCountByKey:kMatchNewFriend success:^(NewCountDTO *dto) {
        SessionDTO *sessionDto = self.dataArray[0];
        sessionDto.unreadCount = dto.unread;
        dispatch_async(dispatch_get_main_queue(), ^{
            [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failure:nil];
}

#pragma mark Sync Unread Count
- (void)notifyNewMessage:(NSNotification *)notification
{
    NSDictionary *param = @{@"method": [NSNumber numberWithInteger:MethodType_SessionList]};
    [ServiceManager getData:param success:^(id JSON) {
        [self.dataArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, self.dataArray.count - 4)]];
        dispatch_async([MedGlobal getDbQueue], ^{
            NSArray *array = (NSArray *)JSON;
            for (int i=0; i<array.count; i++) {
                SessionDTO *dto = array[i];
                if (dto.sessionID.length > 1) {
                    [self.dataArray addObject:dto];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [table setData:@[self.dataArray]];
            });
        });
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark - MessageControllerDelegate
- (void)backFromMessage
{
    NSDictionary *param = @{@"method":@(MethodType_SessionList)};
    [ServiceManager getData:param success:^(id JSON) {
        [self.dataArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, self.dataArray.count - 4)]];
        NSArray *array = (NSArray *)JSON;
        for (int i = 0; i<array.count; i++) {
            SessionDTO *dto = array[i];
            if (dto.sessionID.length > 1) {
                [self.dataArray addObject:dto];
            }
        }
        [table setData:@[self.dataArray]];
        [self showBadge];
    } failure:^(NSError *error, id JSON) {
        
    }];
}

#pragma mark -
#pragma mark - private -
- (void)showBadge
{
    NSInteger notifyCount = [MessageManager getAllNotifyCount];
    NSInteger unreadCount = [MessageManager getAllUnreadCount];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger count = notifyCount + unreadCount;
        if (count == 0) {
            self.navigationController.tabBarItem.badgeValue = nil;
        } else {
            self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%@", @(count)];
        }
    });
}

#pragma mark -
#pragma mark - setter and getter -

- (NavigationBarHeadView *)leftBarItem
{
    if (!_leftBarItem) {
        _leftBarItem = ({
            NavigationBarHeadView *headView = [[NavigationBarHeadView alloc] init];
            headView.clickBlock = ^{
                [[RootViewController shareRootViewController] showLeftSideMenuViewController];
            };
            headView;
        });
    }
    return _leftBarItem;
}

- (CHTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [CHTitleView titleView];
    }
    return _titleView;
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
