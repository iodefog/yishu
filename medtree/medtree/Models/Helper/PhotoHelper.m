//
//  PhotoHelper.m
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "PhotoHelper.h"
#import "MKNetworkEngine.h"
#import "ImageCenter.h"
#import "FileUtil.h"

@implementation PhotoHelper

+ (MKNetworkEngine *)ImageEngine
{
    static MKNetworkEngine *engine = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        engine = [[MKNetworkEngine alloc] initWithHostName:nil];
    });
    return engine;
}

+ (void)getPhoto:(NSString *)photoID completionHandler:(CompletionBlock)completionHandler errorHandler:(ErrorBlock)errorHandler progressHandler:(ProgressBlock)progressHandler
{
    NSURL *url = [NSURL URLWithString:photoID];
    //
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:[NSURLRequest requestWithURL:url]];
    if (response == nil) {
        MKNetworkEngine *engine = [PhotoHelper ImageEngine];
        MKNetworkOperation *op =
        [engine imageAtURL:url completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            if (fetchedImage) {
                completionHandler(@{@"fetchedImage":fetchedImage,@"photoID":photoID});
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            errorHandler(@{@"error":error,@"photoID":photoID});
        }];
        [op onDownloadProgressChanged:^(double progress) {
            progressHandler(@{@"progress":[NSNumber numberWithDouble:progress],@"photoID":photoID});
        }];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *fetchedImage = [[UIImage alloc] initWithData:response.data];
            if (fetchedImage) {
                completionHandler(@{@"fetchedImage":fetchedImage,@"photoID":photoID});
            } else {
                errorHandler(@{@"error":@"error",@"photoID":photoID});
            }
        });
    }
}

/*
+ (void)getIcon:(NSString *)photoID completionHandler:(CompletionBlock)completionHandler errorHandler:(ErrorBlock)errorHandler progressHandler:(ProgressBlock)progressHandler
{
    MKNetworkEngine *engine = [PhotoHelper ImageEngine];
    NSURL *url = [NSURL URLWithString:photoID];
    //
    NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:[NSURLRequest requestWithURL:url]];
    if (response == nil) {
        MKNetworkOperation *op =
        [engine imageAtURL:url completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            if (fetchedImage) {
                completionHandler(fetchedImage,photoID);
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            errorHandler(error);
        }];
        [op onDownloadProgressChanged:^(double progress) {
            progressHandler(progress);
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *fetchedImage = [[UIImage alloc] initWithData:response.data];
            if (fetchedImage) {
                completionHandler(fetchedImage,photoID);
            }
        });
    }
}
*/

@end
