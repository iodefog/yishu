//
//  MessageManager+Notification.m
//  medtree
//
//  Created by sam on 8/20/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "MessageManager+Notification.h"
#import "UserManager.h"
#import "MessageDTO.h"
#import "NotificationDTO.h"
#import "DateUtil.h"

@implementation MessageManager (Notification)

//+ (void)getNotificationList:(NSDictionary *)param success:(SuccessBlock)success failure:(FailureBlock)failure
//{
//    
//}
//
//+ (void)addNotification:(MessageDTO *)dto success:(SuccessBlock)success failure:(FailureBlock)failure
//{
//    NotificationDTO *ndto = [[NotificationDTO alloc] init:dto.data];
//    ndto.time = dto.updateTime;
////    ndto.status = dto.type;
//    NSDictionary *param = @{@"data": ndto, @"type": [NSNumber numberWithInteger:dto.type]};
//    [UserManager receivedFriendRequest:param success:success failure:failure];
//}
//
//+ (void)markNotificationAsRead:(MessageDTO *)dto
//{
//    
//}

@end
