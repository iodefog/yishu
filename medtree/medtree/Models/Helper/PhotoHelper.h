//
//  PhotoHelper.h
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(NSDictionary *dict);
typedef void (^ProgressBlock)(NSDictionary *dict);
typedef void (^ErrorBlock)(NSDictionary *dict);

@interface PhotoHelper : NSObject
{
    
}

+ (void)getPhoto:(NSString *)photoID completionHandler:(CompletionBlock)completionHandler errorHandler:(ErrorBlock)errorHandler progressHandler:(ProgressBlock)progressHandler;


//+ (void)getIcon:(NSString *)photoID completionHandler:(CompletionBlock)completionHandler errorHandler:(ErrorBlock)errorHandler progressHandler:(ProgressBlock)progressHandler;

 
@end
