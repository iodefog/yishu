//
//  CHFileDownloader.h
//  大文件下载
//
//  Created by 孙晨辉 on 15/1/29.
//  Copyright (c) 2015年 孙晨辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHFileDownloader : NSObject

/** 需要下载的文件路径 */
@property (nonatomic, copy) NSString *url;
/** 文件的存储路径 */
@property (nonatomic, copy) NSString *destPath;
/** 是否正在下载 */
@property (nonatomic, readonly, getter = isDownloading) BOOL downloading;
/** 监听下载进度 */
@property (nonatomic, copy) void (^progressHandler)(double progress);
/** 监听下载完毕 */
@property (nonatomic, copy) void (^completionHandler)(NSString *path);
/** 监听下载失败 */
@property (nonatomic, copy) void (^failureHandler)(NSError *error);

/** 开始（恢复）下载 */
- (void)start;

/** 暂停下载 */
- (void)pause;

@end
