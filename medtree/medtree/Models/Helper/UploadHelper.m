//
//  UploadHelper.m
//  medtree
//
//  Created by 孙晨辉 on 15/7/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "UploadHelper.h"
#import "UploadUtil.h"
#import "MedGlobal.h"
#import "Request.h"

@interface UploadHelper () <UploadDelegate>
{
    UIImage                 *orginImage;
    NSTimeInterval          rideoLength;
}

@property (nonatomic, copy) void (^uploadVoiceSuccessBlock)(NSString *path, NSDictionary *ret, NSTimeInterval duration);
@property (nonatomic, copy) void (^uploadImageSuccessBlock)(NSString *path, NSDictionary *ret, UIImage *image);
@property (nonatomic, copy) void (^uploadErrorBlock)(NSError *error);

@end

@implementation UploadHelper

- (void)uploadImageFile:(NSString *)filePath image:(UIImage *)image params:(NSDictionary *)params success:(void (^)(NSString *path, NSDictionary *ret, UIImage *image))success failure:(void (^)(NSError *error))failure
{
    [UploadUtil setHost:[MedGlobal getHost]];
    [UploadUtil setAction:@"file/upload?type=2"];
    [UploadUtil uploadFile:filePath header:[Request getHeader] params:nil delegate:self];
    self.uploadImageSuccessBlock = success;
    self.uploadErrorBlock = failure;
    orginImage = image;
}

- (void)uploadVoiceFile:(NSString *)filePath duration:(NSTimeInterval)duration params:(NSDictionary *)params success:(void (^)(NSString *path, NSDictionary *ret, NSTimeInterval duration))success failure:(void (^)(NSError *error))failure
{
    [UploadUtil setHost:[MedGlobal getHost]];
    [UploadUtil setAction:@"file/upload?type=3"];
    [UploadUtil uploadFile:filePath header:[Request getHeader] params:nil delegate:self];
    self.uploadVoiceSuccessBlock = success;
    self.uploadErrorBlock = failure;
    rideoLength = duration;
}

#pragma mark - UploadDelegate
- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    NSLog(@"ret ---- %@", ret);
    NSLog(@"filePath ---- %@", filePath);
    if (self.uploadImageSuccessBlock && orginImage) {
        self.uploadImageSuccessBlock(filePath, ret, orginImage);
        self.uploadVoiceSuccessBlock = nil;
    }
    if (self.uploadVoiceSuccessBlock) {
        self.uploadVoiceSuccessBlock(filePath, ret, rideoLength);
        self.uploadVoiceSuccessBlock = nil;
    }
}

// Upload failed.
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    if (self.uploadErrorBlock) {
        self.uploadErrorBlock(error);
        self.uploadErrorBlock = nil;
    }
}

@end
