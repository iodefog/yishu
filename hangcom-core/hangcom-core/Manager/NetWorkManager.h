//
//  NetWorkManager.h
//  hangcom-core
//
//  Created by lyuan on 14-7-16.
//  Copyright (c) 2014年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#pragma mark NetWorkManagerDelegate
/**
 *
 * 您的应用程序需要实现此协议，当网络发生变化时候，与用户交互
 *
 */
@protocol NetWorkManagerDelegate

@required
- (void)netWorkStatusWillChange:(NetworkStatus)status;

@optional
- (void)netWorkStatusWillEnabled;
- (void)netWorkStatusWillEnabledViaWifi;
- (void)netWorkStatusWillEnabledViaWWAN;
- (void)netWorkStatusWillDisconnection;
@end

#pragma mark NetWorkManager

@interface NetWorkManager : NSObject <UIApplicationDelegate>
{
@private
    Reachability *rech;
    
    /** 标识网络是否活跃 **/
    BOOL _netWorkIsEnabled;
    
    /** 设备链接网络的方式 **/
    NetworkStatus _witchNetWorkerEnabled;
    
    /** 代理 **/
    id<NetWorkManagerDelegate> delegate;
}
///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (readonly, getter = witchNetWorkerEnabled) NetworkStatus _witchNetWorkerEnabled;
///!!!NOTICE:WNEH YOU WANT TO GET THIS,YOU MUST START THE WATCH FIRST
@property (readonly, getter = netWorkIsEnabled) BOOL _netWorkIsEnabled;
@property (nonatomic, retain) id<NetWorkManagerDelegate> delegate;
/**
 *
 * 获取网络管理器
 *
 */
+ (id)sharedManager;
/**
 *
 * 防止以其他方法创建第二实例
 *
 */
+ (id)allocWithZone:(NSZone *)zone;
/**
 *
 * 检测当前网络状态
 *
 */
- (NetworkStatus)checkNowNetWorkStatus;
/**
 *
 * 开始检测网络
 *
 */
- (BOOL)startNetWorkeWatch;
/**
 *
 * 停止检测网络
 *
 */
- (void)stopNetWorkWatch;

@end

#pragma mark NetWorkManagerPrivateMethod
@interface NetWorkManager(private)

/**
 *
 * 当网络发生变化时
 *
 */
- (void)reachabilityChanged:(NSNotification *)note;

@end
