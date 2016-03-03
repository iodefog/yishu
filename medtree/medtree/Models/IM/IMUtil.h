//
//  IMUtil.h
//  medtree
//
//  Created by sam on 8/12/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TcpClient.h"
#import "Messages.h"
#import "ServicePrefix.h"


#define USE_IM_TCP

@class MessageDTO;

@protocol ChatManagerDelegate

@required
/** 连接成功 */
- (void)didConnectionSuccess;
/** 当前ip不可用 - connectionError */
- (void)connectionErrorWithIP:(NSString *)ip;
/** 发送消息回调 */
- (void)didSendTcpMessage:(MessageDTO *)dto error:(NSError *)error;
/** 认证成功 - AUTH_RESPONSE */
- (void)handleAuthSuccess:(NSDictionary *)info;
/** 认证失败 - AUTH_RESPONSE */
- (void)handleAuthFail:(NSDictionary *)info;
/** 新消息提示 - SYNC_UNREAD_RESPONSE */
- (void)didReceiveUnreadMessages:(NSArray *)array;
/** 拉取新消息 - PULL_OLD_MSG_RESPONSE */
- (void)didReceiveMessages:(NSArray *)array type:(PullOldMsgType)type;
/** 被踢 - OFF_LINE_INFO */
- (void)didLoginFromOtherDevice:(NSString *)message;
/** 系统消息 */
- (void)notifyNewSystemMessage:(NSInteger)type content:(NSString *)content;
/** 收到推送通知 */
- (void)didReceivedAPNS:(NSDictionary *)param;

@optional
/** 连接失败， not use */
- (void)didConnectionError:(NSError *)error;

/** 有新的消息 - NEW_MSG_INFO */
- (void)notifyNewMessage:(MessageDTO *)message;

/** 网络不好，断线 */
- (void)imClientBreakOff;

@end

extern NSString *const kDeltaTime;

@class Reachability;
@interface IMUtil : NSObject<UIApplicationDelegate> {
    TcpClient               *client;
    Reachability            *serverReach;
    /** 重连timer */
    NSTimer                 *connectTimer;
    /** 请求记录 */
    NSMutableArray          *requestArray;
    /** 重连时长 */
    NSTimeInterval          reconnectTime;
    /** 记录发出的ping pang 的rid */
    NSMutableArray          *ppArray;
    // 连接次数
    NSInteger               connectCount;
    /** ping pang 计数器，需要在连接失败，超时，退出，认证成功，进入后台时维护 */
    NSTimer                 *ppTimer;
    /** 最新的通信时间 */
    NSTimeInterval          latestTime;
    //
    id<ChatManagerDelegate> root;
}

+ (IMUtil *)sharedInstance;

- (void)startIM;

- (MessageDTO *)sendMessage:(MessageDTO *)message;
- (MessageDTO *)resendMessage:(MessageDTO *)message;

- (void)registerRootController:(id<ChatManagerDelegate>)uvc;

- (void)playAudio:(MessageDTO *)message success:(SuccessBlock)success failure:(FailureBlock)failure;

/** 退出登录IM */
- (void)logoutIM;

@end
