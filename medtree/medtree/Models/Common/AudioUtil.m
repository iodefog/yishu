//
//  AudioUtil.m
//  medtree
//
//  Created by 孙晨辉 on 15/6/30.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "AudioUtil.h"
#import "amrFileCodec.h"
#import "FileUtil.h"
#import <AVFoundation/AVFoundation.h>

@interface AudioUtil () <AVAudioPlayerDelegate>
{
    NSString *filePath;
    NSString *amrPath;
    NSString *path;
    double      beginTime;
}

@property (nonatomic, strong) NSString *urlPath;
@property (nonatomic, assign) NSTimeInterval currentTime;

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) SuccessBlock playBlock;
@property (nonatomic, copy) FailureBlock failureBlock;

@end

@implementation AudioUtil

+ (id)shareAudioUtil
{
    static AudioUtil *audioUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioUtil = [[AudioUtil alloc] init];
    });
    return audioUtil;
}

- (void)createRecordName:(NSString *)name
{
    if (path == nil) {
        path = [FileUtil getAudioPath];
    }
    if (name == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        name = [dateFormatter stringFromDate:[NSDate date]];
        filePath = [[NSString alloc] initWithFormat:@"%@/%@.caf", path, name];
        amrPath = [[NSString alloc] initWithFormat:@"%@/%@.amr", path, name];
    } else {
        filePath = [[NSString alloc] initWithFormat:@"%@/%@.caf", path, name];
        amrPath = [[NSString alloc] initWithFormat:@"%@/%@.amr", path, name];
    }
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory :AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    _recorder = [[AVAudioRecorder alloc] initWithURL:url settings:[self recorderSettings] error:&error];
    if (error) {
        NSLog(@"录音机实例化失败 - %@", error.localizedDescription);
        // TODO
    } else {
        _urlPath = amrPath;
    }
    
}

#pragma mark 开始录音
- (void)startRecording
{
    if ([_player isPlaying]) {
        [_player stop];
    }
    if ([_recorder isRecording]) {
        return;
    } else {
        _recorder.meteringEnabled = YES;
        [_recorder record];
    }
    beginTime = [NSDate date].timeIntervalSince1970;
    NSLog(@"recorder ------ %d", [_recorder isRecording]);
}

#pragma mark 结束录音
- (void)stopRecordingWithBlock:(void (^)(NSTimeInterval, NSString *))stopBlock
{
    if ([_recorder isRecording]) {
        [_recorder stop];
        double stopTime = [NSDate date].timeIntervalSince1970;
        _currentTime = stopTime - beginTime;
        _recorder = nil;
    }
    
    NSData *data = EncodeWAVEToAMR([NSData dataWithContentsOfFile:filePath], 1, 16);
    if (data != nil) {
        NSFileManager *nfm = [NSFileManager defaultManager];
        BOOL tf = [nfm createFileAtPath:amrPath contents:data attributes:nil];
        if (tf == YES) {
            NSLog(@"record %@", amrPath);
        }
        tf = [nfm removeItemAtPath:filePath error:nil];
        if (tf == YES) {
            NSLog(@"delete %@", filePath);
        }
    }
    if (stopBlock) {
        stopBlock(_currentTime, amrPath);
    }
    _currentTime = 0;
    amrPath = @"";
}

#pragma mark 取消录音
- (void)cancelRecording
{
    if ([_recorder isRecording]) {
        [_recorder stop];
        [_recorder deleteRecording];
        _recorder = nil;
    }
}

// TODO
#pragma mark 开始播放
- (void)startPlayingWithSucces:(SuccessBlock)success failure:(FailureBlock)failure
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    NSData *data = DecodeAMRToWAVE([NSData dataWithContentsOfFile:self.urlPath]);
//    NSData *data = [NSData dataWithContentsOfFile:self.urlPath];
    if (data != nil) {
        _player = [[AVAudioPlayer alloc] initWithData:data fileTypeHint:@"amr" error:nil];
        _player.delegate = self;
        [_player prepareToPlay];
        [_player setVolume:1.0f];
        [_player play];
        _playBlock = success;
        _failureBlock = failure;
    }
}

#pragma mark 结束播放
- (void)stopPlaying
{
    if ([_player isPlaying]) {
        [_player stop];
    }
}

#pragma mark 是否正在录音
- (BOOL)isRecording
{
    return [_recorder isRecording];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (_playBlock) {
        _playBlock(nil);
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (_failureBlock) {
        _failureBlock(error, nil);
    }
}

#pragma mark - private
#pragma mark 录音设置
- (NSDictionary *)recorderSettings
{
    NSMutableDictionary *setting = [[NSMutableDictionary alloc] init];
    //音频格式
    [setting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //音频采样率
    [setting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    //音频通道数
    [setting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性音频的位深度
    [setting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];


    [setting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];
    [setting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [setting setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    
    return setting;
}

#pragma mark - public 
- (void)setPlayerUrl:(NSString *)url
{
    self.urlPath = url;
}

@end
