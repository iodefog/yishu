//
//  IMUtil+Tcp.h
//  jiayi-common
//
//  Created by sam on 6/5/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUtil.h"

@class SessionDTO;
@class MessageDTO;
@class UserDTO;

#define RE_PING_TIME 15

@interface IMUtil (Message)
/** 获取认证 */
- (void)handleAuth:(NSDictionary *)info;
/** 抓取未读消息 */
- (void)syncUnread:(NSDictionary *)info;
/** 发送消息 */
- (void)sendMsg:(MessageDTO *)dto;

- (void)readAck:(NSDictionary *)info;

- (void)readSystemAck:(NSDictionary *)info;

/** 抓取老消息 */
- (void)pullOldMsg:(NSDictionary *)info;

- (MessageDTO *)sendTcpMessage:(MessageDTO *)message;
- (void)didSendTcpMessage:(MessageDTO *)message error:(NSError *)error;
- (void)didReciveTcpMessage:(NSData *)data;

- (void)sendPingPong;

@end
