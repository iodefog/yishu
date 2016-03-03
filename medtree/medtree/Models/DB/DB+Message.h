//
//  DB+Message.h
//  zhihu
//
//  Created by 无忧 on 14-3-7.
//  Copyright (c) 2014年 lyuan. All rights reserved.
//

#import "DB.h"

@class MessageDTO;

@interface DB (Message)

- (void)createTable_Message;

- (void)insertMessage:(MessageDTO *)dto;
- (void)insertLastestMessages:(NSArray *)messages success:(SuccessBlock)success;
- (void)insertOldMessages:(NSArray *)messages deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success;
- (void)insertPointMessages:(NSArray *)messages deltaTime:(NSTimeInterval)deltaTime success:(SuccessBlock)success;

- (void)updateMessage:(MessageDTO *)dto;
- (void)updateMessageStatus:(MessageDTO *)dto;

- (void)deleteMessages:(NSString *)sessionID;
- (void)markAllPendingAsError;
- (void)markMessageAsRead:(NSString *)sessionID;
- (void)markMessageStatus:(NSString *)messageID status:(NSInteger)status;
- (void)getMessageUnreadCounts:(DictionaryBlock)result sessions:(NSArray *)sessions;
- (void)getAllMessageUnreadCounts:(DictionaryBlock)result;

/** 进入会话时第一次 */
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID;
/** 加载历史数据 */
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime;
- (void)selectMessages:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime remoteID:(NSNumber *)remoteID;

/** 根据pull old通知获取最新的当前最大messageID,根据入库时间 */
- (void)selectNewMessage:(ArrayBlock)result sessionID:(NSString *)sessionID createTime:(NSDate *)createTime;

- (void)selectLastestRemoteid:(SuccessBlock)success session:(NSString *)sessionID;

/** 获取当前对话最大remoteid */
- (void)getLastRemoteId:(ArrayBlock)result bySession:(NSString *)sessionId;

@end
