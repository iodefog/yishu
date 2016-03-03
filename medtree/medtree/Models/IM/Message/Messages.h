//
//  Messages.h
//  jiayi-common
//
//  Created by sam on 6/6/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageBase.h"


typedef enum {
    // 客户端鉴权，同时用于连接建立后试探网络环境
    // 鉴权信息必须是网络联通后客户端发送的第一个信息，否则连接被关闭
    AUTH_REQUEST        = 1,
    AUTH_RESPONSE,

    
    // 客户端同步未读信息
    SYNC_UNREAD_REQUEST,
    SYNC_UNREAD_RESPONSE,
    
    // 客户端确认未读信息已被读取
    READ_ACK_REQUEST,
    READ_ACK_RESPONSE,
    
    // 客户端以反序分页拉取信息
    PULL_OLD_MSG_REQUEST,
    PULL_OLD_MSG_RESPONSE,
    
    // 客户端发送信息
    SEND_MSG_REQUEST,
    SEND_MSG_RESPONSE,
    
    NEW_MSG_INFO,
    OFF_LINE_INFO,

    // 其他request超时时，发送ping
    SEND_PING           = 13,
    RECEIVE_PONG,
    
    // 新的系统通知
    NEW_SYS_MSG_INFO    = 15,
    
    SYNC_SYS_UNREAD_REQUEST = 16,
    SYNC_SYS_UNREAD_RESPONSE = 17,
    
    SYS_UNREAD_ACK_REQUEST = 18,
    SYS_UNREAD_ACK_RESPONSE = 19,
} IM_Request_Type;


typedef enum {
    ERROR_WRONG_REQUEST_BODY_FORMAT = 0,
    ERROR_ILLEGAL_SESSION_KEY,
    ERROR_EMPTY_INBOX,
    ERROR_MSG_NOT_EXIST,
    
    ERROR_AUTH_FAIL,
    
    SUCCESS_RESPONSE = 200,
    
    ERROR_NOT_FRIENDS = 2001,
} IM_Message_Status;


typedef enum {
    IM_MESSAGE_TYPE_ALL     = 1,
    IM_MESSAGE_TYPE_SESSION = 2,
    IM_MESSAGE_TYPE_GROUP   = 3,
} IM_Message_TYPE;

typedef NS_ENUM(NSInteger, PullOldMsgType) {
    PullOldMsgRequestLatest     = 1,
    PullOldMsgRequestOld        = 2,
    PullOldMsgRequestPointed    = 3,
};


@interface Messages : NSObject

+ (Class)getClass:(NSInteger)type;

@end


#pragma mark SyncUnread

@interface SyncUnreadRequest : ImMessageRequest

@property (nonatomic, assign) int offset;
@property (nonatomic, assign) int limit;

@end

@interface SyncUnreadResponse : ImResponseBase

// 未读信息内容
@property (nonatomic, strong) NSArray  *unreads;
// offset
@property (nonatomic, assign) int offset;

@end


#pragma mark ReadAck

@interface ReadAckRequest : ImMessageRequest

// 信息编号
@property (nonatomic, assign) long long msgId;

@end


@interface ReadAckResponse : ImMessageResponse


@end


#pragma mark PullOldMsg

@interface PullOldMsgRequest : ImMessageRequest

// 分页最小 id
@property (nonatomic, assign) long long minMsgId;
// 分页最大 id
@property (nonatomic, assign) long long maxMsgId;
// 分页内数量
@property (nonatomic, assign) long long limit;

@property (nonatomic, assign) PullOldMsgType pullOldType;

@end


@interface PullOldMsgResponse : ImMessageResponse

// 消息内容
@property (nonatomic, strong) NSArray *msgs;

@property (nonatomic, assign) PullOldMsgType pullOldType;

@end




#pragma mark NewMessage


@interface NewMessage : ImMessageRequest


@end

#pragma mark OffLine

@interface OffLine : ImMessageRequest


@end


@interface Message : ImRequestBase

@property (nonatomic, strong) NSString  *fromUserId;

@property (nonatomic, strong) NSString  *fromChatId;

@property (nonatomic, strong) NSString  *toUserId;

@property (nonatomic, strong) NSString  *toChatId;

@property (nonatomic, strong) NSString  *groupId;

@property (nonatomic, strong) NSString  *groupChatId;

@property (nonatomic, assign) NSInteger type;

// 服务器端产生的唯一 msg id
@property (nonatomic, assign) long long msgId;
// 服务器端接收到消息的时间戳
@property (nonatomic, assign) long long sendTime;

@property (nonatomic, strong) NSString  *mineType;

@property (nonatomic, strong) NSString  *content;

@end




#pragma mark SendMsg

@interface SendMsgRequest : ImMessageRequest

@property (nonatomic, strong) Message   *msg;

@end


@interface SendMsgResponse : ImMessageResponse

// 服务器端产生的唯一 msg id
@property (nonatomic, assign) long long msgId;
// 服务器端接收到消息的时间戳
@property (nonatomic, assign) long long sendTime;

@end

#pragma mark Ping & Pong

@interface SendPing : ImMessageRequest

@end

@interface ReceivePong : ImMessageResponse


@end

#pragma mark New System Message Info

@interface NewSystemMsgInfo : ImMessageResponse

@property (nonatomic, assign) NSInteger systemMsgType;

@property (nonatomic, strong) NSString *content;

@end

#pragma mark Sync System Unread Request

@interface SyncSystemUnreadRequest : ImMessageRequest

@property (nonatomic, strong) NSString *userId;

@end

#pragma mark Sync System Unread Response

@interface SyncSystemUnreadResponse : ImMessageResponse

@property (nonatomic, strong) NSString *userId;

@property (nonatomic, strong) NSArray *unreads;

@end

#pragma mark System Unread AckRequest

@interface SystemUnreadAckRequest : ImMessageRequest

@property (nonatomic, strong) NSString *userId;

@end

#pragma mark System Unread AckResponse

@interface SystemUnreadAckResponse : ImMessageResponse

@property (nonatomic, strong) NSString *userId;

@end

#pragma mark Auth

@interface AuthRequest : ImRequestBase

// 消息体
@property (nonatomic, strong) NSDictionary   *authMessage;
@property (nonatomic, strong) NSString *token;

@end


@interface AuthResponse : ImResponseBase


@end

