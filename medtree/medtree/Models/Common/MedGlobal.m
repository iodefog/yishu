//
//  Global.m
//  find
//
//  Created by sam on 13-5-13.
//  Copyright (c) 2013年 sam. All rights reserved.
//

#import "MedGlobal.h"
#import "DateUtil.h"
#import "ColorUtil.h"
#import <SystemConfiguration/SCNetworkReachability.h>

#define DISPATCH_QUEUE_DB "DB"
#define DISPATCH_QUEUE_NET "NET"

NSString *const TESTENVIRONMENT = @"TESTENVIRONMENT";

@implementation MedGlobal : NSObject

+ (CGFloat)getSysVer
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)getPhone
{
    NSString *phone = @"iPhone4";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGSize size = [[UIScreen mainScreen] currentMode].size;
        if (size.width == 320) {
            phone = @"iPhone3";
        } else if (size.width == 640) {
            if (size.height > 960) {
                phone = @"iPhone5";
            } else {
                phone = @"iPhone4";
            }
        } else if (size.width == 750) {
            phone = @"iPhone6";
        } else if (size.width == 1242) {
            phone = @"iPhone6plus";
        }
    }
    return phone;
}

static BOOL isBig;
static BOOL isIphone6Plus;

+ (void)checkBigPhone
{
    NSString *iphoneStr = [MedGlobal getPhone];
    
    if ([iphoneStr isEqualToString:@"iPhone6"] || [iphoneStr isEqualToString:@"iPhone6plus"]) {
        isBig = YES;
    } else {
        isBig = NO;
    }
    
    isIphone6Plus = [iphoneStr isEqualToString:@"iPhone6plus"] ? YES : NO;
    
}

+ (BOOL)isBigPhone
{
    return isBig;
}

+ (BOOL)isPhone6Plus
{
    return isIphone6Plus;
}

+ (CGFloat)getOffset
{
    return ([MedGlobal getSysVer] >= 7.0)? 20:0;
}

+ (UIFont *)getTinyLittleFont
{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)getTinyLittleFont_10
{
    return [UIFont systemFontOfSize:10];
}

+ (UIFont *)getLittleFont
{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)getMiddleLittleFont
{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)getMiddleFont
{
    return [UIFont systemFontOfSize:16];
}

+ (UIFont *)getLargeFont
{
    return [UIFont systemFontOfSize:18];
}

+ (UIFont *)getBoldLargeFont
{    
    return [UIFont boldSystemFontOfSize:18];
}

+ (UIColor *)getNameLableTextCommonColor
{
    return [ColorUtil getColor:@"256666" alpha:1];
}

+ (UIColor *)getTitleTextCommonColor
{
    return [ColorUtil getColor:@"111726" alpha:1];
}

+ (NSString *)getHost
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue]) {
        return @"test.api.medtree.cn";
    } else {
        return @"api.medtree.cn";
    }
//    return @"api.medtree.cn";
//    return @"192.168.31.186:9000";
}

+ (NSString *)getHost0
{
    return @"medtree.cn";
}

+ (NSString *)getCollectHost
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue]) {
        return @"http://test.stats.medtree.cn";
    } else {
        return @"https://stats.medtree.cn";
    }
}

+ (NSString *)getJobUrl
{
    BOOL isHouse = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"InHouse"] boolValue];
    if (isHouse) {
        return @"http://test.job.medtree.cn";
    }
    return @"https://job.medtree.cn";
}

/*检查网络状态*/
+ (BOOL)checkNetworkStatus
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags) {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable&&!needsConnection) ? YES : NO;
}

+ (NSString *)getPicHost:(Image_Type)type
{
    if (type == ImageType_Small) {
        return [NSString stringWithFormat:@"%@/img/120x120", [MedGlobal getPicHost]];
    } else if (type == ImageType_Big) {
        return [NSString stringWithFormat:@"%@/img/400x400", [MedGlobal getPicHost]];
    } else if (type == ImageType_Map) {
        return [NSString stringWithFormat:@"%@/img/320x100", [MedGlobal getPicHost]];
    } else if (type == ImageType_200_150) {
        return [NSString stringWithFormat:@"%@/img/200x150", [MedGlobal getPicHost]];
    } else if (type == ImageType_224_168) {
        return [NSString stringWithFormat:@"%@/img/224x168", [MedGlobal getPicHost]];
    } else if (type == ImageType_120_90) {
        return [NSString stringWithFormat:@"%@/img/240x180", [MedGlobal getPicHost]];
    } else {
        return [NSString stringWithFormat:@"%@/img/orig", [MedGlobal getPicHost]];
    }
}

+ (NSString *)getVoiceHostWithCompacted:(BOOL)compacted
{
    if (compacted) {
        return [NSString stringWithFormat:@"%@/audio/mp3", [MedGlobal getPicHost]];
    }
    return [NSString stringWithFormat:@"%@/audio/orig", [MedGlobal getPicHost]];
}

static NSString *picHost;

+ (void)setPicHost:(NSString *)host
{
    picHost = host;
}

+ (NSString *)getPicHost
{
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:TESTENVIRONMENT] boolValue]) {
        picHost = @"http://test.st.medtree.cn";
    } else {
        picHost = @"http://st.medtree.cn";
    }
    return picHost;
}

+ (void)setSplashImages:(NSArray *)array
{
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"splashImages"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray *)getSplashImages
{
    NSMutableArray *splashImages = [NSMutableArray array];
    [splashImages addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"splashImages"]];
    return splashImages;
}

/*GCD QUEUE begin*/

static dispatch_queue_t dispatchDBQueue;
static dispatch_queue_t dispatchNETQueue;
+ (void)initQueue
{
    dispatchDBQueue = dispatch_queue_create(DISPATCH_QUEUE_DB, DISPATCH_QUEUE_CONCURRENT);
    dispatchNETQueue = dispatch_queue_create(DISPATCH_QUEUE_NET, DISPATCH_QUEUE_CONCURRENT);
}

+ (dispatch_queue_t)getDbQueue
{
    return dispatchDBQueue;
}

+ (dispatch_queue_t)getNetQueue
{
    return dispatchNETQueue;
}

/*GCD QUEUE end*/

@end
