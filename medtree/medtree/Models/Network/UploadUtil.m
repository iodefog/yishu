//
//  UploadUtil.m
//  QiniuDemo
//
//  Created by sam on 5/13/14.
//  Copyright (c) 2014 Qiniu. All rights reserved.
//

#import "UploadUtil.h"
#import "MKNetworkEngine.h"

@interface UploadUtil () {
    id<UploadDelegate> delegate;
    NSString *host;
    NSString *action;
    NSString *uploadKey;
    NSString *contentType;
}

@end

@implementation UploadUtil

+ (void)uploadFile:(NSString *)filePath header:(NSDictionary *)header params:(NSDictionary *)params delegate:(id<UploadDelegate>)delegate
{
    [[UploadUtil shareInstance] setDelegate:delegate];
    [[UploadUtil shareInstance] uploadFile:filePath header:header params:params];
}

+ (void)setHost:(NSString *)host
{
    [[UploadUtil shareInstance] setHost:host];
}

+ (void)setAction:(NSString *)action
{
    [[UploadUtil shareInstance] setAction:action];
}

+ (void)setUploadKey:(NSString *)key
{
    [[UploadUtil shareInstance] setUploadKey:key];
}

+ (void)setContentType:(NSString *)type
{
    [[UploadUtil shareInstance] setContentType:type];
}

+ (UploadUtil *)shareInstance
{
    static UploadUtil *upload = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        upload = [[UploadUtil alloc] init];
    });
    return upload;
}

- (void)setHost:(NSString *)value
{
    host = value;
}

- (NSString *)getHost
{
    if (host == nil) {
        host = @"";
    }
    return host;
}

- (void)setAction:(NSString *)value
{
    action = value;
}

- (NSString *)getAction
{
    if (action == nil) {
        action = @"";
    }
    return action;
}

- (void)setUploadKey:(NSString *)key
{
    uploadKey = key;
}

- (NSString *)getUploadKey
{
    if (uploadKey == nil) {
        uploadKey = @"file";
    }
    return uploadKey;
}

- (void)setContentType:(NSString *)type
{
    contentType = type;
}

- (NSString *)getContentType
{
    if (contentType == nil) {
        contentType = @"text/html";
    }
    return contentType;
}

- (void)setDelegate:(id<UploadDelegate>)target
{
    delegate = target;
}

- (void)unreachableHost:(NSString *)theFilePath error:(NSError *)error
{
    if ([delegate respondsToSelector:@selector(unreachableHost:error:)] == YES) {
        [delegate performSelector:@selector(unreachableHost:error:) withObject:theFilePath withObject:error];
    }
}

- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
    [delegate uploadProgressUpdated:theFilePath percent:percent];
    //
//    NSString *progressStr = [NSString stringWithFormat:@"Progress Updated: - %f\n", percent];
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    [delegate uploadSucceeded:theFilePath ret:ret];
    //
//    NSString *succeedMsg = [NSString stringWithFormat:@"Upload Succeeded: - Ret: %@\n", ret];
}

- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    [delegate uploadFailed:theFilePath error:error];
    //
//    NSString *failMsg = [NSString stringWithFormat:@"Upload Failed: %@  - Reason: %@", theFilePath, error];

}

/* 
// AFNetworking
- (void)uploadFile:(NSString *)filePath params:(NSDictionary *)params
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableURLRequest *request = [manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                   URLString:[self getHost]
                                                                                  parameters:params
                                                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                       [formData appendPartWithFileURL:fileURL name:[self getUploadKey] error:nil];
                                                                   } error:nil];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:[self getContentType]];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request
                                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                          NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                                                                          NSString *str = [[NSString alloc] initWithData:responseObject encoding:enc];
                                                                          NSLog(@"%@", str);
                                                                          NSDictionary *ret = [NSJSONSerialization JSONObjectWithData:[operation responseData] options:kNilOptions error:nil];
                                                                          [self uploadSucceeded:filePath ret:ret];
                                                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                          [self uploadFailed:filePath error:error];
                                                                      }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        [self uploadProgressUpdated:filePath percent:((float)totalBytesWritten / (float)totalBytesExpectedToWrite)];
    }];
    [manager.operationQueue addOperation:operation];
}
 */

// MKNetwork
- (void)uploadFile:(NSString *)filePath header:(NSDictionary *)header params:(NSDictionary *)params
{
    MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[self getHost] apiPath:@"v2" customHeaderFields:header];
    MKNetworkOperation *op = [engine operationWithPath:[self getAction] params:params httpMethod:@"POST" ssl:YES];
    
    [op addParams:params];
    //
    [op addFile:filePath forKey:[self getUploadKey]];
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"upload:%@\n%@", filePath, [completedOperation responseString]);
        [self uploadSucceeded:filePath ret:[completedOperation responseJSON]];
    } errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
        NSLog(@"uploadError:%@\n%@", filePath, [errorOp responseString]);
        [self uploadFailed:filePath error:error];
    }];
    
    [engine enqueueOperation:op];
}


@end
