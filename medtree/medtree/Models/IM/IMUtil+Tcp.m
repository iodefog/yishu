//
//  IMUtil+Tcp.m
//  jiayi-common
//
//  Created by sam on 6/4/15.
//  Copyright (c) 2015 孙晨辉. All rights reserved.
//

#import "IMUtil+Public.h"
#import "SessionDTO.h"
#import "MessageDTO.h"
#import "Messages.h"
#import "MessageBody.h"
#import "AccountHelper.h"
#import "UserDTO.h"
#import "MessageTypeProxy.h"
#import "MessageManager.h"
#import "Reachability.h"
#import "KeyChain.h"
//#import "iConsole.h"

#import "Base64.h"
#import "NSData+EncryptAndDecrypt.h"

#define TAG_FIXED_LENGTH_HEADER 1000
#define TAG_RESPONSE_BODY 2000

@implementation IMUtil (Tcp)

- (NSString *)getHostIP
{
#ifndef IM_ENCRYPT_DYNCMIC
    return @"123.57.90.66";
#else
    return [[self getHost] objectForKey:@"ip"];
#endif
}

- (NSInteger)getHostPort
{
#ifndef IM_ENCRYPT_DYNCMIC
    return 9501;
#else
    return [[[self getHost] objectForKey:@"port"] integerValue];
#endif
}

- (NSMutableDictionary *)getHost
{
    static NSMutableDictionary *host = nil;
    if (host == nil) {
        host = [[NSMutableDictionary alloc] init];
    }
    return host;
}

- (void)setHost:(NSDictionary *)info;
{
    [[self getHost] setDictionary:info];
    [[self getHost] setValue:@YES forKey:@"enable"];
}

- (void)startReachability
{
    if (!serverReach) {
        serverReach = [self getReachability];
        [serverReach startNotifier];
        __unsafe_unretained typeof(self) weakSelf = self;
        serverReach.reachableBlock = ^(Reachability *currReach){
            if (![weakSelf->client isConnected] && [AccountHelper getLoginState]) {
                [weakSelf startConnect];
            }
        };
        serverReach.unreachableBlock = ^(Reachability * currReach){
            NetworkStatus status = [currReach currentReachabilityStatus];
            if ([weakSelf->ppTimer isValid]) {
                [weakSelf->ppTimer invalidate];
                weakSelf->ppTimer = nil;
            }
            [weakSelf->client disconnect];
            if(status == NotReachable) {
                //        isConnect = NO;
                [weakSelf postNotification:ResultTypeNetError];
                [weakSelf->root imClientBreakOff];
                
                if (weakSelf->requestArray.count > 0) {
                    for (ImRequestBase *request in weakSelf->requestArray) {
                        [weakSelf checkIsSendMessage:request];
                    }
                    [weakSelf->requestArray removeAllObjects];
                }
            }
        };
    }
}

- (Reachability *)getReachability
{
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    zeroAddress.sin_port = htons([self getHostPort]);
    zeroAddress.sin_addr.s_addr = inet_addr([[self getHostIP] UTF8String]);
    return [Reachability reachabilityWithAddress:&zeroAddress];
}

#pragma mark - 启动socket连接
- (void)startTcpIM
{
    if (client == nil) {
        client = [TcpClient sharedInstance];
        [client setDelegate:self];
    }
    if ([self getHostIP].length > 0) {
        [self startConnect];
    }
}

- (void)startConnect
{
    if (connectTimer.isValid) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    if ([ppTimer isValid]) {
        [ppTimer invalidate];
        ppTimer = nil;
    }
    [client disconnect];
    //
    [self startReachability];
    [client setHost:[self getHostIP] port:[self getHostPort]];
    //
    [self postNotification:ResultTypeConnecting];
    [client connect];
    connectCount ++;
}

/** 尝试重连 */
- (void)restoreConnect
{
    if (connectCount > 0) {
        if (connectTimer.isValid) {
            // do nothing
        } else {
            connectTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(startConnect) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:connectTimer forMode:NSRunLoopCommonModes];
        }
    } else {
        [self startConnect];
    }
}

- (void)startTalk
{
    [MessageBase setUserChatID:[AccountHelper getAccount].chatID];
    [MessageBase setUserID:[AccountHelper getAccount].userID];
    //
    if (![client isConnected]) {
        [self startConnect];
    } else {
        //  TODO MedTree 多传一个Token
        if ([Keychain getValue:@"token"]) {
            [self handleAuth:@{@"token":[Keychain getValue:@"token"]}];
        } else {
            if ([AccountHelper getLoginState]) {
                [root didLoginFromOtherDevice:@"没有获取到token"];
                [client disconnect];
            }
        }
    }
}

#pragma mark TcpClientDelegate
- (void)didSendDataSuccess:(long)tag
{
    if (connectTimer.isValid) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
}

- (void)didReciveData:(NSData *)data withTag:(long)tag
{
    if (connectTimer.isValid) {
        [connectTimer invalidate];
        connectTimer = nil;
    }

    if (data.length >= 8) {
        [self putData:data withTag:tag];
    }
}

- (void)didReadTimeoutWithTag:(long)tag
{
    
}

- (void)didConnectionSuccess:(NSDictionary *)info
{
    connectCount = 0;
    [self startTalk];
    
    [client readDataToLength:8 tag:TAG_FIXED_LENGTH_HEADER];
}

static int timeoutErrorCount;

- (void)didConnectionError:(NSError *)err
{
    if ([ppTimer isValid]) {
        [ppTimer invalidate];
        ppTimer = nil;
    }
    if (err.code == 7) { // 连接拒绝，踢人时用到
        return;
    }
    
    NSLog(@"error ---- %@", err);
    
    // TODO
    if (err) {
        [client disconnect];
        // 如果request里面有数据
        [self postNotification:ResultTypeTCPError];
        if (requestArray.count > 0) {
            for (ImRequestBase *request in requestArray) {
                [self checkIsSendMessage:request];
            }
            
            [requestArray removeAllObjects];
        }
        if (timeoutErrorCount < 1) {
            //登录状态尝试重连
            if ([AccountHelper getLoginState]) {
                [self restoreConnect];
                timeoutErrorCount ++;
            } else {
                //非登录状态取消尝试重连
                if ([connectTimer isValid]) {
                    [connectTimer invalidate];
                    connectTimer = nil;
                }
            }
        } else {
            // TODO 更换IP
            timeoutErrorCount = 0;
            [root connectionErrorWithIP:nil];
        }
    } else {
        if (![client isConnected] && [AccountHelper getLoginState] && [UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            // 超时
            if (timeoutErrorCount < 1) {
                //登录状态尝试重连
                if ([AccountHelper getLoginState]) {
                    [self restoreConnect];
                    timeoutErrorCount ++;
                } else {
                    //非登录状态取消尝试重连
                    if ([connectTimer isValid]) {
                        [connectTimer invalidate];
                        connectTimer = nil;
                    }
                }
            } else {
                // TODO 更换IP
                timeoutErrorCount = 0;
                [root connectionErrorWithIP:nil];
            }
        }
    }
}

#pragma mark - public
- (void)checkConnect
{
    if ([[[self getHost] objectForKey:@"enable"] boolValue]) {
        Reachability *currReach = [self getReachability];
        NetworkStatus status = [currReach currentReachabilityStatus];
        if(status == NotReachable) {
            [self postNotification:ResultTypeNetError];
        } else {
            if ([client isConnected]) {
                if (ppTimer.valid) { // ppTimer 存在说明auth认证通过
                    [self postNotification:ResultTypeSuccess];
                }
            } else {
                if ([self getHostIP]) {
                    [self startConnect];
                } else {
                    [self postNotification:ResultTypeTCPError];
                }
            }
        }
    } else {
        if ([self getHostIP]) {
            [self postNotification:ResultTypeTCPError];
            [self startConnect];
        } else {
            [self postNotification:ResultTypeIPError];
            [root connectionErrorWithIP:nil];
        }
    }
}

#pragma mark - private
- (void)checkIsSendMessage:(ImRequestBase *)request
{
    if (request.msgType == SEND_MSG_REQUEST) {
        MessageDTO *message = [[MessageDTO alloc] init:request.toJson[@"msg"]];
        message.status = MessageFail;
        message.updateTime = [NSDate date];
        [MessageManager updateMessage:message success:nil failure:nil];
        NSError *error = [NSError errorWithDomain:@"network error" code:10 userInfo:nil];
        [root didSendTcpMessage:message error:error];
    }
}

- (void)postNotification:(ResultType)resultType
{
    NSDictionary *userInfo = @{@"status":@(resultType)};
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectTCPStatusChangeNotification object:nil userInfo:userInfo];
}

static NSMutableData *headData;
- (void)putData:(NSData *)data withTag:(long)tag
{
    if (tag == TAG_FIXED_LENGTH_HEADER) {
        NSInteger type = 0;
        [data getBytes:&type range:NSMakeRange(2, 2)];
        type = CFSwapInt16HostToBig((u_int16_t)type);
        //
        NSInteger length = 0;
        [data getBytes:&length range:NSMakeRange(4, 4)];
        length = CFSwapInt32HostToBig((u_int32_t)length);
        [client readDataToLength:length tag:TAG_RESPONSE_BODY];
        headData = [[NSMutableData alloc] initWithData:data];
    }
    else if (tag == TAG_RESPONSE_BODY) {
        [headData appendData:data];
        
        [self didReciveTcpMessage:headData];
        
        [client readDataToLength:8 tag:TAG_FIXED_LENGTH_HEADER];
    }
}

@end
