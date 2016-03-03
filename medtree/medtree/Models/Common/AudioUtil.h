//
//  AudioUtil.h
//  medtree
//
//  Created by 孙晨辉 on 15/6/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServicePrefix.h"

@interface AudioUtil : NSObject

+ (id)shareAudioUtil;

/** 创建录音 */
- (void)createRecordName:(NSString *)name;

/** 设置播放地址 */
- (void)setPlayerUrl:(NSString *)url;

#pragma mark 开始录音
- (void)startRecording;

#pragma mark 结束录音
- (void)stopRecordingWithBlock:(void (^)(NSTimeInterval currentTime, NSString *filePath))stopBlock;

#pragma mark 取消录音
- (void)cancelRecording;

#pragma mark 开始播放
- (void)startPlayingWithSucces:(SuccessBlock)success failure:(FailureBlock)failure;

#pragma mark 结束播放
- (void)stopPlaying;

#pragma mark 是否正在录音
- (BOOL)isRecording;

@end
