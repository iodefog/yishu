//
//  BaseConfig.m
//  hangcom-ui
//
//  Created by sam on 8/8/14.
//  Copyright (c) 2014 sam. All rights reserved.
//

#import "BaseConfig.h"

@implementation BaseConfig

+ (CGFloat)getSysVer
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (CGFloat)getOffset
{
    return ([BaseConfig getSysVer] >= 7.0)? 20:0;
}

@end
