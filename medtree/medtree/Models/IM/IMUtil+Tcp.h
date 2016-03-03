//
//  IMUtil+Tcp.h
//  jiayi-common
//
//  Created by sam on 6/5/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMUtil.h"

typedef enum {
    ResultTypeSuccess,//连接成功
    ResultTypeConnecting,//连接中...
    ResultTypeNetError, // 网络不给力
    ResultTypeTCPError, // 服务器异常
    ResultTypeIPError,  // ip获取异常
    ResultTypeAuthError, // 服务失败
}ResultType;

@interface IMUtil (Tcp) <TcpClientDelegate>

- (void)startTcpIM;

- (void)setHost:(NSDictionary *)info;

- (void)restoreConnect;

/** 检查网络状态 */
- (void)checkConnect;

- (void)postNotification:(ResultType)resultType;

@end
