//
//  UncaughtExceptionHelper.h
//  medtree
//
//  Created by 孙晨辉 on 15/11/19.
//  Copyright © 2015年 sam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHelper : NSObject

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler *)getHandler;
+ (void)TakeException:(NSException *) exception;

@end
