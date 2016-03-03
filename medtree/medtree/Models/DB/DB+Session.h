//
//  DB+Session.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class MessageDTO;
@class SessionDTO;

@interface DB (Session)

- (void)createTable_Session;
- (void)insertSession:(MessageDTO *)dto;
// sync unread 保存数据库
- (void)insertUnreadSession:(SessionDTO *)dto;
- (void)updateSession:(MessageDTO *)dto;
// sync unread 更新未读消息
- (void)updateUnreadSession:(SessionDTO *)dto;
// 进入会话清除该会话的未读消息
- (void)clearUnreadCount:(NSString *)session;
// 更新发送后的消息的remoteId
- (void)updateSessionRemoteId:(MessageDTO *)dto;

- (void)deleteSession:(SessionDTO *)dto;

- (NSArray *)selectSessionIDs;
- (void)selectAllSessions:(ArrayBlock)result;

- (NSInteger)getAllUnreadCount;

@end
