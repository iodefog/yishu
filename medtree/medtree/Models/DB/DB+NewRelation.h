//
//  DB+NewRelation.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class NotificationDTO;

typedef enum {
    NewRelationStatus_Friend_Request        = 201,
    NewRelationStatus_Friend_Request_Deny   = 202,
	NewRelationStatus_Friend_Request_Accept = 203,
    NewRelationStatus_Friend_Request_Sent   = 204,
    NewRelationStatus_Friend_Request_Inivte = 205,
    NewRelationStatus_All                   = 200,
} NewRelation_Status;

@interface DB (NewRelation)

- (void)createTable_NewRelation;
- (void)insertNewRelation:(NotificationDTO *)dto;
- (void)deleteNewRelation:(NotificationDTO *)dto;
- (void)deleteAllNewRelation;
- (void)updateNewRelation:(NotificationDTO *)dto;
- (NSArray *)selectNewRelationIDs;
- (void)selectAllNewRelations:(ArrayBlock)result;
- (void)markAllNotificationAsRead;
- (void)getAllNotificationUnreadCounts:(ArrayBlock)result;

@end
