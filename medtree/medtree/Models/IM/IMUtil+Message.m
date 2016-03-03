//
//  IMUtil+Message.m
//  jiayi-common
//
//  Created by sam on 6/4/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import "IMUtil+Public.h"
#import "MessageDTO.h"
#import "Messages.h"
#import "MessageBody.h"
#import "MessageTypeProxy.h"
#import "MessageManager.h"
#import "DateUtil.h"
#import "SessionDTO.h"

#import "AccountHelper.h"
#import "UserDTO.h"

#define SyncUnread_Limit 5

@implementation IMUtil (Message)

static NSTimeInterval authRequestTime;

#pragma mark IM Request
- (void)request:(NSDictionary *)info type:(NSInteger)type
{
    Class class = [Messages getClass:type];
    //
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:info];
    [dict setValue:[NSNumber numberWithInteger:type] forKey:@"msg_type"];
    //
    ImRequestBase *request = [[class alloc] initWithMessage:dict];

    if (!requestArray) {
        requestArray = [[NSMutableArray alloc] init];
    }

    long tag = MAXFLOAT;
    if (type == AUTH_REQUEST) {
        tag = MAXFLOAT - 1;
    } else if (type == SEND_PING) {
        tag = 1024;
    } else {
        tag = 0;
    }
    
    if (type == PULL_OLD_MSG_REQUEST) {
        NSLog(@"pull old tag - %ld", tag);
    }
    
    if ([client isConnected]) {
        [client writeData:[request toData] tag:tag];
        if (type == SEND_MSG_REQUEST) {
            // 将发送的信息保存成队列
            [requestArray addObject:request];
        }
    } else {
        if (type == SEND_MSG_REQUEST) {
            MessageDTO *message = [[MessageDTO alloc] init:request.toJson[@"msg"]];
            message.status = MessageFail;
            message.updateTime = [NSDate date];
            [MessageManager updateMessage:message success:nil failure:nil];
            NSError *error = [[NSError alloc] initWithDomain:@"client not work" code:100 userInfo:nil];
            [root didSendTcpMessage:message error:error];
        }
        // 发现断线，尝试重连
        [self startIM];
    } 
}

- (void)handleAuth:(NSDictionary *)info
{
    [self request:info type:AUTH_REQUEST];
    authRequestTime = [NSDate date].timeIntervalSince1970;
}

#pragma mark - 登录后获取未读数 & 得到消息后请求未读数
#pragma mark 获取未读信息
- (void)syncUnread:(NSDictionary *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (info) {
        NSInteger type = [[info objectForKey:@"type"] integerValue];
        if (type == IM_MESSAGE_TYPE_ALL) {
            [dict setValue:[NSNumber numberWithInteger:IM_MESSAGE_TYPE_ALL] forKey:@"type"];
        } else if (type == IM_MESSAGE_TYPE_GROUP) {
            [dict setValue:[info objectForKey:@"group_chat_id"] forKey:@"group_chat_id"];
        } else if (type == IM_MESSAGE_TYPE_SESSION) {
            [dict setValue:[info objectForKey:@"remote_chat_id"] forKey:@"remote_chat_id"];
        }
        [dict setValue:[info objectForKey:@"type"] forKey:@"type"];
        [dict setObject:info[@"user_chat_id"] forKey:@"user_chat_id"];
    } else {
        [dict setValue:[NSNumber numberWithInteger:IM_MESSAGE_TYPE_ALL] forKey:@"type"];
    }
    if (info[@"offset"]) {
        [dict setObject:info[@"offset"] forKey:@"offset"];
    } else {
        [dict setObject:@0 forKey:@"offset"];
    }
    [dict setObject:@SyncUnread_Limit forKey:@"limit"];
    [dict setObject:[MessageBase genRID] forKey:@"r_id"];
    [self request:dict type:SYNC_UNREAD_REQUEST];
}

#pragma mark 发送消息
- (void)sendMsg:(MessageDTO *)dto
{
    BOOL isSend = NO;
    if (dto.messageID.length == 0) {
        dto.messageID = [NSString stringWithFormat:@"%lld", [[MessageBase genRID] longLongValue]];
    } else {
        isSend = YES;
    }
    //
    NSDictionary *dict = [self convertToMsg:dto];
    if (isSend) {
        [dict setValue:dto.messageID forKey:@"r_id"];
    }
    [self request:dict type:SEND_MSG_REQUEST];
}

#pragma mark 确认未读信息 （pull old后、点击某个session、）
- (void)readAck:(NSDictionary *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (info) {
        NSInteger type = [[info objectForKey:@"type"] integerValue];
        if (type == IM_MESSAGE_TYPE_ALL) {
            
        } else if (type == IM_MESSAGE_TYPE_GROUP) {
            [dict setValue:[info objectForKey:@"remote_chat_id"] forKey:@"group_chat_id"];   // @"group_chat_id"
        } else if (type == IM_MESSAGE_TYPE_SESSION) {
            [dict setValue:[info objectForKey:@"remote_chat_id"] forKey:@"remote_chat_id"]; // @"remote_chat_id"
        }
        [dict setValue:[info objectForKey:@"type"] forKey:@"type"]; // @"type"
        //
        [dict setValue:info[@"msg_id"] forKey:@"msg_id"];   // @"msg_id"
        [dict setValue:dict[@"user_chat_id"] forKey:@"user_chat_id"];   // @"user_chat_id"

        [self request:dict type:READ_ACK_REQUEST];
    }
}

- (void)readSystemAck:(NSDictionary *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (info) {
        [dict setObject:info[@"user_id"] forKey:@"user_id"];
        [dict setObject:info[@"type"] forKey:@"type"];
        [self request:dict type:SYS_UNREAD_ACK_REQUEST];
    }
}

- (void)syncSystemUnread:(NSDictionary *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (info) {
        [dict setObject:info[@"user_id"] forKey:@"user_id"];
    }
}

#pragma mark 客户端反序分页拉去信息
- (void)pullOldMsg:(NSDictionary *)info
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (info) {
        NSInteger type = [[info objectForKey:@"type"] integerValue];

        if (type == IM_MESSAGE_TYPE_ALL) {
            
        } else if (type == IM_MESSAGE_TYPE_GROUP) {
            [dict setValue:[info objectForKey:@"remote_chat_id"] forKey:@"group_chat_id"];
        } else if (type == IM_MESSAGE_TYPE_SESSION) {
            [dict setValue:[info objectForKey:@"remote_chat_id"] forKey:@"remote_chat_id"];
        }
        [dict setValue:[info objectForKey:@"type"] forKey:@"type"];
        //
        long long minMsgId = [[info objectForKey:@"min_msg_id"] longLongValue];
        [dict setValue:[NSNumber numberWithLongLong:minMsgId] forKey:@"min_msg_id"];
        //
        long long maxMsgId = [[info objectForKey:@"max_msg_id"] longLongValue];
        [dict setValue:[NSNumber numberWithLongLong:maxMsgId] forKey:@"max_msg_id"];
        //
        long long limit = [[info objectForKey:@"limit"] longLongValue];
        if (limit == 0) {
            limit = 10;
        }
        [dict setValue:[NSNumber numberWithLongLong:maxMsgId] forKey:@"max_msg_id"];
        [dict setObject:info[@"request_type"] forKey:@"request_type"];
        [dict setValue:[NSNumber numberWithLongLong:limit] forKey:@"limit"];
        [self request:dict type:PULL_OLD_MSG_REQUEST];
    }
}

#pragma mark ping
- (void)startPingPong
{
    if (ppArray.count > 3) {
        //
        [ppArray removeAllObjects];
        //
        if (ppTimer.valid) {
            [ppTimer invalidate];
            ppTimer = nil;
        }
        // 确定为被服务器踹掉
        [self restoreConnect];
    } else {
        if ([NSDate timeIntervalSinceReferenceDate] - latestTime >= RE_PING_TIME) {
            latestTime = [NSDate timeIntervalSinceReferenceDate];
            [self sendPingPong];
        }
    }
}

- (void)sendPingPong
{
    NSNumber *rid = [MessageBase genRID];
    NSDictionary *dict = @{@"user_chat_id": [AccountHelper getAccount].chatID, @"r_id": rid};
    if ([client isConnected]) { // 如果还与服务器保持连接
        [self request:dict type:SEND_PING];
        if (!ppArray) {
            ppArray = [[NSMutableArray alloc] init];
        }
        [ppArray addObject:rid];
    }
}

#pragma mark - 根据返回的类型处理不同的事务
/**
 *  接收服务器返回并处理不同事物
 *
 *  @param data 数据源
 *  @param tag  tag 用于保证消息发送，并在响应成功时释放响应request
 */
- (void)didReciveTcpMessage:(NSData *)data
{
    //登录状态下 处理数据  非登录状体下 不做任何处理
    if (![AccountHelper getLoginState]) return;
    
    latestTime = [NSDate timeIntervalSinceReferenceDate];
    //
    NSInteger type = [MessageBody getType:data];
    
    if (type == AUTH_RESPONSE) { // 如果成功 -->1。获取未读数 2。进行ping pang
        Class class = [Messages getClass:type];
        ImResponseBase *response = [[class alloc] initWithData:data];
        //
        NSLog(@"AUTH_RESPONSE %ld", response.status);
        //
        if (response.status == SUCCESS_RESPONSE) {
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            if (response.userInfo[@"send_time"]) {
                NSTimeInterval authResponseTime = [NSDate date].timeIntervalSince1970;
                NSTimeInterval deltaTime = (authResponseTime - authRequestTime) * 0.5;
                NSTimeInterval serviceTime = [response.userInfo[@"send_time"] doubleValue] / 1000 + deltaTime;
                [param setObject:@(authResponseTime - serviceTime) forKey:kDeltaTime];
            }
            [root handleAuthSuccess:param];
            
            for (ImRequestBase *request in requestArray) {
                [self request:request.toJson type:SEND_MSG_REQUEST];
            }
            
            // 获取未读数
            [self syncUnread:@{@"user_chat_id": [AccountHelper getAccount].chatID, @"type":@(IM_MESSAGE_TYPE_ALL)}];
            [self syncSystemUnread:@{@"user_id":[AccountHelper getAccount].userID}];
            // 进行ping/pong
            if (ppTimer == nil) {
                ppTimer = [NSTimer timerWithTimeInterval:RE_PING_TIME target:self selector:@selector(startPingPong) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:ppTimer forMode:NSRunLoopCommonModes];
            }
            
            [self postNotification:ResultTypeSuccess];
            // 恢复重连超时时间
            reconnectTime = 2;
        } else {
            // 密码错误，解析失败。。。 断开连接，尝试重连
            if (reconnectTime == 0) {
                reconnectTime = 2;
            }
            reconnectTime = reconnectTime * 2;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [client disconnect];
                [root handleAuthFail:nil];
            });
            [self postNotification:ResultTypeAuthError];
        }
        
    } else if (type == SYNC_UNREAD_RESPONSE) {  // 如果成功 ---> 1. 保存到db+session
        Class class = [Messages getClass:type];
        SyncUnreadResponse *response = (SyncUnreadResponse *)[[class alloc] initWithData:data];
        //
        NSLog(@"SYNC_UNREAD_RESPONSE %ld", response.status);
        //
        if (response.status == SUCCESS_RESPONSE) {
            if (response.unreads.count > 0) {
                [root didReceiveUnreadMessages:response.unreads];
            }
            
            // 此时并不触发 read ack
            if (response.unreads.count >= SyncUnread_Limit) {
                [self syncUnread:@{@"user_chat_id": [AccountHelper getAccount].chatID, @"type":@(IM_MESSAGE_TYPE_ALL), @"offset":@(response.offset)}];
            }
        }
        
    } else if (type == PULL_OLD_MSG_RESPONSE) { // 成功 ---> 1.保存db+message 2.通知视图 3.发送readAck
        Class class = [Messages getClass:type];
        PullOldMsgResponse *response = (PullOldMsgResponse *)[[class alloc] initWithData:data];
        //
        NSLog(@"PULL_OLD_MSG_RESPONSE %ld", response.status);
        //
        if (response.status == SUCCESS_RESPONSE) {
            if (response.msgs.count > 0) {
                [root didReceiveMessages:response.msgs type:response.pullOldType];
            }
        }
    } else if (type == READ_ACK_RESPONSE) { // do nothing
        Class class = [Messages getClass:type];
        ImResponseBase *response = [[class alloc] initWithData:data];
        //
        NSLog(@"READ_ACK_RESPONSE %ld", response.status);
        //
        if (response.status == SUCCESS_RESPONSE) { }
    } else if (type == SEND_MSG_RESPONSE) { // 更新db+message更改message状态， 更改db+session表
        Class class = [Messages getClass:type];
        ImResponseBase *response = [[class alloc] initWithData:data];
        //
        NSLog(@"SEND_MSG_RESPONSE %ld", response.status);
        //
        if (response.status == SUCCESS_RESPONSE) {
            [self didSendTcpMessage:[self convertToDTO:[response toJson]] error:nil];
            
            ImRequestBase *msgRequest = nil;
            for (ImRequestBase *request in requestArray) {
                if (request.msgType == SEND_MSG_REQUEST) {
                    if (request.rId == response.rId) {
                        msgRequest = request;
                    }
                }
            }
            [requestArray removeObject:msgRequest];
        } else if (response.status == ERROR_NOT_FRIENDS) {
            MessageDTO *message = [self convertToDTO:[response toJson]];
            message.status = MessageFail;
            message.updateTime = [NSDate date];
            message.errorCode = ERROR_NOT_FRIENDS;
            [MessageManager updateMessage:message success:nil failure:nil];
            NSError *error = [[NSError alloc] initWithDomain:@"not friends" code:ERROR_NOT_FRIENDS userInfo:nil];
            [root didSendTcpMessage:message error:error];
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"IMUtil+Tcp" code:response.status userInfo:@{@"errorMsg": response.errorMsg}];
            [self didSendTcpMessage:[self convertToDTO:[response toJson]] error:error];
        }
        
    } else if (type == NEW_MSG_INFO) {  // 发送syncunread 获取最新的未读消息
        Class class = [Messages getClass:type];
        NewMessage *newMsg = [[class alloc] initWithData:data];
        //
        NSLog(@"NEW_MSG_INFO %@", newMsg.userChatId);
        // sync unread
        if (newMsg.type == 3) { // 群组
            [self syncUnread:@{@"user_chat_id":[AccountHelper getAccount].chatID, @"group_chat_id":newMsg.groupChatId, @"type":@(newMsg.type)}];
        } else if (newMsg.type == 2) { // 单人
            [self syncUnread:@{@"user_chat_id":[AccountHelper getAccount].chatID, @"remote_chat_id":newMsg.remoteChatId, @"type":@(newMsg.type)}];
        }
        // 通知是否需要更新
        [root notifyNewMessage:[[MessageDTO alloc] init:newMsg.userInfo]];
    } else if (type == OFF_LINE_INFO) {
        NSLog(@"OFF_LINE_INFO");
        //
        if ([AccountHelper getLoginState]) {
            if ([ppTimer isValid]) {
                [ppTimer invalidate];
                ppTimer = nil;
            }
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"ChangeNewPassword"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [client disconnect];
            [AccountHelper setLoginState:NO];
            [root didLoginFromOtherDevice:nil];
        }
        
    } else if (type == RECEIVE_PONG) {
        NSLog(@"PING -> PONG");
    } else if (type == NEW_SYS_MSG_INFO) {
        NSLog(@"NEW_SYS_MSG_INFO");
        Class class = [Messages getClass:type];
        NewSystemMsgInfo *sysMsgInfo = [[class alloc] initWithData:data];
        
        [root notifyNewSystemMessage:sysMsgInfo.systemMsgType content:sysMsgInfo.content];
    } else if (type == SYS_UNREAD_ACK_RESPONSE) {
        NSLog(@"SYS_UNREAD_ACK_RESPONSE");
    } else if (type == SYNC_SYS_UNREAD_RESPONSE) {
        NSLog(@"SYNC_SYS_UNREAD_RESPONSE");
        Class class = [Messages getClass:type];
        SyncSystemUnreadResponse *sysUnread = [[class alloc] initWithData:data];
        if (sysUnread.unreads.count > 0) {
            for (NSDictionary *dict in sysUnread.unreads) {
                [root notifyNewSystemMessage:[dict[@"system_type"] integerValue] content:dict[@"content"]];
            }
        }
    }
    // 只要有消息，就说明是网络正常的
    [ppArray removeAllObjects];
}

// 发送信息
- (MessageDTO *)sendTcpMessage:(MessageDTO *)message
{
    if (message.messageID.length == 0) {
        message.messageID = [NSString stringWithFormat:@"%lld", [[MessageBase genRID] longLongValue]];
    } else {
        // resend message
    }
    [MessageManager addMessage:message success:nil failure:nil];
    [self sendMsg:message];
    //
    return message;
}

// 确认消息是否发送成功
- (void)didSendTcpMessage:(MessageDTO *)message error:(NSError *)error
{
    if (message) {
        if (error == nil) {
            message.status = MessageSent;
        } else {
            message.status = MessageFail;
        }
        [MessageManager updateMessage:message success:nil failure:nil];
        [root didSendTcpMessage:message error:error];
    }
}

#pragma mark Convert Message & Session

- (NSDictionary *)convertToMsg:(MessageDTO *)dto
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (dto) {
        [dict setValue:dto.toID forKey:@"remote_chat_id"];
        [dict setValue:[NSNumber numberWithInteger:IM_MESSAGE_TYPE_SESSION] forKey:@"type"];
        //
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        //
        [msg setValue:dto.fromID forKey:@"from_chat_id"];
        [msg setValue:dto.toID forKey:@"to_chat_id"];
        [msg setValue:dto.fromUserID forKey:@"from_user_id"];
        [msg setValue:dto.toUserID forKey:@"to_user_id"];
        [msg setValue:dto.toID forKey:@"to_chat_id"];
        [msg setValue:[NSNumber numberWithInteger:IM_MESSAGE_TYPE_SESSION] forKey:@"type"];
        [msg setValue:dto.content forKey:@"content"];
        [msg setValue:[MessageTypeProxy getMineType:dto.type] forKey:@"mine_type"];
        [msg setValue:dto.messageID forKey:@"r_id"];

        //
        [dict setValue:msg forKey:@"msg"];
    }
    return dict;
}

- (MessageDTO *)convertToDTO:(NSDictionary *)dict
{
    MessageDTO *dto = [[MessageDTO alloc] init:dict];
    return dto;
}

- (NSString *)getStrValue:(NSString *)str
{
    NSString *s = @"";
    if ((NSObject *)str != [NSNull null] && str != nil) {
        s = str;
    }
    return s;
}

@end
