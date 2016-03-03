//
//  NotificationHelper.h
//  medtree
//
//  Created by 孙晨辉 on 15/8/11.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

// User
extern NSString *const AddFriendNotification;
extern NSString *const GetFriendDataOverNotification;
extern NSString *const DeleteFriendNotification;
extern NSString *const DenyFriendNotification;
extern NSString *const FriendListChangeNotification;
extern NSString *const RelationChangeNotification;
extern NSString *const UserInfoChangeNotification;
extern NSString *const ShowInfoAlertView;
extern NSString *const UserInfoChangeCertificatedNotification;

// Message
extern NSString *const MatchFriendOverNotification;
extern NSString *const NewCountListChangeNotification;
extern NSString *const NewJobStateNotification;
extern NSString *const NewJobAssisantNotification;
extern NSString *const NewMessageNotification;
extern NSString *const MessageListChangeNotification;
extern NSString *const MessageStatusChangeNotification;
extern NSString *const MessagePullNewMessageNotification;
extern NSString *const MessagePullHistoryMessageNotification;

// Tcp
extern NSString *const ConnectTCPStatusChangeNotification;

// root controller
extern NSString *const MenuViewControllerWillShowNotification;
extern NSString *const MenuViewControllerWillHideNotification;

//login and logout
extern NSString *const LoginSuccessNotification;
extern NSString *const ImproveThePersonalInformationSuccessNotification;
extern NSString *const LogoutNotification;

@interface NotificationHelper : NSObject

@end
