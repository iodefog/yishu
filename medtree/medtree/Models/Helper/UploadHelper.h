//
//  UploadHelper.h
//  medtree
//
//  Created by 孙晨辉 on 15/7/1.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadHelper : NSObject

- (void)uploadImageFile:(NSString *)filePath image:(UIImage *)image params:(NSDictionary *)params success:(void (^)(NSString *path, NSDictionary *ret, UIImage *image))success failure:(void (^)(NSError *error))failure;

- (void)uploadVoiceFile:(NSString *)filePath duration:(NSTimeInterval)duration params:(NSDictionary *)params success:(void (^)(NSString *path, NSDictionary *ret, NSTimeInterval duration))success failure:(void (^)(NSError *error))failure;

@end
