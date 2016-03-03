//
//  Messages.m
//  jiayi-common
//
//  Created by sam on 6/6/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import "Messages.h"
#import "MessageBody.h"

@implementation Messages

+ (Class)getClass:(NSInteger)type
{
    static NSMutableDictionary *dict = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [[NSMutableDictionary alloc] init];
        //
        [dict setObject:[AuthRequest class] forKey:[NSNumber numberWithInteger:AUTH_REQUEST]];
        [dict setObject:[AuthResponse class] forKey:[NSNumber numberWithInteger:AUTH_RESPONSE]];
        [dict setObject:[SyncUnreadRequest class] forKey:[NSNumber numberWithInteger:SYNC_UNREAD_REQUEST]];
        [dict setObject:[SyncUnreadResponse class] forKey:[NSNumber numberWithInteger:SYNC_UNREAD_RESPONSE]];
        [dict setObject:[ReadAckRequest class] forKey:[NSNumber numberWithInteger:READ_ACK_REQUEST]];
        [dict setObject:[ReadAckResponse class] forKey:[NSNumber numberWithInteger:READ_ACK_RESPONSE]];
        [dict setObject:[PullOldMsgRequest class] forKey:[NSNumber numberWithInteger:PULL_OLD_MSG_REQUEST]];
        [dict setObject:[PullOldMsgResponse class] forKey:[NSNumber numberWithInteger:PULL_OLD_MSG_RESPONSE]];
        [dict setObject:[SendMsgRequest class] forKey:[NSNumber numberWithInteger:SEND_MSG_REQUEST]];
        [dict setObject:[SendMsgResponse class] forKey:[NSNumber numberWithInteger:SEND_MSG_RESPONSE]];
        [dict setObject:[NewMessage class] forKey:[NSNumber numberWithInteger:NEW_MSG_INFO]];
        [dict setObject:[SendPing class] forKey:[NSNumber numberWithInteger:SEND_PING]];
        [dict setObject:[ReceivePong class] forKey:[NSNumber numberWithInteger:RECEIVE_PONG]];
        [dict setObject:[NewSystemMsgInfo class] forKey:[NSNumber numberWithInteger:NEW_SYS_MSG_INFO]];
        [dict setObject:[SyncSystemUnreadRequest class] forKey:@(SYNC_SYS_UNREAD_REQUEST)];
        [dict setObject:[SyncSystemUnreadResponse class] forKey:@(SYNC_SYS_UNREAD_RESPONSE)];
        [dict setObject:[SystemUnreadAckRequest class] forKey:@(SYS_UNREAD_ACK_REQUEST)];
        [dict setObject:[SystemUnreadAckResponse class] forKey:@(SYS_UNREAD_ACK_RESPONSE)];
    });
    
    Class class = [dict objectForKey:[NSNumber numberWithInteger:type]];
    return class;
}

@end


@implementation SyncUnreadRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.offset = [[dict objectForKey:@"offset"] intValue];
        self.limit = [[dict objectForKey:@"limit"] intValue];
    }
}

@end


@implementation SyncUnreadResponse

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.unreads = [dict objectForKey:@"unreads"];
        self.offset = [[dict objectForKey:@"offset"] intValue];
    }
}

@end


@implementation ReadAckRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.msgId = [[dict objectForKey:@"msg_id"] longLongValue];
    }
}

@end


@implementation ReadAckResponse


@end


@implementation PullOldMsgRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.minMsgId = [[dict objectForKey:@"min_msg_id"] longLongValue];
        self.maxMsgId = [[dict objectForKey:@"max_msg_id"] longLongValue];
        self.limit = [[dict objectForKey:@"limit"] longLongValue];
        self.pullOldType = [dict[@"request_type"] integerValue];
    }
}

@end


@implementation PullOldMsgResponse

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.msgs = [dict objectForKey:@"msgs"];
        self.pullOldType = [dict[@"request_type"] integerValue];
    }
}

@end


#pragma mark - 消息体
@implementation Message

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.fromUserId = [dict objectForKey:@"from_user_id"];
        self.fromChatId = [dict objectForKey:@"from_chat_id"];
        self.toUserId = [dict objectForKey:@"to_user_id"];
        self.toChatId = [dict objectForKey:@"to_chat_id"];
        self.groupId = [dict objectForKey:@"group_id"];
        self.groupChatId = [dict objectForKey:@"group_chat_id"];
        self.msgId = [[dict objectForKey:@"msg_id"] longLongValue];
        self.content = [dict objectForKey:@"content"];
        self.mineType = [dict objectForKey:@"mine_type"];
        self.sendTime = [[dict objectForKey:@"send_time"] longLongValue];
        self.type = [[dict objectForKey:@"type"] integerValue];
    }
}

@end


@implementation NewMessage


@end


@implementation OffLine


@end


#pragma mark - send message
@implementation SendMsgRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.msg = [dict objectForKey:@"msg"];
    }
}

@end


@implementation SendMsgResponse

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.msgId = [[dict objectForKey:@"msg_id"] longLongValue];
    }
}

@end

#pragma mark - ping & pong
@implementation SendPing


@end

@implementation ReceivePong

@end

#pragma mark New System Message Info

@implementation NewSystemMsgInfo

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    if (dict) {
        self.systemMsgType = [dict[@"system_type"] integerValue];
        if (dict[@"content"]) {
            self.content = dict[@"content"];
        }
    }
}

@end

#pragma mark Sync System Unread Request

@implementation SyncSystemUnreadRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    if (dict) {
        self.userId = dict[@"user_id"];
    }
}

@end

#pragma mark Sync System Unread Response

@implementation SyncSystemUnreadResponse

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    if (dict) {
        self.userId = dict[@"user_id"];
        self.unreads = dict[@"unreads"];
    }
}

@end

#pragma mark System Unread AckRequest

@implementation SystemUnreadAckRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    if (dict) {
        self.userId = dict[@"user_id"];
    }
}

@end

#pragma mark System Unread AckResponse

@implementation SystemUnreadAckResponse

@end

@implementation AuthRequest

- (void)parseMessage:(NSDictionary *)dict
{
    [super parseMessage:dict];
    //
    if (dict) {
        self.authMessage = [dict objectForKey:@"auth_message"];
        self.token = [dict objectForKey:@"token"];
    }
}

@end


@implementation AuthResponse


@end

