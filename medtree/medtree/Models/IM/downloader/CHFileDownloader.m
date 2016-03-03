//
//  CHFileDownloader.m
//  大文件下载
//
//  Created by 孙晨辉 on 15/1/29.
//  Copyright (c) 2015年 孙晨辉. All rights reserved.
//

#import "CHFileDownloader.h"

@interface CHFileDownloader() <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSFileHandle *writeHandle;
/** 当前已下载长度 */
@property (nonatomic, assign) long long currentLength;
/** 完整文件总长度 */
@property (nonatomic, assign) long long totalLength;
/** 连接对象 */
@property (nonatomic, strong) NSURLConnection *conn;

@end
@implementation CHFileDownloader

/** 开始下载 */
- (void)start
{
    NSURL *url = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置请求头信息
    NSString *value = [NSString stringWithFormat:@"bytes=%lld-",self.currentLength];
    [request setValue:value forHTTPHeaderField:@"Range"];
    self.conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    _downloading = YES;
}

/** 恢复下载 */
- (void)pause
{
    [self.conn cancel];
    self.conn = nil;
    
    _downloading = NO;
}

#pragma mark - NSURLConnectionDataDelegate
/** 请求错误的时候调用 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.writeHandle closeFile];
    if (self.failureHandler)
    {
        self.failureHandler(error);
    }
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr removeItemAtPath:self.destPath error:nil];
}
/** 当接受到服务器的响应就会调用 */
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.totalLength) return;

    self.totalLength = response.expectedContentLength;
  
    //创建一个空的文件到沙盒中
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr createFileAtPath:self.destPath contents:nil attributes:nil];
    //创建写数据的文件句柄
    self.writeHandle = [NSFileHandle fileHandleForWritingAtPath:self.destPath];
}
/** 当接受到服务器的数据就会调用(可能会调用N次) */
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //累加长度
    self.currentLength += data.length;
    //显示进度
    double progress = (double)self.currentLength / self.totalLength;
    if (self.progressHandler)
    {//传递进度值
        self.progressHandler(progress);
    }
    
    //移动到文件的尾部
    [self.writeHandle seekToEndOfFile];
    //从当前移动的位置（文件尾部）开始写入数据
    [self.writeHandle writeData:data];
}
/** 当服务器数据接受完毕后就会调用 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.totalLength = 0;
    self.currentLength = 0;
    //关闭连接，保留会出现内存泄露
    [self.writeHandle closeFile];
    self.writeHandle = nil;
    if (self.completionHandler)
    {
        self.completionHandler(self.destPath);
    }
}

@end
