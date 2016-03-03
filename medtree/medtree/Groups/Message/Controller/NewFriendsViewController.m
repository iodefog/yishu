//
//  NewFriendsViewController.m
//  medtree
//
//  Created by tangshimi on 8/28/15.
//  Copyright (c) 2015 sam. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "NewFriendsTableViewCell.h"
#import "EmptyDTO.h"
#import "ServiceManager.h"
#import "UserDTO.h"
#import "NotificationDTO.h"
#import "OperationHelper.h"
#import "UserManager.h"
#import "DB+Public.h"
#import "NewPersonDetailController.h"
#import <JSONKit.h>
#import <InfoAlertView.h>

@interface NewFriendsViewController () <MedBaseTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *emptyView;

@end

@implementation NewFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self newFriendRequest];
}

- (void)createUI
{
    [super createUI];
    
    [naviBar setTopTitle:@"新朋友"];
    [self createBackButton];
    
    [table setRegisterCells:@{ @"NotificationDTO" : [NewFriendsTableViewCell class] }];
    
    self.dataEmptyView = self.emptyView;
}

#pragma mark -
#pragma mark - MedBaseTableViewDelegate -

- (void)loadHeader:(MedBaseTableView *)table
{
     [self newFriendRequest];
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index
{
    if ([dto isKindOfClass:[NotificationDTO class]]) {
        NewPersonDetailController *detail = [[NewPersonDetailController alloc] init];
        [self.navigationController pushViewController:detail animated:YES];
        detail.notificationDTO = (NotificationDTO *)dto;
        detail.parent = self;
    }
}

- (void)clickCell:(id)dto index:(NSIndexPath *)index action:(NSNumber *)action
{
    if ([action integerValue] == ClickAction_FriendRequestAccept) {
        NSDictionary *param = @{@"method": @(MethodType_Accept_Friend), @"data": dto};
        [ServiceManager setData:param success:^(id JSON) {
            if ([JSON[@"success"] boolValue] == YES) {
                NSMutableArray *array = [[table getData] firstObject];
                NotificationDTO *dto = array[index.row];
                dto.status = NewRelationStatus_Friend_Request_Accept;
                array[index.row] = dto;
                
                [table setData:@[ array ]];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:FriendListChangeNotification object:nil];
            } else {
                [InfoAlertView showInfo:JSON[@"message"] inView:self.view duration:1];
            }
        } failure:^(NSError *error, id JSON) {
            NSDictionary *dic = [JSON objectFromJSONString];
            [InfoAlertView showInfo:dic[@"message"] inView:self.view duration:1];
        }];
    }
}

- (BOOL)isAllowDelete:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)deleteData:(NotificationDTO *)dto
{
    NSDictionary *dict = @{@"data" : dto, @"method" : @(MethodType_NewFriend_Delete)};
    [ServiceManager setData:dict success:^(id JSON) {
        if ([self.tableView getData].count == 0) {
            [self showDataEmptyView];
        }
    } failure:^(NSError *error, id JSON) {
        
    }];
}

- (void)deleteFriend:(NSNotification*)notification
{
    UserDTO *dto = (UserDTO *)notification.object;
    NotificationDTO *ndto = [self matchCell:dto];
    ndto.status = NewRelationStatus_Friend_Request_Accept;
    [self triggerPullToRefresh];
}

- (void)denyFriend:(NSNotification*)notification
{
    UserDTO *dto = (UserDTO *)notification.object;
    NotificationDTO *ndto = [self matchCell:dto];
    ndto.status = NewRelationStatus_Friend_Request_Deny;
    [self triggerPullToRefresh];
}

- (NotificationDTO *)matchCell:(UserDTO *)dto
{
    NotificationDTO *ndto = nil;
    NSArray *array = [[table getData] objectAtIndex:0];
    for (int i=0;i <array.count; i++) {
        NotificationDTO *nd = [array objectAtIndex:i];
        if ([nd.userID isEqualToString:dto.userID]) {
            ndto = nd;
            break;
        }
    }
    return ndto;
}

#pragma mark -
#pragma mark - request -

- (void)newFriendRequest
{
    NSDictionary *params = @{ @"method" : @(MethodType_NewFriendList), @"from": @(0), @"size": @10000 };
    
    [UserManager getData:params success:^(id JSON) {
        [self stopLoading];
        
        NSArray *datas = (NSArray *)JSON;
        if (datas.count == 0) {
            [self showDataEmptyView];
        } else {
            [self hideDataEmptyView];
        }
        
        [table setData:@[ datas ]];
    } failure:^(NSError *error, id JSON) {
        [self stopLoading];
    }];
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)emptyView
{
    if (!_emptyView) {
        _emptyView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = GetImage(@"message_newfriends_empty.png");
            imageView;
        });
    }
    return _emptyView;
}

@end
