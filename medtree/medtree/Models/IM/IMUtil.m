//
//  IMUtil.m
//  medtree
//
//  Created by sam on 8/12/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "IMUtil.h"
#import "IMUtil+Public.h"
#import "MessageManager.h"
#import "MessageManager+Notification.h"
#import "CommonManager.h"
#import "MessageDTO.h"
#import "UserDTO.h"
#import "AccountHelper.h"
#import "DateUtil.h"
#import "ImageCenter.h"
#import "FileUtil.h"
#import "JSONKit.h"
#import "StatisticHelper.h"
#import "IMUtil+Public.h"
#import "MessageTypeProxy.h"
#import "MedGlobal.h"
#import "CHFileDownloader.h"
#import "FileUtil.h"
#import "AudioUtil.h"
#import "Messages.h"


#define USE_IM_TCP

NSString *const kDeltaTime = @"DELTSTIME";

@implementation IMUtil

+ (IMUtil *)sharedInstance
{
    static IMUtil *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IMUtil alloc] init];
    });
    return sharedInstance;
}

- (void)startIM
{
    [self startTcpIM];
}

// 发送消息
- (MessageDTO *)sendMessage:(MessageDTO *)message
{
    message.status = MessagePending;
    message = [self sendTcpMessage:message];
    
    return message;
}

// 重发消息
- (MessageDTO *)resendMessage:(MessageDTO *)message
{
//    //
    [MessageManager markMessageStatus:message.messageID status:MessagePending];
//    //
    return [self sendMessage:message];
}

- (void)playAudio:(MessageDTO *)message success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSDictionary *content = [message.content objectFromJSONString];
    
    NSString *fileId = [[content objectForKey:@"voice"] objectForKey:@"path"];
    NSString *fileName = [fileId stringByAppendingString:@".amr"];
    NSString *destPath = [[FileUtil getAudioPath] stringByAppendingPathComponent:fileName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:destPath]) { // 有就播放
        [self playAudioDestpath:destPath success:success failure:failure];
    } else { // 没有就下载
        CHFileDownloader *downloader = [[CHFileDownloader alloc] init];
        downloader.url = [NSString stringWithFormat:@"%@/%@", [MedGlobal getVoiceHostWithCompacted:NO], fileId];
        downloader.destPath = destPath;
        __weak typeof(self) weakSelf = self;
        downloader.completionHandler = ^(NSString *destPath) {
            [weakSelf playAudioDestpath:destPath success:success failure:failure];
        };
        downloader.failureHandler = ^(NSError *error) {
            failure(error, nil);
        };
        [downloader start];
    }
}

- (void)playAudioDestpath:(NSString *)destPath success:(SuccessBlock)success failure:(FailureBlock)failure
{
    NSData *data = [NSData dataWithContentsOfFile:destPath];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str floatValue] == 404) {
        failure(nil, nil);
    } else {
        AudioUtil *audioUtil = [AudioUtil shareAudioUtil];
        [audioUtil setPlayerUrl:destPath];
        [audioUtil startPlayingWithSucces:success failure:failure];
    }
}

- (void)registerRootController:(id<ChatManagerDelegate>)uvc
{
    root = uvc;
    //
    [StatisticHelper addAction:StatisticAction_MT_APP_START attr:nil];
}

- (void)logoutIM
{
    if (connectTimer.isValid) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    if (ppTimer.isValid) {
        [ppTimer invalidate];
        ppTimer = nil;
    }
    [requestArray removeAllObjects];
    [client disconnect];
}

@end
