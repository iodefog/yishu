//
//  UploadUtil.h
//  QiniuDemo
//
//  Created by sam on 5/13/14.
//  Copyright (c) 2014 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadDelegate.h"

@interface UploadUtil : NSObject <UploadDelegate>

+ (void)uploadFile:(NSString *)filePath header:(NSDictionary *)header params:(NSDictionary *)params delegate:(id<UploadDelegate>)delegate;
+ (void)setHost:(NSString *)host;
+ (void)setAction:(NSString *)action;
+ (void)setUploadKey:(NSString *)key;
+ (void)setContentType:(NSString *)type;

@end
